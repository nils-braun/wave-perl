#!/usr/bin/perl --
use strict;
use Math::Trig;
#============================================================

return 1;

#------------------------------------------------------------
# Das Programm erzeugt eine monoenergetische Verteilung, die nach Vorgaben
# der Twissparameter erstellt werden. 
# Die Formeln sind aus dem Anhang von CERN/PS 2001-0013 (AE) von ASM

# Bearbeitung Nils: 	Verschiedene Werte für betax und betay (sowie alphax und alphay) können angegeben werden.
#			Ausgabe in Format (gamma dx dy dz dpx/p dpy/p dpz/p)

# Benötigt übergebene Variablen in
# XSTART, YSTART, ENERGY, TEMP_DIR, TEILCHENZAHL, [BETAX, ALPHAX, BETAY, ALPHAY, EPS]
#-------------------------------------------------------------

sub make_particles
{

	my ($XSTART, $YSTART, $ENERGY, $TEMP_DIR, $TEILCHENZAHL, $TWISS) = @_;

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


	#Dateinamen und Öffnen der Datei
	#--------------------------------------
	my $datverteilung =  "$TEMP_DIR/wave_phasespace.dat"; #Datei für die erzeugte Verteilung
	open DATEI,  ">$datverteilung" or die "Can't open Datei $!";
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
		print DATEI ("$energy_gamma 0 $zstart $xereal $ye $dxe $dye \n");

	}

	close DATEI;
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
