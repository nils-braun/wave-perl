#!/usr/bin/perl

=pod

=head1 NAME

WAVE - Packet um WAVE-Eingaben und -Ausgaben zu steuern

=head1 SYNOPSIS

use WAVE;
# Pfad zur WAVE Executable, muss vorhanden sein
my $WAVE_EXE = "/media/Daten/Projects/Perl/wave.exe";
# Ordner für die späteren Resultate, wird bei nicht Vorhandensein erstellt
my $RESULT_DIR = "/media/Daten/Projects/Perl/test";

TODO

=head1 DESCRIPTION

Stellt Funktionen zum Bearbeiten der wave.in-Datei, zum Ausfuehren von WAVE und zum spaeteren
Auswerten der Ausgabedateien bereit.

=head2 Methoden

=over 12

=item C<setValue($key, $value)>

Aendert den C<$key> in wave.in in C<$value> um. Dabei wird keine Datei geaendert,
sondern nur die interne Darstellung.

=item C<writeWaveIn($tempdir)>

Schreibt die internen wave.in-Daten in eine wave.in-Datei
im Ordner C<$tempdir>.

=back 

=head1 AUTHOR

Nils Braun I<area51.nils@googlemail.com>

head1 ACKNOWLEDGEMENTS

Das Programm WAVE ist geschrieben von Michael Scheer. Für weitere Informationen
ueber Lizenzen, siehe dort.

=cut

package WAVE;

use strict;
use warnings;
use POSIX;
use WAVE::waveIn;
use Math::Trig;

require "WAVE/waveSub.pl";

# use PDL::IO::Misc;

my $DEBUG = 0;

use File::Temp qw(tempdir);
use File::Path qw(remove_tree);
use IPC::Open3;

# Konstanten
# ------------------------------------------------------------ #
# Ordnerstrukturen und Pfade
# Pfad zur WAVE Executable, muss vorhanden sein
# Neue wave.exe funktioniert anders?????
my $WAVE_EXE = "/home/braun/Programme/wave/wave/bin/wave.exe.bkp";

# Ordner für die späteren Resultate, wird bei nicht Vorhandensein erstellt
our $RESULT_DIR = "";

# Ordner für die Berechnungen. Falls nicht angegeben, wird ein temporärer Ordner erstellt.
our $WORKING_DIR = "";

# Variable zum Speichern des temporären Ordners.
my $TEMP_DIR = "";

# Datei mit WAVE-artigen Magnetfeldwerten. Wird benutzt falls angegeben.
our $MAGNET_FILE = "";

# Suffix, welcher vor jede erstelle Datei angehängt wird. Wird benutzt falls angegeben.
our $SUFFIX = "";

# Frei wählbarer Text, welcher in jeder Ausgabedatei erscheint. Bei Zeilenumbrüchen auf "#" am Anfang achten.
our $USER_TEXT = "";

# Flags, ob Daten geschrieben werden (auf 0 setzen in Scriptmodus)
our $flagWriteTrajectory = 1;
our $flagWriteSpectrum = 1;
our $flagWriteLog = 1;
our $flagDeleteTempDir = 0;
our $flagOwnParticleFile = 0; # TODO

# Inhalt der Teilchendatei, welcher entweder gesetzt wird oder neu kreiert
my $particleData = "";

# ------------------------------------------------------------ #
# Funktion setValue(key, value)
# Verändert einen Wert im wave.in-Hash. Bricht ab, falls es den Key nicht gibt.
# Parameter:
# key: Welche Variable gesetzt wird.
# value: Auf welchen Wert die Variable gesetzt wird.

sub setValue {

    my ( $key, $value ) = @_;

    if ( exists $waveInArray{"$key"} ) {
        $waveInArray{"$key"} = "$value";
    }
    else {
        die(
"(EE)\t (SUFFIX $SUFFIX) Can't change $key in wave.in, because key does not exist! Abort."
        );
    }
}

# ------------------------------------------------------------ #
# Funktion getValue(key)
# Gibt einen Wert im wave.in-Hash zurück. Bricht ab, falls es den Key nicht gibt.
# Parameter:
# key: Welche Variable abgerufen wird.

sub getValue {

    my ($key) = @_;

    if ( exists $waveInArray{"$key"} ) {
        return $waveInArray{"$key"};
    }
    else {
        die(
"(EE)\t (SUFFIX $SUFFIX) Can't get $key from wave.in, because key does not exist! Abort."
        );
    }
}

