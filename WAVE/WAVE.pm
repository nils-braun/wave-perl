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
use WAVE::waveIn;

# use PDL::IO::Misc;

my $DEBUG = 0;


use File::Temp qw(tempdir);
use IPC::Open3;

# Konstanten
# ------------------------------------------------------------ #
# Ordnerstrukturen und Pfade
# Pfad zur WAVE Executable, muss vorhanden sein
my $WAVE_EXE = "/home/braun/Programme/wave/wave/bin/wave.exe";
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

# ------------------------------------------------------------ #
# Funktion setValue(key, value)
# Verändert einen Wert im wave.in-Hash. Bricht ab, falls es den Key nicht gibt.
# Parameter: 
#	key: Welche Variable gesetzt wird.
#	value: Auf welchen Wert die Variable gesetzt wird.

sub setValue {

	my ($key, $value) = @_;

	if (exists $waveInArray{"$key"}) {
		$waveInArray{"$key"} = "$value";
	}
	else {
		die("(EE)\t Konnte $key nicht in wave.in ändern, da diese Variable nicht vorhanden ist! Abbruch.")
	}
}

# ------------------------------------------------------------ #
# Funktion getValue(key)
# Gibt einen Wert im wave.in-Hash zurück. Bricht ab, falls es den Key nicht gibt.
# Parameter: 
#	key: Welche Variable abgerufen wird.

sub getValue {

	my ($key) = @_;

	if (exists $waveInArray{"$key"}) {
		return $waveInArray{"$key"};
	}
	else {
		die("(EE)\t Konnte $key nicht in wave.in abrufen, da diese Variable nicht vorhanden ist! Abbruch.")
	}
}

# ------------------------------------------------------------ #
# Funktion writeWaveIn(workingDir)
# Werte in eine wave.in-Datei schreiben, welche sich im TEMP_DIR befindet. Achtung: vorherige Dateien werden überschrieben.

