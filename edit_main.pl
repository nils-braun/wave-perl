#!/usr/bin/perl
use strict;
use warnings;

use lib "/home/braun/Programme/wave/perl";

use WAVE::WAVE;
use File::Path qw(make_path);

# Akzeptanz.pl
# Datum: 	Dezember 2013
# Autor: 	Nils Braun
# Aufgabe:	Verändert für drei Energien die Phasenraum-Parameter (x,y,px,py) und berechnet mit WAVE das Spektrum. 
#			Liegt die Strahlungsenergie bei höchster Intensität innerhalb eines angegebenen Intervalls, so wird 
#			der Phasenraumpunkt gespeichert.


# ------------------------------------------------------------ #
# Ordnerstruktur
my $ROOT = "/home/braun/HiWi/model-40";
$WAVE::RESULT_DIR = "$ROOT/test";
$WAVE::MAGNET_FILE = "$ROOT/Opera-Daten/WAVE-Format/bmap.dat";

my $OFFSET_FILE = "$ROOT/Input/optimierter Offset 8.26.table";

# ------------------------------------------------------------ #
# Hauptprogramm 
# 

open (my $offsetFileHandle, "<", "$OFFSET_FILE") or die "Kann Datei $OFFSET_FILE nicht <C3><B6>ffnen: $!. Abbruch.";
open (my $resultFileHandle, ">", "$WAVE::RESULT_DIR/result.dat") or die "Konnte $WAVE::RESULT_DIR/result.dat nicht oeffnen. Abbruch.";

# Für jede Energie ausführen
while(<$offsetFileHandle>)
{
		# Energie und Offset auslesen (Achtung: Offset hat noch einen Zeilenumbruch am Ende)
		# Kommentare überspringen
		next if ($_ =~ /#.*/ || $_ =~ /^\s*$/);
		
		(my $energy, my $yStart) = (split /\s+/, $_)[0,1];
		
		next if ($energy != 0.12);
		
		my $childPID = fork();

		if (! $childPID )
		{		
			$WAVE::SUFFIX = $energy;
			
			WAVE::setValue("XSTART", -0.35);
			WAVE::setValue("XSTOP", 9999);
			WAVE::setValue("ISPEC", 1);
			WAVE::setValue("IBUNCH", 0);
			WAVE::setValue("DMYENERGY", $energy);
			WAVE::setValue("YSTART", $yStart/1000.0);
			WAVE::setValue("PINCEN(1)", 100);
			WAVE::setValue("IWIGGLER", 0);
			WAVE::setValue("IEXPERT", 0);
			WAVE::setValue("DMYCUR", 0.2);
			WAVE::setValue("KHALBA", 0);
			WAVE::setValue("IRFILB0", -6);
			
			WAVE::setValue("FREQLOW", 7);
			WAVE::setValue("FREQHIG", 9);
			WAVE::setValue("NINTFREQ", 1000);
			
			WAVE::calc();
		}
}