# ------------------------------------------------------------ #
# Funktion writeWaveIn(workingDir)
# Werte in eine wave.in-Datei schreiben, welche sich im TEMP_DIR befindet. Achtung: vorherige Dateien werden überschrieben.

sub writeWaveIn {

    open( my $waveconfigFileHandle, ">", "$TEMP_DIR/wave.in" )
      or die "(EE)\t Can't open file $TEMP_DIR/wave.in: $!. Abort.";

    foreach (@waveIn) {
        if ( $_ =~ /^[\s]*([\w|\(\)]+)=[\s]*([^!]*)(.*)$/ ) {
            printf $waveconfigFileHandle "\t$1 = %s$3\n", $waveInArray{"$1"};
        }
        else {
            print $waveconfigFileHandle "$_\n";
        }
    }

    close($waveconfigFileHandle);
}

# ------------------------------------------------------------#
# Funktion prepareFolders()
# Überprüfung der Ordnerstruktur
# Die Ordner werden auf Existenz überprüft und
# wenn nötig erstellt

sub prepareFolders {

    if ( !-e "$WAVE_EXE" ) {
        die(
"(EE)\t (SUFFIX $SUFFIX) Can't find wave.exe in $WAVE_EXE or it is not executable: $!. Abort."
        );
    }

    if ( !-d "$RESULT_DIR" ) {
        print(
"(WW)\t (SUFFIX $SUFFIX) Can't find $RESULT_DIR. Folder will be created.\n"
        );
        mkpath "$RESULT_DIR"
          or die(
            "(EE)\t Can't create folder $RESULT_DIR: $!. Abort."
          );
    }

	if ( !-d "$RESULT_DIR/log" ) {
		mkdir "$RESULT_DIR/log"
			or die(
			"(EE)\t Can't create folder $RESULT_DIR/log: $!. Abort."
			);
	}

    if ( "$WORKING_DIR" eq "" ) {
        $TEMP_DIR = tempdir( "wave.XXXXX", TMPDIR => 1);
        print
"(WW)\t (SUFFIX $SUFFIX) \$WORKING_DIR is not set. using temporary folder $TEMP_DIR.\n";
		print
"(LL)\t (SUFFIX $SUFFIX) Have you checked \$flagDeleteTempDir?\n";
    }
    elsif ( !-d "$WORKING_DIR" ) {
        die(
"(EE)\t (SUFFIX $SUFFIX) Can't find $WORKING_DIR, although it is set. Abort."
        );
    }
    else {
        $TEMP_DIR = $WORKING_DIR;
    }

    if ( !"$MAGNET_FILE" eq "" ) {
        if ( !-f "$MAGNET_FILE" ) {
            die(
"(EE)\t (SUFFIX $SUFFIX) Can't find  $MAGNET_FILE, although it is set. Abort."
            );
        }
        else {
			if ( -f "$TEMP_DIR/bmap.dat" ) {
				unlink "$TEMP_DIR/bmap.dat";
			}
            symlink "$MAGNET_FILE", "$TEMP_DIR/bmap.dat"
              or die
"(EE)\t (SUFFIX $SUFFIX) Can't link $MAGNET_FILE to $TEMP_DIR/bmap.dat. Abort.";

			setMagnetMode("file");
			
        }
    }

	# Teilchen werden gefordert
	if (getValue("IBUNCH") != 0) {
		if($flagOwnParticleFile == 0) {
		
			if($particleData == "") {
				die("(EE)\t (SUFFIX $SUFFIX) Have you set particle data properly? Please use make_particles. Abort.");
			}
		
			open(my $particleFileHandle, ">", "$TEMP_DIR/wave_phasespace.dat") or die "(EE)\t (SUFFIX $SUFFIX) Can't create $TEMP_DIR/wave_phasespace.dat: $!. Abort";
			print $particleFileHandle, $particleData;
			close($particleData);
			print $particleData;
		}
		else {
			# TODO
		}
    }
    
    writeWaveIn();
    
    
}

