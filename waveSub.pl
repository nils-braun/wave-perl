=pod

=head1 NAME

WAVE::waveSub - perl file to edit the wave.in file. Is included by WAVE.pm. Do not include by hand.

=head1 DESCRIPTION

Exports several functions to set or read the WAVE input parameters from/to the
waveIn-Array created by waveIn.pm. Is uses some functions created by WAVE.pm
See WAVE.pm for more informations.

=head1 AUTHOR

Nils Braun I<area51.nils@googlemail.com>

=head1 ACKNOWLEDGEMENTS

The programm WAVE is written by Michael Scheer. For more informations an licencing see there.

=head1 FUNCTIONS

=cut



use strict;
use warnings;

=head2 C<setStartposition(XSTART, YSTART, ZSTART)>

Set the starting position of the particle to the real world coordinates (XSTART, YSTART, ZSTART) in meters.

=cut
sub setStartposition {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "XSTART", $z );
    WAVE::setValue( "YSTART", $x );
    WAVE::setValue( "ZSTART", $y );
}

=head2 C<setVelocity(VXIN, VYIN, VZIN)>

Set the starting velocity of the particle to the real world values (VXIN, VYIN, VZIN) in rad. 

=cut
sub setStartvelocity {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "VXIN", $z );
    WAVE::setValue( "VYIN", $x );
    WAVE::setValue( "VZIN", $y );
}

=head2 C<setEndposition(ZSTOP)>

Stop the calculation of the particle reaches the z position ZSTOP in meters.

=cut
sub setEndposition {
    my ($z) = @_;
    WAVE::setValue( "XSTOP", $z );
}

=head2 C<unsetEndposition()>

Let WAVE calculate the endposition by itself (mostly the end of the magnet model).

=cut
sub unsetEndposition {
    WAVE::setValue( "XSTOP", 9999 );
}

=head2 C<setObservationPoint(X, Y, Z)>

Set the obervation point for all following calculations (undulator or wiggler) to (X, Y, Z) in real world coordinates in meters.

=cut
sub setObservationPoint {
    my ( $x, $y, $z ) = @_;
    WAVE::setValue( "PINCEN(1)", $z );
    WAVE::setValue( "PINCEN(2)", $x );
    WAVE::setValue( "PINCEN(3)", $y );
    WAVE::setValue( "OBS1X", $z );
    WAVE::setValue( "OBS1Y", $x );
    WAVE::setValue( "OBS1Z", $y );
}

=head2 C<setFreq(FREQLOW, freqhigh, NUMFREQ)>

Set the energy interval for calculating the sepctra to (FREQLOW, FREQHIG) in eV with NUMFREQ points in between.

=cut
sub setFreq {
	my ($freqlow, $freqhigh, $numfreq) = @_;
    WAVE::setValue( "FREQLOW",  $freqlow );
    WAVE::setValue( "FREQHIG",  $freqhigh );
    WAVE::setValue( "NINTFREQ", $numfreq );
}

=head2 C<setEnergy(ENERGY)>

Set the energy of the particle to ENERGY in GeV.

=cut
sub setEnergy {
	my ($energy) = @_;
    WAVE::setValue( "DMYENERGY", $energy );
}

=head2 C<setCurrent(CURRENT)>

Set the current to CURRENT in A.

=cut
sub setCurrent {
	my ($current) = @_;
    WAVE::setValue( "DMYCUR", $current );
}

=head2 C<setMode(MODE)>

Set the calculation mode of the spectra to MODE. Possibly choices are I<expert>, I<undulator> or I<wiggler>. For more explanations, see WAVE.

=cut
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
		die("(EE)\t Can't change mode to $mode, because this mode is not supported! Abort.");
	}
}

=head2 C<setCalcSpec()>

Do calculate spectra.

=cut
sub setCalcSpec {
	WAVE::setValue("ISPEC", 1);
}

=head2 C<unsetCalcSpec()>

Do not calculate spectra.

=cut
sub unsetCalcSpec {
	WAVE::setValue("ISPEC", 0);
}

# TODO: es gibt noch viel mehr Modi!!!
=head2 C<setMagnetMode(MODE)>

Set the magnet input to the mode MODE. Possibly choices are I<file>, I<fileLinear> and I<halbach>. There are several more magnet modes in WAVE, but they are not implemented here.

=cut
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

		my (undef, $b0, $lambdau, $number) = @_;

		WAVE::setValue("KHALBA", -1);
		WAVE::setValue("B0HALBA", $b0);
		WAVE::setValue("XLHALBA", 0);
		WAVE::setValue("YLHALBA", 9999);
		WAVE::setValue("ZLHALBA", $lambdau);
		WAVE::setValue("FASYM", 0);
		WAVE::setValue("PERHAL", $number);
		WAVE::setValue("IAHWFOUR", 0);
		WAVE::setValue("XCENHAL", 0);
	}


	else {
		die("(EE)\t Can't change the magnet mode to $mode, because this mode is not supported! Abort.");
	}
}

=head2 C<setPinhole(WX, NX, WY, NY)>

Use a pinhole instead of a single observation point for calculating the spectra. The pinhole has a width of WX and a hight of WY. It is calculated with NX x NY points.

=cut
sub setPinhole {
	my ( $x, $nx, $y, $ny ) = @_;

	WAVE::setValue("MPINZ", $nx);
	WAVE::setValue("MPINY", $ny);
	WAVE::setValue("MPINR", 0);
	WAVE::setValue("PINW", $x);
	WAVE::setValue("PINH", $y);
	WAVE::setValue("IPIN", 1);
}

=head2 C<unsetPinhole()>

Do not use a pinhole for calculations. Use a single observation point instead.

=cut
sub unsetPinhole {
	WAVE::setValue("IPIN", 0);
}

=head2 C<unsetBunch(X, Y, Z)>

Do not use a bunch of particles. Use on single particle instead.

=cut
sub unsetBunch {
	WAVE::setValue("IBUNCH", 0);
}

=head2 C<setBunch(NUMBER, BUNCHMODE)>

Use a bunch of NUMBER particles. The BUNCHMODE should be set tho 3 if not known from WAVE directly.
Please refer to C<WAVE::PARTICLE_FILE>, C<WAVE::make_particles> or C<WAVE::particle_data> to create or set the bunch data.

=cut
sub setBunch {
	my ( $number, $ubunch ) = @_;
	
	WAVE::setValue("IBUNCH", 1);
	WAVE::setValue("NBUNCH", $number);
	WAVE::setValue("IUBUNCH", $ubunch);
}

return 1;