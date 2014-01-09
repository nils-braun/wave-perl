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
$WAVE::MAGNET_FILE = "$ROOT/Opera-Daten/WAVE-Format/bmap.dat"

my $OFFSET_FILE = "$ROOT/Input/optimierter Offset 8.26.table";

# ------------------------------------------------------------ #
# Hauptprogramm 
# 

open (my $offsetFileHandle, "<", "$OFFSET_FILE") or die "Kann Datei $OFFSET_FILE nicht <C3><B6>ffnen: $!. Abbruch.";
open (my $resultFileHandle, ">", "$WAVE::RESULT_DIR/result.dat") or die "Konnte $COPY_DIR/result.dat nicht oeffnen. Abbruch.";

# Für jede Energie ausführen
while(<$offsetFileHandle>)
{
		# Energie und Offset auslesen (Achtung: Offset hat noch einen Zeilenumbruch am Ende)
		# Kommentare überspringen
		next if ($_ =~ /#.*/ || $_ =~ /^\s*$/);

		(my $energy, my $yStart) = (split /\s+/, $_)[0,1];
		
		my $childPID = fork();

		if (! $childPID )
		{		
			$SUFFIX = $energy;
			
			setValue("XSTART", -0.35);
			setValue("ISPEC", 1);
			setValue("IBUNCH", 0);
			setValue("DMYENERGY", $energy);
			setValue("YSTART", $yStart/1000.0);
			setValue("PINCEN(1)", 100);
			
			WAVE::calc();
		}
}