# ------------------------------------------------------------#
# Funktion getHeader(title)
# Gibt den Header zurück, welcher in jeder geschriebenen Datei stehen sollte.
# Darin sind Informationen über den WAVE-Run enthalten, das Datum, der Suffix und ein paar Infos
# über die wave.in. Weiterhin eine vom Benutzer festgelegte Zeile. Die Zeilen sind als Kommentare mit "#" versehen
# Parameter:
# title: Ein zustätzlicher title, welcher eingebaut wird
sub getHeader {
    my ($title) = @_;
    return
        "# File $title\n# Created by WAVE and WAVE.pm on "
      . localtime()
      . "\n# Executed in $TEMP_DIR\n# Files saved in $RESULT_DIR\n#\n# Magnetfile (if set): $MAGNET_FILE\n# Suffix $SUFFIX\n# $USER_TEXT\n\n";
}

# ------------------------------------------------------------#
# Function calc()
# Ausführen
# WAVE starten und Daten sicher

sub calc {

    # Ordner ueberpruefen
    prepareFolders();

    # WAVE ausführen
    if ( !$DEBUG ) {

        # In TEMP_DIR arbeiten
        chdir($TEMP_DIR);

        # WAVE ausfuehren und Ausgaben sichern
        my ( $stdout, $stderr, $stdin );
        use Symbol 'gensym';
        $stderr = gensym;

        $ENV{ROOTSYS} = "/usr/share/root";
        my $pid = open3( $stdin, $stdout, $stderr, "$WAVE_EXE" )
          or die("(EE)\t (SUFFIX $SUFFIX) Error when executing wave.exe: $!. Abort.");

        chdir($RESULT_DIR);
        open( my $errorLogHandle, ">", "$RESULT_DIR/log/waveError_$pid.log" )
          or die(
"(EE)\t (SUFFIX $SUFFIX) Cant create error log $RESULT_DIR/log/waveError_$pid.log: $!. Abort."
          );
        open( my $logHandle, ">", "$RESULT_DIR/log/waveLog_$pid.log" )
          or die(
"(EE)\t (SUFFIX $SUFFIX) Can't create log $RESULT_DIR/log/waveLog_$pid.log: $!. Abort."
          );


		my $date = localtime();
		print "(LL)\t (SUFFIX $SUFFIX) WAVE (PID $pid) started: $date \n";

		waitpid( $pid, 0 );
        my $waveExitStatus = $? >> 8;

        my @stdourText = <$stdout>;

        print $logHandle @stdourText;
		
		if($waveExitStatus > 0) {
			
			if($stderr) {
				my @stderrText = <$stderr>;
				print $errorLogHandle @stderrText;
			}
			die("(EE)\t (SUFFIX $SUFFIX) WAVE (PID $pid) was not stopped properly. Errorcode $waveExitStatus. More information in the lod-File $RESULT_DIR/waveError_$pid.log or $RESULT_DIR/waveLog_$pid.log. Abort.")
		}
		else {
			close $errorLogHandle;
			unlink "$RESULT_DIR/log/waveError_$pid.log";
			$date = localtime();
			print "(LL)\t (SUFFIX $SUFFIX) WAVE (PID $pid) finished without error: $date \n";

			if($flagWriteLog != 1) {
				close $logHandle;
				unlink "$RESULT_DIR/log/waveLog_$pid.log";
			}
		}
	
	}
	
	rewriteFiles();
	
	# Temporären Ordner entfernen
	if ($flagDeleteTempDir == 1) {
		remove_tree("$TEMP_DIR");
	}
}

# ------------------------------------------------------------#
# Function rewriteFiles()
# Gesicherte Dateien in benutzerfreundliches Format speichern

