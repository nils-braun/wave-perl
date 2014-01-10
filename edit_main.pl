#!/usr/bin/perl
use strict;
use warnings;

use lib "/home/braun/Programme/wave/perl";

use WAVE::WAVE;
use File::Path qw(make_path);


require "WAVE/waveSub.pl";

# Akzeptanz.pl
# Datum:    Dezember 2013
# Autor:    Nils Braun
# Aufgabe:  Verändert für drei Energien die Phasenraum-Parameter (x,y,px,py) und berechnet mit WAVE das Spektrum. 
#           Liegt die Strahlungsenergie bei höchster Intensität innerhalb eines angegebenen Intervalls, so wird 
#           der Phasenraumpunkt gespeichert.


# ------------------------------------------------------------ #
# Ordnerstruktur
my $ROOT = "/home/braun/HiWi/model-40";
$WAVE::RESULT_DIR = "$ROOT/test";
$WAVE::MAGNET_FILE = "$ROOT/Opera-Daten/WAVE-Format/bmap.dat";

$WAVE::WORKING_DIR = "$ROOT/workingdir";

my $OFFSET_FILE = "$ROOT/Input/optimierter Offset 8.26.table";

# ------------------------------------------------------------ #
# Hauptprogramm 
# 

open (my $offsetFileHandle, "<", "$OFFSET_FILE") or die "Kann Datei $OFFSET_FILE nicht <C3><B6>ffnen: $!. Abbruch.";
open (my $resultFileHandle, ">", "$WAVE::RESULT_DIR/result.dat") or die "Konnte $WAVE::RESULT_DIR/result.dat nicht oeffnen. Abbruch.";


setNoEndposition();

WAVE::setValue("ISPEC", 1);
WAVE::setValue("IBUNCH", 0);

setObservationPoint(100, 0, 0);
setMode("expert");

setCurrent(0.2);
WAVE::setValue("KHALBA", 0);
WAVE::setValue("IRFILB0", -6);

setFreq(7, 9, 1000);

mkdir "$ROOT/workingdir/test";
$WAVE::WORKING_DIR = "$ROOT/workingdir/test";
system "rm $WAVE::WORKING_DIR/*";

# Für jede Energie ausführen
while(<$offsetFileHandle>)
{
		# Energie und Offset auslesen (Achtung: Offset hat noch einen Zeilenumbruch am Ende)
		# Kommentare überspringen
		next if ($_ =~ /#.*/ || $_ =~ /^\s*$/);
		
		(my $energy, my $yStart) = (split /\s+/, $_)[0,1];
		
		next if ($energy != 0.12);
		
		$WAVE::SUFFIX = $energy;
			
		setEnergy( $energy );
		setStartposition(-0.35, $yStart/1000.0, 0);
		
		WAVE::calc();
}