sub writeWaveIn {

	open (my $waveconfigFileHandle, ">", "$TEMP_DIR/wave.in") or die "(EE)\t Kann Datei $TEMP_DIR/wave.in nicht öffnen: $!. Abbruch.";

	foreach (@waveIn) {
		if ($_ =~ /^[\s]*([\w|\(\)]+)=[\s]*([^!]*)(.*)$/) {
			printf $waveconfigFileHandle "\t$1 = %s$3\n", $waveInArray{"$1"};
		}
		else  {
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
	if ( ! -e "$WAVE_EXE" ) {
		die("(EE)\t Konnte wave.exe unter $WAVE_EXE nicht finden oder sie ist nicht ausführbar: $!. Abbruch.");
	}

	if ( ! -d "$RESULT_DIR" ) {
		print("(WW)\t Konnte $RESULT_DIR nicht finden. Ordner wird erstellt.\n");
		mkdir "$RESULT_DIR" or die ("(EE)\t Konnte den Ordner $RESULT_DIR nicht erstellen: $!. Abbruch.");
	}

	if ( "$WORKING_DIR" eq "" ) {
		$TEMP_DIR = tempdir("wave.XXXXX", TMPDIR => 1, CLEANUP => 1);
		print "(WW)\t \$WORKING_DIR nicht gesetzt. Benutze temporären Order $TEMP_DIR.\n";
	}
	elsif ( ! -d "$WORKING_DIR" ) {
		die("(WW)\t Konnte $WORKING_DIR nicht finden, obwohl es angegeben ist: $!. Abbruch.");
	}
	else {
		$TEMP_DIR = $WORKING_DIR;
	}

	writeWaveIn();

	if ( ! "$MAGNET_FILE" eq "" ) {
		if ( ! -f "$MAGNET_FILE" ) {
			die("(WW)\t Konnte $MAGNET_FILE nicht finden, obwohl es angegeben ist: $!. Abbruch.");
		}
		else {
			symlink "$MAGNET_FILE", "$TEMP_DIR/bmap.dat" or die "(EE)\t Konnte $MAGNET_FILE auf $TEMP_DIR/bmap.dat nicht linken: $!. Abbruch.";
		}
	}
}


# ------------------------------------------------------------#
# Funktion getHeader(title)
# Gibt den Header zurück, welcher in jeder geschriebenen Datei stehen sollte.
# Darin sind Informationen über den WAVE-Run enthalten, das Datum, der Suffix und ein paar Infos
# über die wave.in. Weiterhin eine vom Benutzer festgelegte Zeile. Die Zeilen sind als Kommentare mit "#" versehen
# Parameter:
#	title: Ein zustätzlicher title, welcher eingebaut wird
sub getHeader {
	my ($title) = @_;
	return "# Datei $title\n# Erstellt durch WAVE am ".localtime()."\n# Ausgeführt in $TEMP_DIR\n# Daten gespeichert in $RESULT_DIR\n#\n# Magnet-Datei (falls vorhanden): $MAGNET_FILE\n# Suffix $SUFFIX\n# $USER_TEXT\n\n";
}

# ------------------------------------------------------------#
# Function calc()
# Ausführen
# WAVE starten und Daten sicher

sub calc {
	
	# Ordner ueberpruefen
	prepareFolders();

	# WAVE ausführen
	if(!$DEBUG) {
	
		# In TEMP_DIR arbeiten
		chdir($TEMP_DIR);

		# WAVE ausfuehren und Ausgaben sichern
		my ($stdout, $stderr, $stdin);
		use Symbol 'gensym'; $stderr = gensym;


		$ENV{ROOTSYS} = "/usr/share/root";
		
		my $pid = open3($stdin, $stdout, $stderr, "$WAVE_EXE") or die("(EE)\t Fehler bei Ausführen von wave: $!. Abbruch.");
		
		chdir($RESULT_DIR);
		open(my $errorLogHandle, ">", "$RESULT_DIR/waveError_$pid.log") or die ("(EE)\t Konnte den Errorlog $RESULT_DIR/waveError_$pid.log nicht anlegen; $!. Abbruch.");
		open(my $logHandle, ">", "$RESULT_DIR/waveLog_$pid.log") or die ("(EE)\t Konnte den Log $RESULT_DIR/waveLog_$pid.log nicht anlegen; $!. Abbruch.");

		my $date = localtime();
		print "(LL)\t WAVE (PID $pid) gestartet: $date \n";

		# TODO: Nicht erst am Ende die Ausgabe schreiben, sondern immer!
		
		waitpid( $pid, 0 );
		my $waveExitStatus = $? >> 8;
		
		my @stdourText = <$stdout>;
		
		# TODO: nicht immer log schreiben. Da wird man ja verrückt.
		#print $logHandle @stdourText;
		unlink "$RESULT_DIR/waveLog_$pid.log";

		
		if($waveExitStatus > 0) {
			
			if($stderr) {
				my @stderrText = <$stderr>;
				print $errorLogHandle @stderrText;
			}
			die("(EE)\t WAVE (PID $pid) wurde mit einem Fehler beendet. Fehlercode $waveExitStatus. Weitere Informationen in der log-Datei $RESULT_DIR/waveError_$pid.log. Abbruch.")
		}
		else {
			close $errorLogHandle;
			unlink "$RESULT_DIR/waveError_$pid.log";
			print "(LL)\t WAVE (PID $pid) beendet ohne Fehler: $date \n";
		}
	
	}
	
	rewriteFiles();
	system "cp \"$TEMP_DIR/wave.in\" \"$RESULT_DIR/wave.in\"";
	system "cp \"$TEMP_DIR/wave.sp0\" \"$RESULT_DIR/wave.sp0\"";
}

# ------------------------------------------------------------#
# Function rewriteFiles()
# Gesicherte Dateien in benutzerfreundliches Format speichern

sub rewriteFiles() {
	# Daten sichern
	# Trajektorien wenn IWFILT0 != 0, sichere FILETR
	if(getValue("IWFILT0") != 0) {
		my $filename = getValue("FILETR");
		$filename =~ /[\s]*'(.*)'.*/;
		$filename = $1;
		# TODO: Ändern, wenn PDL funktioniert
# 		open(my $resultHandle, "<", "$TEMP_DIR/$filename") or die ("(EE)\t Konnte die Datei $TEMP_DIR/$filename nicht öffnen: $!. Abbruch.");
# 		$x = rcols( <$resultHandle>, { EXCLUDE => '/^*/' }, [] );

		open(my $outputHandle, ">", "$RESULT_DIR/${SUFFIX}trajectory.dat") or die ("(EE)\t Konnte die Datei $RESULT_DIR/${SUFFIX}trajectory.dat nicht öffnen: $!. Abbruch.");
		print $outputHandle getHeader("trajectory.dat - Trajektorie und Magnetfeld");
		print $outputHandle "#\n# Spalten\n# x-Position (m)\n# y-Position (m)\n# z-Position(m)\n# B-Feld in x-Richtung am Teilchenpunkt (T)\n# B-Feld in y-Richtung (T)\n# B-Feld in z-Richtung (T)\n\n";
		close $outputHandle;
		
		# TODO: Dann entfernen:
		system "cat \"$TEMP_DIR/$filename\" | awk '{ if (NR % 4 == 3 && NR > 1) { ORS = \" \"; print \$2, \$3, \$1; } else if (NR % 4 == 1 && NR > 1) { ORS = \"\\n\"; print \$2, \$3, \$1; } }' >> \"$RESULT_DIR/${SUFFIX}trajectory.dat\"";
	}
	
	# Spektren wenn ISPEC != 0, sichere FILESP0
	# TODO: Auf $PINHOLE achten! Ändern bei WIGGLER und UNDULATOR
	if(getValue("ISPEC") != 0) {
		my $filename = getValue("FILESP0");
		$filename =~ /[\s]*'(.*)'.*/;
		$filename = $1;
		
		open(my $outputHandle, ">", "$RESULT_DIR/${SUFFIX}spectrum.dat") or die ("(EE)\t Konnte die Datei $RESULT_DIR/${SUFFIX}spectrum.dat nicht öffnen: $!. Abbruch.");
		print $outputHandle getHeader("spectrum.dat - Spektrum/Intensitäten");
		print $outputHandle "#\n# Spalten\n# Strahlungsenergie (eV) \n# Intensität (Photonen/s/mm^2/BW)\n\n";
		
		# TODO: Ändern, wenn PDL funktioniert
		open(my $resultHandle, "<", "$TEMP_DIR/$filename") or die ("(EE)\t Konnte die Datei $TEMP_DIR/$filename nicht öffnen: $!. Abbruch.");
		my @result = <$resultHandle>;
		
		# Anfang wegschneiden
		my $i = 0;
		for($i = 0; $i < $#result; $i++) {
			if($result[$i] =~ /^[\s]*([^\s]+)[\s]*([^\s]+)[\s]*([^\s]+)[\s]*$/) {
				last if ($1 == getValue("PINCEN(1)") and $2 == getValue("PINCEN(2)") and $3 == getValue("PINCEN(3)"));
			}
		}
		splice @result, 0, $i;
		
		print $outputHandle @result;
		close $outputHandle;
		
		# TODO: Pinhole als Winkelverteilung sichern
		if(getValue("IPIN") != 0) {
			open(my $outputHandle, ">", "$RESULT_DIR/${SUFFIX}angular_distribution.dat") or die ("(EE)\t Konnte die Datei $RESULT_DIR/${SUFFIX}angular_distribution.dat nicht öffnen: $!. Abbruch.");
			print $outputHandle getHeader("angular_distribution.dat - Spektrum/Intensitäten als Winkelverteilung");
			print $outputHandle "#\n#Für die Winkelverteilung wird über alle Strahlungsenergien und möglicherweise Quellen summiert\n# Spalten\n# x-Position (m)\n# y-Position (m)\n# Intensität (Photonen/s/mm^2/BW)\n\n";
			

			my @lines = @result;
			
			while ($#lines > 0) {
				my (undef, undef, $x, $y) = split /\s+/, (splice @lines, 0, 1)[0];
				my $sum = 0;

				for (my $i = 0; $i < getValue("NINTFREQ"); $i++) {

					my (undef, $energy, undef, undef) = split /\s+/, $lines[0];

					# für mehr als eine Quelle: nur letzes Ergebnis betrachten
					splice @lines, 0, 46;
					my (undef, $flux) = split /\s+/, splice @lines, 0, 1;
					# TODO: für nur eine Quelle: das Ergebnis direkt betrachten

					$sum += $flux;
				}
				
				$sum = $sum / getValue("NINTFREQ");

				printf $outputHandle ("%f %f %g\n", $x, $y, $sum);
			}
			
			close $outputHandle;
		}
	}
}


# ------------------------------------------------------------ #
# Die genannten Funktionen exportieren:
use Exporter;
our @ISA = qw(Exporter);

# Exportieren der Funktionen und Variablen
our @EXPORT = qw( setValue getValue RESULT_DIR WORKING_DIR prepareFolders calc SUFFIX USER_TEXT );

return 1;