sub rewriteFiles {

    # Daten sichern
    # Trajektorien wenn IWFILT0 != 0, sichere FILETR
    if ( getValue("IWFILT0") != 0) {
        my $filename = getValue("FILETR");
        $filename =~ /[\s]*'(.*)'.*/;
        $filename = $1;

		# TODO
		my @lines = `tail -n4 \"$TEMP_DIR/$filename\"`;

		my (undef, $z, $x, $y, undef) = split /[\s]+/, $lines[0];

		our @resultEndposition = ($x, $y, $z);

		if($flagWriteTrajectory == 1) {

			open( my $outputHandle, ">", "$RESULT_DIR/${SUFFIX}trajectory.dat" )
				or die(
		"(EE)\t (SUFFIX $SUFFIX) Can't open $RESULT_DIR/${SUFFIX}trajectory.dat: $!. Abort."
				);

			print $outputHandle getHeader(
				"trajectory.dat - trajectory and magnetic field");
			print $outputHandle
	"#\n# Columns\n# x-position (m)\n# y-position (m)\n# z-position(m)\n# B-field in x-direction at the position of the particle (T)\n# B-field in y-direction (T)\n# B-field in z-direction (T)\n\n";

			# TODO: Besser machen?
			print $outputHandle `cat \"$TEMP_DIR/$filename\" | awk '{ if (NR % 4 == 3 && NR > 1) { ORS = \" \"; print \$2, \$3, \$1; } else if (NR % 4 == 1 && NR > 1) { ORS = \"\\n\"; print \$2, \$3, \$1; } }'`;

			close $outputHandle;

		}
		
    }

    # Spektren wenn ISPEC != 0, sichere FILESP0
    # TODO: Auf $PINHOLE achten! Ändern bei WIGGLER und UNDULATOR
    if ( getValue("ISPEC") != 0) {
        my $filename = getValue("FILESP0");
        $filename =~ /[\s]*'(.*)'.*/;
        $filename = $1;

        open( my $resultHandle, "<", "$TEMP_DIR/$filename" )
          or die(
"(EE)\t (SUFFIX $SUFFIX) Can't open $TEMP_DIR/$filename: $!. Abort."
          );
        my @result = <$resultHandle>;

        # Anfang wegschneiden
        splice @result, 0, 8 + ceil(getValue("MPINZ")/3.0) +  ceil(getValue("MPINY")/3.0) + 2;

		# Maximale Energie berechnen
		my @sorted = map {[$_->[1], $_->[2]]} 
				sort {$b->[2] <=> $a->[2]}  
					map { [split(/\s+/, $_)] } @result[1..@result-1];
		
		my $maximum = $sorted[0];
		our $resultMaximumEnergy = $maximum->[0];
		our $resultMaximumIntensity = $maximum->[1];

		my $outputHandle;

        # TODO: bei Wigglern
        
        # Pinhole als Winkelverteilung sichern
        if ( getValue("IPIN") != 0 && $flagWriteSpectrum == 1) {
            open( $outputHandle,
                ">", "$RESULT_DIR/${SUFFIX}angular_distribution.dat" )
              or die(
"(EE)\t (SUFFIX $SUFFIX) Can't open $RESULT_DIR/${SUFFIX}angular_distribution.dat: $!. Abort."
              );
            print $outputHandle getHeader(
"angular_distribution.dat - spectrum/intensity as angular distributaion"
            );
            print $outputHandle
"#\n#For the angular ditribuation, all radiation energies and all sources are summed up.\n# Columns\n# x-position (m)\n# y-position (m)\n# Intensity (Photons/s/mm^2/BW)\n\n";

            my @lines = @result;

            while ( $#lines > 0 ) {
                my ( undef, undef, $x, $y ) = split /\s+/,
                  ( splice @lines, 0, 1 )[0];
                my $sum = 0;

                for ( my $i = 0 ; $i < getValue("NINTFREQ") ; $i++ ) {

                    my ( undef, $energy, $flux, undef ) = split /\s+/,
                      $lines[0];

  # TODO bei Wigglern: für mehr als eine Quelle: nur letzes Ergebnis betrachten
  #splice @lines, 0, 46;
  #my (undef, $flux) = split /\s+/, splice @lines, 0, 1;

                    $sum += $flux;
                }

                $sum = $sum / getValue("NINTFREQ");

                printf $outputHandle ( "%f %f %g\n", $x, $y, $sum );
            }

            close $outputHandle;
        }

		# Falls keine Pinhole angegeben ist, einfach die Datei rausschreiben
        elsif($flagWriteSpectrum == 1) {
            open( $outputHandle, ">", "$RESULT_DIR/${SUFFIX}spectrum.dat" )
              or die(
"(EE)\t Can't open $RESULT_DIR/${SUFFIX}spectrum.dat: $!. Abort."
              );
			
            print $outputHandle getHeader(
                "spectrum.dat - spectrum/intensity");
            print $outputHandle
"#\n# Columns\n# Energy of radiation (eV) \n# Intensity (Photons/s/mm^2/BW)\n\n";

            print $outputHandle @result[1..@result-1];
            close $outputHandle;
        }
    }



}


# ## COPY FROM verteilung_twiss.pm
#------------------------------------------------------------
# Das Programm erzeugt eine monoenergetische Verteilung, die nach Vorgaben
# der Twissparameter erstellt werden. 
# Die Formeln sind aus dem Anhang von CERN/PS 2001-0013 (AE) von ASM

