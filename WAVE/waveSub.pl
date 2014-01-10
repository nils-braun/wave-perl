# TODO: Koordinaten aendern!!!!
# Verschiedene Funktionen zum Setzen von WAVE-Input Variablen

use strict;
use warnings;

sub setStartposition {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "XSTART", $x );
    WAVE::setValue( "YSTART", $y );
    WAVE::setValue( "ZSTART", $z );
}

sub setEndposition {
    my ($x) = @_;
    WAVE::setValue( "XSTOP", $x );
}

sub setNoEndposition {
    WAVE::setValue( "XSTOP", 9999 );
}

sub setObservationPoint {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "PINCEN(1)", $x );
    WAVE::setValue( "PINCEN(2)", $y );
    WAVE::setValue( "PINCEN(3)", $z );
    WAVE::setValue( "OBS1X", $x );
    WAVE::setValue( "OBS1Y", $y );
    WAVE::setValue( "OBS1Z", $z );
}

sub setFreq {
	my ($freqlow, $freqhigh, $numfreq) = @_;
    WAVE::setValue( "FREQLOW",  $freqlow );
    WAVE::setValue( "FREQHIG",  $freqhigh );
    WAVE::setValue( "NINTFREQ", $numfreq );
}

sub setEnergy {
	my ($energy) = @_;
    WAVE::setValue( "DMYENERGY", $energy );
}

sub setCurrent {
	my ($current) = @_;
    WAVE::setValue( "DMYCUR", $current );
}

sub setMode {
    my ($mode) = @_;
    if ( lc $mode eq "expert" ) {
        WAVE::setValue( "IEXPERT",    1 );
        WAVE::setValue( "IUNDULATOR", 0 );
        WAVE::setValue( "IWIGGLER",   0 );
    }
    elsif ( lc $mode eq "undulator" ) {
        WAVE::setValue( "IEXPERT",    0 );
        WAVE::setValue( "IUNDULATOR", 1 );
        WAVE::setValue( "IWIGGLER",   0 );
    }
    elsif ( lc $mode eq "wiggler" ) {
        WAVE::setValue( "IEXPERT",    0 );
        WAVE::setValue( "IUNDULATOR", 0 );
        WAVE::setValue( "IWIGGLER",   1 );
    }

	else {
		die("(EE)\t Konnte Mode nicht in $mode ändern, da dieser Modus nicht vorhanden ist! Abbruch.");
	}
}

return 1;