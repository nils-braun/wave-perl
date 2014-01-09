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
my $root = "/home/braun/Dropbox/Projekte/Perl";
$WAVE::RESULT_DIR = "$root";

# ------------------------------------------------------------ #
# Hauptprogramm 
# 

WAVE::calc();