# Bearbeitung Nils: 	Verschiedene Werte für betax und betay (sowie alphax und alphay) können angegeben werden.
#			Ausgabe in Format (gamma dx dy dz dpx/p dpy/p dpz/p)

# Benötigt übergebene Variablen in
# XSTART, YSTART, ENERGY, TEILCHENZAHL, [BETAX, ALPHAX, BETAY, ALPHAY, EPS]
#-------------------------------------------------------------

sub make_particles
{
	my ($XSTART, $YSTART, $ENERGY, $TEILCHENZAHL, $TWISS) = @_;
	
	$particleData = "";

	# Anfangswerte und Verteilungen
	#---------------------------------------
	my $alphax = $TWISS->[1];	# AKTIVIERT
	my $alphay = $TWISS->[3];	# AKTIVIERT
	my $betax = $TWISS->[0];	# AKTIVIERT
	my $betay = $TWISS->[2];	# AKTIVIERT

	my ($epsx, $epsy) = ($TWISS->[4], $TWISS->[4]);
	
	if ($epsx == 0)
	{
		$epsx = 1e-8;		# AKTIVIERT
		$epsy = 1e-8;		# AKTIVIERT
	}

	# Parameter zur Berechnung
	# --------------------------------------
	my $gammax = (1+$alphax**2)/$betax;
	my $gammay = (1+$alphay**2)/$betay;
	my $phix = 0.5 * atan(2*$alphax/($gammax-$betax)); # Winkel, um den die Verteilung gedreht ist
	my $phiy = 0.5 * atan(2*$alphay/($gammay-$betay)); # Winkel, um den die Verteilung gedreht ist
	my $phi2x = $phix / pi*180;
	my $phi2y = $phiy / pi*180;

	# Berechnung der beiden Halbachsen der Ellipse
	my $sigmax = sqrt($epsx/2*(($betax+$gammax)-sqrt(($betax+$gammax)**2-4))); 	# Ausdehnung der Quelle
	my $sigmay = sqrt($epsy/2*(($betay+$gammay)-sqrt(($betay+$gammay)**2-4))); 	# Ausdehnung der Quelle
	my $divx = sqrt($epsx/2*(($betax+$gammax)+sqrt(($betax+$gammax)**2-4))); 		# Divergenz der Quelle
	my $divy = sqrt($epsy/2*(($betay+$gammay)+sqrt(($betay+$gammay)**2-4))); 		# Divergenz der Quelle

	#--------------------------------------

	# Berechnen der Anfangsverteilung
	#---------------------------------------
	for (my $j = 0; $j < $TEILCHENZAHL; $j++) 
	{
		# transversale Impulse und Positionen
		my $dx = gaussian_rand()*$divx; # transversaler Impuls aus Divergenz und longitudinalem Impuls
		my $dy = gaussian_rand()*$divy; 

		my $x = gaussian_rand()*$sigmax; # x-Position aus Gleichverteilung um 0
		my $y = gaussian_rand()*$sigmay; # y-Position aus Gleichverteilung um 0

		my $xe = (cos($phix)*$x-sin($phix)*$dx);
		my $dxe = sin($phix)*$x+cos($phix)*$dx;

		my $ye = cos($phiy)*$y-sin($phiy)*$dy;
		my $dye = sin($phiy)*$y+cos($phiy)*$dy;

		# Format gamma x y z px py pz (wave -> gamma xbunch x y z py pz)
		my $energy_gamma = 1000 * $ENERGY / 0.5109989;
		my $xereal = $xe + $YSTART;
		my $zstart = $XSTART;
		$particleData = $particleData . "$energy_gamma 0 $zstart $xereal $ye $dxe $dye \n";

	}

}


#Gaussverteilung
#----------------------------------
sub gaussian_rand 
{
	my ($u1, $u2); # uniformly distributed random numbers
	my $w; # variance, then a weight
	my ($g1, $g2); # gaussian-distributed numbers

	do 
	{ 
		$u1 = 2 * rand() - 1; 
	     	$u2 = 2 * rand() - 1;
	     	$w = $u1*$u1 + $u2*$u2; 
	}

	while ( $w >= 1 ); 
	     
	$w = sqrt( (-2 * log($w)) / $w );
	$g2 = $u1 * $w;
	$g1 = $u2 * $w; # return both if wanted, else just one return wantarray ?($g1, $g2) : $g1; 

	return $g1;
}
#-----------------------------------


return 1;
