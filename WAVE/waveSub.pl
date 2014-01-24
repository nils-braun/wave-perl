# Verschiedene Funktionen zum Setzen von WAVE-Input Variablen

use strict;
use warnings;

sub setStartposition {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "XSTART", $z );
    WAVE::setValue( "YSTART", $x );
    WAVE::setValue( "ZSTART", $y );
}

sub setEndposition {
    my ($z) = @_;
    WAVE::setValue( "XSTOP", $z );
}

sub unsetEndposition {
    WAVE::setValue( "XSTOP", 9999 );
}

sub setObservationPoint {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "PINCEN(1)", $z );
    WAVE::setValue( "PINCEN(2)", $x );
    WAVE::setValue( "PINCEN(3)", $y );
    WAVE::setValue( "OBS1X", $z );
    WAVE::setValue( "OBS1Y", $x );
    WAVE::setValue( "OBS1Z", $y );
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

sub setCalcSpec {
	WAVE::setValue("ISPEC", 1);
}

sub unsetCalcSpec {
	WAVE::setValue("ISPEC", 0);
}

# TODO: es gibt noch viel mehr Modi!!!
sub setMagnetMode {
    my ($mode) = @_;

	WAVE::setValue("IBSUPER", 0);
	WAVE::setValue("KBEXTERN", 0);
	WAVE::setValue("KBFELD", 0);
	WAVE::setValue("IBGAUSS", 0);
	WAVE::setValue("KMAGSEQ", 0);
	WAVE::setValue("KMAGCOR", 1);
	WAVE::setValue("IMGSQF", 0);
	WAVE::setValue("KHALBA", 0);
	WAVE::setValue("KHALBASY", 0);
	WAVE::setValue("KUCROSS", 0);
	WAVE::setValue("KELLIP", 0);
	WAVE::setValue("KELLANA", 0);
	WAVE::setValue("KBREC", 0);
	WAVE::setValue("KBPOLYMAG", 0);
	WAVE::setValue("IRBTAB", 0);
	WAVE::setValue("IRBTABZY", 0);
	WAVE::setValue("IRFILB0", 0);
	WAVE::setValue("IRFILF", 0);
	WAVE::setValue("KBAMWLS", 0);
	WAVE::setValue("KBPOLYH", 0);
	WAVE::setValue("KBPOLY3D", 0);
	WAVE::setValue("KBPOLY2DH", 0);
	WAVE::setValue("KBPHARM", 0);
	WAVE::setValue("IRFILP", 0);
	WAVE::setValue("IBHELM", 0);
	WAVE::setValue("KBGENESIS", 0);

    if ( lc $mode eq "file" ) {
		WAVE::setValue("IRFILB0", -6);
	}
	elsif ( lc $mode eq "fileLinear" ) {
		WAVE::setValue("IRFILB0", 6);
	}
	elsif ( lc $mode eq "halbach" ) {
		WAVE::setValue("KHALBA", -1);
	}


	else {
		die("(EE)\t Konnte Magnet-Mode nicht in $mode ändern, da dieser Modus nicht vorhanden ist! Abbruch.");
	}
}


return 1;