package WAVE::waveIn;

=pod

=head1 NAME

WAVE::waveIn - Packet der wave.in-Datei

=head1 SYNOPSIS

use WAVE::waveIn;

=head1 DESCRIPTION

Stellt den Hash %waveInArray zur weiteren Verwendung bereit. Dieser enthaelt 
die Konstanten der wave.in-Datei, welche aus einer Urdatei gelesen werden.

=head1 AUTHOR

Nils Braun I<area51.nils@googlemail.com>

head1 ACKNOWLEDGEMENTS

Das Programm WAVE ist geschrieben von Michael Scheer. Für weitere Informationen
ueber Lizenzen, siehe dort.

=cut

use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);

# Exportieren der Funktionen und Variablen
our @EXPORT = qw( %waveInArray @waveIn );

# Der Grundtext der wave.in-Configdatei
my $waveInText = <<'WAVEINCONFIGENDE';
  !
 ! 	             VERSION 2.70/11
 !
 $CONTRL
  !-------------------------- USER COMMENT ---------------------------

      CODE='irgendwas'

  !-------------------------- MAIN MODES -----------------------------
	
	! The undulator and wiggler modes should work for standard
	! insertion devices. Reasonable settings for some parameters
	! are taken (mainly in namelist COLLIN).
	! Experienced users might prefere there own settings.

	IUNDULATOR=0	! UNDULATOR MODE:
	
	                ! IBUNCH.EQ.0:
			! whole trajectory is taken as source of
			! synchroton light (ignoring input of
			! parameters WGWINFC, collimators ...)
	                ! ISPECMODE = 3 if NROI=0, =1 else
                        ! IMAGSPLN = -9999
			! NLPOI = 0	
			! WGWINFC = 45.
			! ISPECDIP = 0
			! IFOLD = 1, if IFOLD.NE.0
			! IEFOLD = 1, if IEFOLD.NE.0
			! IF (IPIN.GT.0) IPIN = 1
			! BMOVECUT = 1.E-7
			
	                ! IBUNCH.NE.0:
	                ! ISPECMODE = 2
                        ! IMAGSPLN = 0
			! NLPOI = 0	
			! WGWINFC = 45.
			! ISPECDIP = 0
			! IFOLD = 0
			! IEFOLD = 0
			! IPIN = 1 OR IPIN = 3, IF IPIN.NE.0
			! BMOVECUT = 1.E-7
			

	IWIGGLER=1	! WIGGLER MODE:
			!----------------------------------------------
			! IWIGGLER = 1:
			!----------------------------------------------
			! all poles are treated as separated sources
			! added incoherently
			!
			! fixed parameters
			! (essentially in namelist COLLIN):
			! NLPOI = -9999	(i.e. automaticly calculated)
                        ! IMAGSPLN = -9999
			! WGWINFC = 9999. (i.e. automaticly calculated)
			! WBL0CUT = 0.1	
			! (i.e. lowest considered mag. field)
			! WBL0HYS = 1.0	
			! (i.e. hysteresis factor of WBL0CUT)
			! IBL0CUT = 1	(i.e. parts of the trajectory
			!		 with different sign of the
			!		 magnetic field are treated as
			!		 separat sources)
			! CX1,CY1,CZ1,HIG1,WID1 = 9999.
			! (i.e. automaticly calculated)
			! CX2,CY2,CZ2,HIG2,WID2 = 9999.
			! (i.e. automaticly calculated)
			! ISOUREXT = 0	(i.e. no extansion of source
			!		 to check overlapping sources)
			! SPECCUT = 20.	if considered photon energy is
			!               higher than 20 times the critical
			!		energy of the source, photon flux
			!               is set to zero
			! ISPECMODE = 3, if IBUNCH = 0.AND.NROI = 0, =2 else
			! ISPECDIP = 0
			! IFOLD = 1
			! IF (IPIN.GT.0) IPIN = 1
			!----------------------------------------------
			! SCHWINGER MODE:
			!----------------------------------------------
			! (IWIGGLER > 1)
			!----------------------------------------------
			! all poles are treated as separated sources
			! added incoherently; spectrum is calculated
			! according to SCHWINGER
			!
			! fixed parameters
			! (essentially in namelist COLLIN):
			! *** ISPECDIP = -2
			! WGWINFC = 10.
			! WBL0CUT = 0.1	
			! WBL0HYS = 1.0	
			! (i.e. hysteresis factor of WBL0CUT)
			! IBL0CUT = 1	(i.e. parts of the trajectory
			!		 with different sign of the
			!		 magnetic field are treated as
			!		 separat sources)
			! CX1,CY1,CZ1,HIG1,WID1 = 9999.
			! (i.e. automaticly calculated)
			! CX2,CY2,CZ2,HIG2,WID2 = 9999.
			! (i.e. automaticly calculated)
			! ISOUREXT = 0	(i.e. no extansion of source
			!		 to check overlapping sources)

	IEXPERT=0	! export mode, set to one if neither IUNDULATOR
			! nor IWIGGLER are set
  !-------------------------- ELECTRON -------------------------------

	NSTEPMX=-1	! max. number of steps of electron trajectory
			! (array dimension, F90 only, replaces NWMAXP)
			! if NSTEPMX<0 then NSTEPMX is set to
			! (XSTOP-+XSTART)*MYINUM*1.1*(-NSTEPMX)

	MYINUM=100000	! number of steps per meter for the tracking
			! for more recent version of WAVE this parameter
			! must be high enough for spectrum calculations
	                ! (particularly for ISPECMODE =1)

	DMYENERGY=2.5	! total electron energy [GeV]
	
	IENELOSS=-1	! electron energy loss due to synchrotron radiation
			! is taken into account.
			! -1: Quantum fluctuations are taken into account
			!     see namelist PHOTONN
			! For IEFIELD.ne.0 the energy
			! gain is taken into account
			
	IEFIELD=0	! take electrical field of efield.dat into account
	                ! The energy gain is only taken into account
			! for IENELOSS.ne.0
	
	DMYCUR=0.1	! current [A] of the ring

	XSTART=-1.734	! initial x of the trajectory [m]
			! 9999. means default is used if possible
			! i.e. entrance of the device
			! -9999. XSTART is set to -XSTOP
	XINTER=-9999	! if XINTER not -9999. and not missing trackings starts
			! at XINTER. The particle is tracked forward or
			! backward to XSTART.
			! XSTART,YSTART,...,VXIN,... are overwritten
			! for restart of tracking now beginning at XSTART
			! 9999. means default is used if possible
			! i.e. entrance of the device
			! XINTER=XSTART=9999. is allowed but makes no sense
	XSTOP=1.734	! final x of the trajectory [m]
			! 9999. means default is used if possible
			! i.e. exit of the device
	ZSTART=0	! initial z of the trajectory [m]
	YSTART=0	! initial y of the trajectory [m]

	VXIN=1.0	! initial x-component of velocity vector (relativ)
	VYIN=0.0	! initial y-component of velocity vector (relativ)
	VZIN=0.0	! initial z-component of velocity vector (relativ)
	
	BMOVECUT=0	! in tracking routines, mag. fields below BMOVECUT
			! are treated as zero. This cuts might crucially effect
			! spectrum calculations. In case of problems check
			! convergence of integrations by changing MYINUM, NLPOI
			! etc.

        IHINPUT=0       ! this input file is stored as CWN on histogram file
                        ! 0: no storage
                        ! 1: first 32 characters of line are stored
                        ! 2: first 64 characters of line are
                   	! 3: first 96 characters of line are stored
                        ! neg. value means compression (i.e. skipping
                        ! of comment lines) is suppressed

        IHOUTP=0      	! output file WAVE.OUT is stored as CWN on histogram file

        IHISASCII=0   ! non zero flag generates ASCII-Files
                        ! of histograms
                        ! filename is histogramtitle_index.wvh
                        ! IHISASCII=1 means 1D histos only
                        ! IHISASCII=10 means 2D histos only
                        ! IHISASCII=100 means ntuples only
                        ! for combinations add numbers, e.g. 1+10=11
                        ! means 1D and 2D histos to be treated
                        ! negative values means no header on file
			! In addition some other files e.g. of the
                        ! trajectory are written (names: *.wva)
			! (IROOTREES >= 0)
        CHISASCII='*'   ! Comment marker for header lines i.e. first character

        IROOTTREES=-1    ! Write histograms and NTuples to file wave.root for
                        ! analysis program root
			! <0: Do not write histogram file for PAW
			
        IROOTHDF5=0     ! Write histograms and NTuples HDF5 File wave.h5
	                ! roottohdf5_main.exe must be in search path

   !-------------------------- MAGNETIC FIELD -------------------------------

	IBSUPER=0	! flag to allow superposition of magnetic field
			! configurations

	IBERROR=0	! superimpose magnetic field errors (namelist BERRORN)
			! if IHTRACK is set, phase error analysis is given

	KBEXTERN=0	! magnetic field is taken from user routine BEXTERN
			! file BEXTERN.OBJ must be linked to WAVE

	KBFELD=0	! magnetic field is a sequence of hard edge dipoles
			! parameters namelist BBFELD
			! fring field simulation is offered
			! fields are not MAXWELL conform
			! magnet field routine BFELD
                        ! maybe it's better to use flag KMAGSEQ

	 IBGAUSS=0      ! instead of hard edge, use Gaussian field

	KMAGSEQ=0	! sequence of dipole and quadrupole magnets
			! the sequence is read from file FILEMG
                        ! if negative, magnets to not radiate for IBMASKSP.ne.0
			
			! file format: *
			! 1th column (ASCII): dummy
			! 2th column (ASCII): magnet type (DI or QP)
			!
			! for dipoles (DI):
			!   3th column: deflection angle [rad]
			!   4th column: bending radius [m]
			!   5th column: x-position of magnet center [m]
			!   6th column: parameter s of fringe field function f
			!               f = 1/(1+exp(s*...))
			!               infinit s means hard edge
			!   the field is a product of two Fermi distributions
			!   it is not MAXWELL conform
			!   7th column: ---
			!
			! for quadrupoles (QP):
			!   3th column: lenght of magnet [m]
			!   4th column: gradient g of quadrupole [1/m]
			!   5th column: x-position of magnet center [m]
			!   6th column: z-position of magnet center [m]
			!               to take displacement of beam into
			!		account (due to dipoles)
			!   7th column: rotation angle of magnet in the
			!               orbit plane [rad]
			!               to take slope of trajectory into
			!		account (due to dipoles)
			
			! for quadrupoles (QF): like QP, but with fringe field

			! magnetic field routine BMAGSEQ

	    KMAGCOR=1	! flag to correct fringe field effects on
			! deflection angle

	    IMGSQF=0	! Fourier transformation used for dipole fields
			! makes dipole fields MAXWELL conform

	KHALBA=0	! insertion device described by HALBACH's formulas
			! parameter namelist HALBACH
			! magnetic field routine BHALBA
			! KHALBA.lt.0 means zero field outside device

	KHALBASY=0	! simple WLS model
			! parameter namelist HALBASY
			! each poles described by HALBACH's formulas
			! magnetic field routine BHALBASY
			! field is not smooth nor MAXWELL conform
			! at pole edges
			! magnetic field routine BHALBASY

	KUCROSS=0	! crossed undulator with modulator
			! parameter namelist UCROSSN
			! field is not smooth nor MAXWELL conform
			! at pole edges
			! magnetic field routine BUCROSS

	KELLIP=0	! helical undulator, parameter namelist ELLIPN

        KELLANA=0       ! analytical field for helical undulator,
                        ! parameter namelist ELLANAN, SR BELLANA

        KBREC=0         ! Magnetic field from REC-structure on file
                        ! FILEREC, parameter namelist RECN
                        ! SR BREC (rectangularly shaped magnets)

        KBPOLYMAG=0     ! >0: Read Magnetic field from REC-structure on file
                        ! FILEPM, parameter namelist POLYMAGN
                        ! SR BPOLYMAG (magents are polyeder)
                        ! <0: Write Magnetic field from REC-structure (BREC)
			! to file wave_to_polymag.dat

	IRBTAB=0	! magnetic field By on device axis is read
			! from data file FILETB and interpolated by splines
			! particle must move in orbit plane i.e. y=0
			! magnetic field from routine BTAB
			! fileformat:
			! 1. line: user comment
			! 2. line: scaling factors for x and By to convert to
			!          meter and Tesla
			! 3. line: number of data points (negative means
			!          symmetric field relative to x=0
			! following lines: x By data

	IRBTABZY=0	! magnetic fields By and Bz on device axis are read
			! from data file FILETB and FILETBZ and interpolated
			! by splines (some format as for IRBTAB)

	IRFILB0=0	! read 3D mag. field table from file FILEB0
			! format of routine BMESS
                        ! field is interpolated from equally spaced grid
                        ! IRFILB0=-1 means field is taken from grid point
                        ! IRFILB0=-2 means field is linearily interpolated
                        ! IRFILB0=-4 means field map is given in terms of
			! coefficients of polynomials
                        ! IRFILB0=nonzero else means field is fitted according to
                        ! Maxwell's equations, see NAMELIST BGRIDN
              	        ! IRFILB0=6 to use 3D mag. field map in the
			! format of IWBMAP = 6, linear interpolation scheme
              	        ! IRFILB0=-6 to use 3D mag. field map in the
			! format of IWBMAP = 6, quadratic interpolation scheme

	IRFILF=0	! magnetic field is given as a superposition
			! of HALBACH insertion devices
			! the coefficients of the superposition are read from
			! file FILEF
			! parameter namelist FOURIER
                        ! magnetic field routine BFOUR

        KBAMWLS=0       ! straight section of BAM/PTB-WLS; namelist BAMWLSN

	KBPOLYH=0	! magnetic field is given as a superposition
			! of HALBACH insertion devices calculated by
			! program POLYHARM
			! the coefficients are read from file
 			! wave_bpolyharm_coef.dat
			! the magnetic field is calculated by routine BPOLYHARM

        KBPOLY3D=0      ! magnetic field is calculated from 3D Maxwell conform
                        ! polynomial potential. Coefficients are read from file
                        ! FILE3DFIT
                        ! used coefficients are given via NAMELIST BPOLY3DN

        KBPOLY2DH=0     ! magnetic field is calculated from transversal
			! polynomial and longitudinal harmonical ansatz
                        ! Coefficients are read from file FILE2DHFIT

        KBPHARM=0       ! magnetic field is calculated from
                        ! 3D harmonical fit according to SR BPHARMFIT
                        ! Coefficients are read from file FILEPHFIT

	IRFILP=0	! magnetic field from PANDIRA (file FILEP)
			! magnet field routine BPAND
			! contact M. Scheer

	IBHELM=0	! magnetic field form Helmholtz-coils

        KBGENESIS=0	! read lattice file FILEGEN of FEL-code GENESIS
                        ! and calculate corresponding mag. field
                        ! KBGENESIS > 0: Ntuple of trajectory and
                        !                field is created
                        ! KBGENESIS < 0: no Ntuple
                        ! KBGENESIS = +/- 2: read start conditions form
                        ! file genesis.start

 !-------------------------- OPTIONS -------------------------------


	IBFORCE=0	! Calculation of magnetic forces
	                ! ***ATTENTION: Together with REC calculations are
			! wrong if considered volume inside or partially inside
			! magnet block.
			! Namelist BFORCN
			! Subroutine BFORCE

        IWBPOLY3D=0     ! 3D Maxwell conform polynomial field is fitted
                        ! to field map FILEBMAP.
			! IWBPOLY3D=1 means standard format of FILEBMAP
			! IWBPOLY3D=2 means column format of FILEBMAP
			! Output file is FILE3DFIT
                        ! Relation between coefficients are read from
                        ! file FILE3DCOE
                        ! Order of fit is given via NAMELIST BPOLY3DN

        IWBPOLY2DH=0    ! Field map FILEBMAP is fitted with polynomial
			! ansatz in y,z and harmonical ansatz in x.
			! IWBPHARM = 1 means standard format of FILEBMAP
			! IWBPHARM = 2 means column format of FILEBMAP
			! Output file is FILE2DHFIT
                        ! Periodlength of device and other parameters
			! are given in namelist BPOLY2DHN

        IWBPHARM=0      ! Field map FILEBMAP is fitted 3D harmonical
                        ! ansatz. Field is expanded as series of cosine-like
			! vertical Halbach-Fields and sine-like horizontal
			! Halbach-Fields plus constant offsets
			! Scalar potential:
			! VC:=-B0C/KYC(N,NXY)*COS(NXY*KXC*X)
			!    *SINH(KYC(N,NXY)*Y)*COS(N*KZ*Z
			! VS:=-B0S/KXS(N,NXY)*COS(NXY*KYS*Y)
                        !    *SINH(KXS(N,NXY)*X)*SIN(N*KZ*Z)
			! V0:=-(B0X*X+B0Y*Y+B0Z*Z)
			! V:=VC+VS+V0
			! BX:=-DF(V,X)
			! BY:=-DF(V,Y)
			! BZ:=-DF(V,Z)
                        ! IWBPOLY2DH=1 means standard format of FILEBMAP
                        ! IWBPOLY2DH=2 means column format of FILEBMAP
                        ! Output file is FILEPHFIT
                        ! Periodlength of device and other parameters
                        ! are given in namelist BPHARMN

	IWFILF=0	! coefficients for superposition of HALBACH
			! insertion devices are computed for given field
			! and written to file FILEF
			! in later runs this file is input if flag IRFILF
			! is set
			! parameter namelist FOURIER

        IWSECTMAGS=0	! approximate vertical magnetic field by IWSECTMAGS
                        ! sector magnets, and write them to files wave.smag,
                        ! wave.xmag and wave.strmag
			! IWSECTMAGS < 0: use sector magnets on files wave.smag
			! and wave.xmag as magnetic field for tracking

	IWBTAB=0	! to write By along straight line parallel to
			! device axis or along trajectory onto file
			! FILEWBT
			! for parameters see NAMELIST  WBTABN
			! first and second field integrals and integrated
			! quadrupole and sextupole terms are calculated
			! results of integrations are step by step
			! written to file
			! if (IWBTAB.eq. 100) then trajectory is used
			! rather than straight line

        IWBMAP=0	! to write 3D mag. field map to file FILEBMAP
                        ! according to namelist BMAPN
			! IWBMAP = 1 means field map in standard format
			! IWBMAP = 2 means field map in column format
                        ! IWBMAP = 3 means field map in column format for
                        !          BMESS etc.
                        ! IWBMAP = 4 means field map is written in terms of
			!	   fitted coefficients of polynomials for
                        !          BMESS. The coefficients are calculated
			!	   according to namelist BGRIDN
			!	   IBMRADIAL must be zero
                        ! IWBMAP = 5 convert map of FILEB0 from column format
			!          to format for BMESS; grid input data must
			!	   match that of namelist BMAP
			! IWBMAP = -1 means field map as Ntuple only
			! (option IHBPOLY3D for Ntuple must be set)
			! IWBMAP = 6 means the following format:
			!          lines starting with %,*,!,#,@ are comments
			!          or discription lines, empty lines
                        !          are ignored
			!          WAVE writes the run number and CODE to the
			!          first two lines, e.g.
			!          the data line must come after an
                        !          scaling factor line for x,y,z,bx,by,bz,
                        !          containig the key-word scaling,
			!          e.g. * scaling = 1. 1. 1. 1. 1.
			!          data columns contain x,y,z,bx,by,bz

	IBSYM=0		! IBSYM .ne. 0 means symmetry of device assumed
			! Bx(-x) is set to -Bx(x)
			! By(-x) is set to By(x)
			! Bz(-x) is set to Bz(x)
			! IBSYM .lt. 0 means negative field for x.lt.0

	XBSYM=0.0	! X of symmetry point i.e.
			! e.g. BY(-(X-XBSYM))=BY(X-XBSYM) etc.
			!(depending on IBSYM)

	IBSYMY=0	! IBSYMY .ne. 0 means symmetry of device assumed
			! Bx(-y) is set to Bx(y)
			! By(-y) is set to -By(y)
			! Bz(-y) is set to Bz(y)
			! IBSYMY .lt. 0 means negative field for y.lt.0


	IBSYMZ=0	! IBSYMZ .ne. 0 means symmetry of device assumed
			! Bx(-z) is set to Bx(z)
			! By(-z) is set to By(z)
			! Bz(-z) is set to -Bz(z)
			! IBSYMZ .lt. 0 means negative field for z.lt.0

			! HALBACH classic
			! (note WAVE coordinate-system!!)
			! IBSYM=1, IBSYMY=-1, IBSYMZ=1

        IWFILT0=1	! write for each IWFILT0th step of the trajectory
			! x,y,z,vx,vy,vz,Bx,By,Bz,Ax,Ay,Az
                        ! to file FILETR using '*' Format
                        ! IWFILT0 = 1 means with header:
                        ! 1. line: * run number
                        ! 2. line: * user comment
                        ! IWFILT0 > 1 means with header:
                        ! 1. line: run number
                        ! 2. line: user comment
                        ! IWFILT0 < 0 without header

	IHTRACK=1	!to get histograms of trajectory and
			!magnetic field (only ntuple if negative)
			!every abs(IHTRSMP)th point is taken
                        !IHTRACK=abs(n) means spacing of points
                        !in 0.5xIHTRACK mm for trajectory on grid (ntuple 20)
                        !for ABS(IHTRACK)=9999 namelist WBTABN is used to
                        !define sample range and stepping size
			!if IBERROR is set, phase error analysis is given

	 IHTRSMP=1	!every IHTRSMPth point is taken for NTuple 10

	  XSTARTH=9999. !lower edge of histogram (9999. XSTARTH=XSTART)
	  XSTOPH =9999. !upper edge of histogram (9999. XSTOPH=XSTOP)

	IHINDEX=0	!to get index of created histograms
			!index is written to wave_index.his
			!DOES NOT WORK FOR STATICALLY LINKED VERSION OF WAVE

	IJUST=0		! to adjust closed orbit offset to zero by shifting
			! device horizontally, i.e. adjust variable HSHIFT
			! in of namelist B0SCGLOBN
			! 1. set HSHIFT=0.001(for example), IJUST=1, run WAVE
			! 2. set IJUST=2, re-run WAVE
			! 3. set IJUST=3, re-run WAVE
			!                 re-run WAVE (as often as necessary)
			! 4. set IJUST=4 to use optimized value of HSHIFT
			!    which is written to file FILEJ
			!    or
			!    set IJUST=0 and set HSHIFT accordingly
			!
			! iteration steps are written to file FILEJ

	IUNAME=0	! to call SR UNAME
	IUSTEP=0	! to call SR USTEP
	IUOUT=0         ! to call SR UOUT

 !-------------------------- SPECTRUM CALCULATIONS---------------------------

	ISPEC=1		! to activate spectrum calculations
			! parameter namelists :
			!	COLLIN
			!	SPECTN
			!	WFOLDN
			!	PINHOLE
			!	FREQN

	ISPECMODE=2	! 0: same as 2
	                ! 1: spectrum is calculated by interpolation
	                !    from reference orbit,
	                !    i.e. no tracking of source point with high
	                !    resolution; ROIs are taken into account
	                ! 2: source is retracked with precision according to
			!    NLPOI
			!    ROIs are taken into account
	                !    (recommended for wigglers)
			! 3: use still older algorithm, no ROIs,
			!    no bunches etc., less precise, but faster
			! 4: use still older tracking routine (TRACKSOLD)
			! (test purpose)

	IVELOFIELD=0	! to take velocity field into account
			! IVELOFIELD.eq.0 add velocity field
			! IVELOFIELD.eq.1 do not add velocity field
			! IVELOFIELD.lt.0 velocity field only

         IMAGSPLN=0	! to use spline interpolation of magnetic
			! field from arrays of reference orbit
                        ! (faster, but maybe less accurate)
                        ! IMAGSPLN<0 means field is stored on file
                        ! magjob.dat
			! -9999 means memory mode
                        ! IMAGSPLN>0 means field is read from file
                        ! IMAGSPL:MAGJOB.DAT written by job IMAGSPLN
 			! (out of range problems may occur if NLPOI
			! is of similar size as number of points
			! on reference orbit)
			! NOT COMPATIBLE WITH IWBMAP/IWBTAB/IBFORCE AND IOPTIC
			! is set to -9999 by IUNDULATOR and IWIGGLER

	  XIANF=9999.	! limits of X for integration
	  XIEND=9999.	! 9999. means whole trajectory is taken

          BANWID=0.001	! bandwidth for spectrum calculations

    	  IWFILL0=0	! write sources to file FILEL0

	  IHTRACKM=-1	! histograms and ntuple of mini-trajectory
			! for IHTRACKM.lt.0 only ntuple

	  IRFILL0=0	! read sources from file FILEL0
			! one and only one of these flags must be set
			! IWFILL0=1 is recommended

	  NLPOI=0	! Maximal number of integration steps per source
			! The accuracy of the integration depends on
                        ! this number. Check results of integration by
                        ! increasing NLPOI the step size of the
                        ! integration depends both on NLPOI and
                        ! WGWINFC (namelist COLLIN), since WGWINFC
                        ! influences the extension of the source.
			! For rough calculations NLPOI=1000 should work,
			! for high precision calculations
                        ! 5000<NLPOI<20000 should be good.
			! To get a feeling compare results of WAVE with
			! results of Schwinger mode ISPECDIP.
			! Rule of thumb:
                        ! NLPOI = 500 * WGWINFC * Eph,max/Ecrit
			!
			! NLPOI=0 means NLPOI=(XSTOP-XSTART)*MYINUM+1
			!
			! NLPOI=-9999 means NLPOI is estimated by
                        ! SR NLPOIWIN
			!
			! WAVE knows regions of interest (ROI) with
			! individuell step size; see namelist ROIN
			! Check also MYINUM (ISPECMODE.EQ.1)

	  IFREQ2P=3	! =0 : spectrum is calculated for listed photon
			!      energies on file FILEFR

			! =1 : spectrum is calculated for energy FREQLOW
		   	!      in namelist FREQN

			! =2: spectrum is calculated for the energy range
			!     FREQLOW -> FREQHIG (namelist FREQN)
			!     each step increases energy by powers of 2
			!     fast calculation due to
			!     exp(2**N*E0)=exp(2**(N-1)*E0)**2

			! >2: spectrum is calculated for NINTFREQ
			!     (namelist FREQN) equidistant
			!     energies from FREQLOW TO FREQHIG
			!     (namelist FREQN)
			!     fast calculation due to
			!     exp(N*E0)=EXP((N-1)*E0)*EXP(E0)

	  IHFREQ=1	! to get histograms of spectrum over photon energies
			! (if IFREQ2P > 2)
			! Ntuple for PAW with all information of
			! array SPECT is generated
			! every IHFREQth photon energy is considered

	  ISPECINT=0	! spectrum is integrated over photon energy range

          IPIN=0	! to calculate spectrum in pinhole rather
			! than for list of observation points
			! for the parameters of the pinhole see namelist PINHOLE
			! if negative integration over pinhole is skipped
			! [ OBSOLETE: IPIN = 2 (for ISPECMODE = 5) allows flux calculation with
			! only one mash point in pinhole (see ISPECMODE) ]
			! IPIN = 3, flux through pinhole by Monte-Carlo.
			! Only useful for IBUNCH set. For each electron
			! the observation point is chosen randomly
			! inside the pinhole. The flux-density is calculated
			! from the flux divided by the size of the pinhole
			! If IBUNCH.ne.0 be careful with the interpretation
			! of the flux-density. If e.g. the flux-density is
			! plotted from the Ntuple of 3600 (PAW) or n3600 (root)
			! as a profile histogram, the histogram corresponds
			! to the complete incoherent sum of all
                        ! electrons, even if they are radiation
                        ! coherently. The histogram of the mean flux-density
			! on the contrary shows the flux-density from the
			! coherent radiation

	    IHPIN=0	! to get histograms of flux distributions inside pinhole
                        ! if negative or zero only histograms 10998,10999,11000
                        ! are booked (for KUMAC NFLUX)
			! will be set to zero for IPIN=3

	    IHFOLD=1    ! histograms of folding function for emittance
	                ! procedure
			! will be set to zero for IPIN=3

	    IUSEM=0	! to use the subroutine CONV2 of the program
                        ! USEM for the integration over the pinhole
                        ! and the folding (obsolete, not supported)

	    IPINCIRC=0	! to calculate flux through circular pinhole
	       IRPHI=0	! to use polar coordinates if IPINCIRC is set and
			! IUSEM is not

            ISTOKES=0	! to calculate Stokes vector for flux through pinhole

            IBRILL=0	! to calculate brilliance (spectral brightness)
                        ! flag ISTOKES must be set

	    ISPECSUM=0  ! Integration of arrays SPEC and STOKES are additionally
			! performed by a simple summation (test purposes)

	    IFOLD=0	! to invoke folding procedure to take emittance into
			! account (namelist WFOLDN)
			! IFOLD.EQ.1: use routine UTIL_FOLD_FUNCTION_GAUSS
			! IFOLD.EQ.2: use Monte-Carlo techniques (ISPECMODE = 5)
			! IFOLD.EQ.-1: use routine UTIL_FOLD_FOURIER
			! IFOLD.LT.-2: use routine old precedure of WAVE
			! parameter namelist WFOLDN
			
          ISIGUSR=1	! if flag is set sigmas for folding are taken from
			! namelist WFOLDN, otherwise calculated from emittance
			! and beta functions BETAH, BETAPH, BETAV, BETAVP
			! in namelist DEPOLA (be careful, if distributions are
			! not Gaussians)

          !*** Still experimental!! Check results carefully ***!
	  IBUNCH=0	! Take bunch structure into account.
	                ! IBUNCH=1: First electron is also randomized
	                ! IBUNCH=-1: First electron is not randomized,
			!            be careful with biases.
	  		! See namelist BUNCHN
	
	  IPHASE=0	! calculate complex amplitude in pinhole and
                        ! transform back to source plan and get
                        ! phase space distribution from geometrical
                        ! optic (namelist PHASEN)
			! Ntuples are written to FILEPH
			! IPHASE.LT.0 means spline-integration used
			! ABS(IPHASE.GT.1) means additional application of
                        ! geometrical optic

	  IDOSE=0	! To calculate absorbed energy dose
			!IDOSE > 0: F(X)=AA*X**BB interpolation of coef.
			!IDOSE < 0: linear interpolation of coef.

          IF1DIM=0      ! spectrum calculation and folding only in vertical
                        ! direction

	  IPOLA=0	! if flag is set the flux is calculated from component
			! of complex amplitude parallel to complex vector VPOLA
			! STOKES-Vectors are not affected!!
			! (NAMELIST SPECTN)

	  IEFOLD=0	! =1: fold spectrum with Gaussian to take energy spread
			! of electrons into account (namelist WFOLDN)
			! =2: take beam energy spread into account by Monte-
			! Carlo-technique (ISPECMODE = 5) (check precision)

   	  IWFILSP0=1	! write integration results (arrays SPEC,SPECT) to
			! file FILESP0

   	  IWFILPOW=0	! write power distributions to file FILEPOW
			! IWFILPOW.lt.0 means no user comment on file
			! Meaning of columns: x, y, z, total power density,
			! power density within spectral range, power density
			! within spectral range with emittance
			! *** UNITS: mm Watt/mm**2!!

	  IWFILRAY=0	! write integration results to data file for RAY
	                ! (only for first photon energy)

   	  IRFILSP0=0	! read integration results (arrays SPEC,SPECT) from
			! file FILESP0 (test purposes)

   	  IRFILSTO=0	! read integration results for Stokes vectors from
			! file FILESTO

   	  IAMPLI=0	! IAMPLI>0:
			! reads or writes amplitudes of integration
			! to file FILEAMPLI (array REAIMA).
			! Treatment of data is done in SR ADDAMPLI and
			! controlled by namelist AMPLIN
   			! IAMPLI<0:
			! sums up IAMPLI times the calculated
			! amplitude such that:
			! Asum=|A1|*(exp(i*phi1) + |A2|*exp(i*2*phi2)+...)
			! where the amplitudes and phases are corrected for
			! depth of field effects.
			! To take random phase errros into account, use
			! variables AMPRAN and IAMPSEED in namelist
			! AMPLIN. AMPRAN referes here the lenght of the
			! repeated amplitude, AMPFREQ is adjusted to 1. harm.
			! AMPSHIFT(1) is applied in addition.
			! Check contribution of endpoles!!!
			! To ignore end poles use variables XIANF and XIEND.

           IAMPJIT=0    ! Jitter on phase is calculated by tracking the device
                        ! period by period (IAMPLI.LT.0)

	  IWFILSPF=0	! write folded integration results
			! (arrays SPECF,SPECTF) to FILESPF

   	  IWFILSTO=0	! write integration results for Stokes vetors to
          		! file FILESTO. PAW-Macros NFILS0 and HFILSTO can be used to
          		! visualize data.


   	  IWFLSTOF=0	! write integration results for folded Stokes vetors to
          		! file FILESTOF. PAW-Macros NFILS0F and HFILSTOF can be used to
          		! visualize data.

   	  IWFLSTOE=0	! write integration results for Stokes vetors with
	  		! energy spread to file FILESTOE
          		! PAW-Macros NFILS0E and HFILSTOE can be used to
          		! visualize data.

   	  IWFLSTOEF=0	! write integration results for folded Stokes vetors
	  		! with energy spread to file FILESTOEF
          		! PAW-Macros NFILS0EF and HFILSTOEF can be used to
          		! visualize data.

   	  IWFILFL0=1	! write flux through pinhole to file FILEFL0

   	  IWFILFLF=0	! write folded flux through pinhole to file FILEFLF

          IWFILS=0      ! write STOKES vector of flux through pinhole to
	  		! file FILES
          IWFILSE=0     ! write STOKES vector of flux through pinhole to
	  		! file FILESE including beam energy spread
          IWFILSF=0     ! write STOKES vector of flux through pinhole to
	  		! file FILESF including beam emittance
          IWFILSEF=0    ! write STOKES vector of flux through pinhole to
	                ! file FILESEF including beam emittance and beam
			! energy spread

          IWFILB=0      ! write STOKES vector of selected point to file FILEC
          IWFILBE=0     ! write STOKES vector of selected point to file FILECE
                        ! including beam energy spread
          IWFILBF=0     ! write STOKES vector of selected point to file FILECF
                        ! including beam emittance
          IWFILBEF=0    ! write STOKES vector of selected point to file FILECEF
                        ! including beam emittance and beam energy spread

          IWFILBRILL=0      ! write brilliance of STOKES vector of selected point to file FILEBRILL
          IWFILBRILLE=0     ! write brilliance of STOKES vector of selected point to file FILEBRILLE
                        ! including beam energy spread
          IWFILBRILLF=0     ! write brilliance of STOKES vector of selected point to file FILEBRILLF
                        ! including beam emittance
          IWFILBRILLEF=0    ! write brilliance of STOKES vector of selected point to file FILEBRILLEF
                        ! including beam emittance and beam energy spread

	  IWFILINT=0	! if set to N, the integral of the Nth source for first
			! observation point and first photon energy is
			! written to file FILEINT (test purposes)
			! IWFILINT.LT.0 means field amplitudes are
			! written to Ntuple
	                ! (range from XIANF to XIEND)

          JWFILINT=1	! spacing of points for IWFILINT

	  IPINALL=0	! to print results of spectrum calculation for
			! all observation points to output file WAVE.OUT

	  ISPECANA=0	! spectrum is taken from user routine SPECANA
			! (test purposes)

	  ISPECANAF=0	! folded spectrum is taken from user routine SPECANAF
			! (test purposes)

	  IDESYNC=0	! to calculate dose from DESYNC spectrum file	
			! IDESYNC.EQ.-9999 programs uses EGS4 spectrum file
			! IDESYNC.lt.0 programs asks for spectrum number
			! IDESYNC.gt.0 IDESYNC is spectrum number

          ISPECDIP=0    ! to calculate spectrum from pure dipole from
	  		! Bessel functions
			! ISPECDIP > 0: calc. according to namelist SPECDIPN
			! ISPECDIP = 2: G1 is calculated instead of photon flux
                        !               FREQLOW and FREQHIGH are interpreted as
                        !               Egamma/Ec
			! ISPECDIP=-1: calc. spectrum at center of found sources
			!              according to SCHWINGER (fast)
			! ISPECDIP=-2: calc. spectrum at according to SCHWINGER
			!              the source is located where the
			!              observation angle has a mininum
			!	       the angle is calculated from particle
			!              trajectory
			!	       *** recommended ***
			! ISPECDIP=-3: calc. spectrum at according to SCHWINGER
			!              the source is located where the
			!              observation angle has a mininum
			!	       the angle is calculated from particle
			!              trajectory retracked within source with
			!	       high resolution (slow but more precise!?)
			! mag. field is pure By-field i.e. vertical field

	  IUNIT=0	! to use wavelength [nm] rather than energy [eV]
			! to characterize photons


 !-------------------------- GENERATING FUNCTION  -------------------------

	IOPTIC=0	        ! to generate a set of trajectories
				! for fitting of generating function
				! trajectories are written to file FILEO	
				! parameter namelist OPTIK (IOPTIC.gt.0)
                                ! IOPTIC=-1: Tracks are generated according to
                                ! phasespace ellipse given by
                                ! EPS0H, BETAH, BETAPH, EPS0V, BETAV, BETAVP
			        ! in namelist DEPOLA
				
	IGENFUN=0		! trajectories are read from file FILEO	
				! to fit generating function
				! parameter namelist TRANPON
                                ! if negativ not generating function but
                                ! mapping (xf,xpf,yf,ypf) of (xi,xpi,yi)
                                ! is calculated
				
	IERZFUN=0		! to generate set of trajectories using
				! given coefficients of generating function
				! coefficients are user supplied by file
				! wave_erzfun.in (test purposes)
				
				! IERZFUN=+/-100 (subroutine IDTRMSHGF)
				! subroutine ERZFUN else
				
				! in context of phase ellipse tracking this
				! flag controls the use of Generating Funktion
				! IERZFUN<0: Only linear tracking, all coeffs.
				! else
				
	IERZANA =0		! set of trajectories calculated analytically
				! by user supplied routine ERZANA.FOR
				! (test purposes)

 !-------------------------- OTHER TASKS  -------------------------------

	IPOWER=0	! to calculate power and photon distributions on
			! beamline walls
			! distributions are stored in histogramms
			! parameter namelist SPECTN

	IEMIT=0		! to calculate emittance change due to WLS
			! radiation integrals I2,I4 and I5
			! and optical functions at WLS
			! location must be given by user in
                        ! namelist DEPOLA.
                        ! Additionally the trajetory with start values of
                        ! namelist PHASETRACKN is tracked an written to
                        ! the file FILEZZPYYP

	IHBETA=0	! to get histograms of optical functions
	 	        ! every IHTRSMPth point is taken for histograms
			
	IEMIAHW=0	! to calculate emittance effects for simple WLS
			! model form analytical formulas
			! device must have only one main pole
			! flag KHALBASY must be set, derivation
			! of external dispersion must be DDISP0=0
			! radiation integrals I2,I4 and I5
			! and optical functions at WLS
			! location must be given by user in
			! namelist DEPOLA

	IWLSOPT=0	! seach for optimal parameter of simple
			! WLS model (one main pole)
			! parameter namelist WLSOPTN

	IBEAMPOL=0	! to get information about beam polarization time
			! and final level of beam polarisation
			! parameter of ring must be given in namelist DEPOLA

       $END

 $GSEEDN

	IGSEED1=0	! first seed for random generator grndm used by
	                ! various routines
	                ! to set seed, both seeds must be given
	IGSEED2=0	! second seed for random numbers
			! -9999 (both): Seeds are read from file wave.gseed,
	                ! which is written before WAVE terminates
        $END

 !-------------------------- Parallel processing  -------------------------------

 $cluster
 	 ICLUSTER=0 !<0: split run for parallel processing
 	  	    !>0: collect results of parallel processing
		
         WPPATH='/home/scheer/wav/stage'   !path to working directory
	 				   !(icluster>0)
 $end

 !-------------------------- PARAMETER NAMELISTS -------------------------------

 $B0SCGLOBN

	ICHARGE=-1	! particle charge
			! ICHARGE.LE.0 means e-
			! ICHARGE.GT.0 means e+

	IBMASK=0	! field of namelist BBFELD is used as
			! weight function for magnetic field, i.e.
			! BX=BX*BMASK, BY=BY*BMASK, BZ=BZ*BMASK
                        ! negative values of IBMASK means field is added, i.e.
			! BY=BY+BMASK
			! Format of wave.bmask:
			! Xi Xe Bmask, i.e. intervall boundary and scaling factor
                        ! IBMASK=100 means masks are read from file wave.bmask
                        ! (multiplication only)
                        ! IBMASK=-100 a user defined function UBMASK is called
                        ! (multiplication)
                        ! IBMASK=-200 a user defined function UBMASK is called
                        ! (summation)

	IBMASKSP=0	! field is taken into account for tracking only,
                        ! but does not contribute to radiation,
                        ! i.e. phase-shifter
			! works only for ispecmode=1 or ispecmode=2
			! IBMASKSP.NE.0 works only for IBMASK=0

	BYGOFF=0.0 	! global offset for magnetic field
			! By is set to By+BYGOFF
	BZGOFF=0.0 	! global offset for magnetic field
			! Bz is set to Bz+BZGOFF
	A0SCGLOB=1.0	! global scaling factor for magnetic vector
			! potential
	B0SCGLOB=1.0	! global scaling factor for magnetic field
			! B is set to B*B0SCGLOB
			! (BYGOFF is added before)
	A0SCGLOBY=1.	! global scal. factor for magnetic vector
			! potential in Y
	B0SCGLOBY=1.0	! global scaling factor for magnetic field in Y

	A0SCGLOBZ=1.	! global scal. factor for magnetic vector
			! potential in Z
	B0SCGLOBZ=1.0	! global scaling factor for magnetic field in Z

	XSHIFT=0.0	! x-shift of device
                        ! (x(elect) -> x(elect)+XSHIFT) [m]

	XBSHIFT=0.0	! x-shift of device immediately before specific
	                ! field routine is called, i.e. after all symmertry
			! operations etc.
                        ! (x(elect) -> x(elect)+XBSHIFT) [m]
			! Useful to symmtrize e.g. the fixed REC-undulators
			! by setting xbshift to a quater of the periodlength
			! and ibsym=1

        XSHBTAB=0.0	! x-shift for FILETB and  FILETBZ (option IRBTAB)
	

	HSHIFT=0.0      ! horizontal shift (z(elec)->z(elec)+HSHIFT)
	VSHIFT=0.0	! vertical (y(elec)->y(elec)+VSHIFT)

	XROTD= 0.0	! rotation angle around x-axis [degree]
			! z(elec) -> z*cos(XROTD) - y*sin(XROTD)
			! y(elec) -> z*sin(XROTD) + y*cos(XROTD)
			! the rotation is performed after the
                        ! translation !!
			! before you use these options, please consult
			! the manual
        IPERIODG=0      ! *** Attention: The options are applied in
			! the order:
			! XSHIFT..., IPERIODG, IBSYM...
			!>0: magnetic field is taken periodically
                        !    with period length PERIODG
			!-1: magnetic field is taken periodically with
			!    period length PERIODG, for
			!    XPERWMN < X < XPERWMMX
			!-2: magnetic field is taken periodically with
			!    period length PERIODG from half period,
			!    for XPERWMN < X < XPERWMMX
			!-3: magnetic field is taken periodically with
			!    period length PERIODG from quarter of
			!    period for cosine-like fields (in X)
			!    for XPERWMN < X < XPERWMMX
			!-4: magnetic field is taken periodically with
			!    period length PERIODG from quarter of
			!    period for sine-like fields (in X) for
			!    XPERWMN < X < XPERWMMX
	XPERWMN=0.0	!    lower X, for which field is taken
			!    periodically	
	XPERWMX=0.0	!    upper X, for which field is taken
			!    periodically	
        PERIODG=0.8   ! period length of magnetic field
        PEROFFG=-0.4  ! X-offset of magnetic field
                        ! B(X,Y,Z)=B(MOD(X-PEROFFG,PERIODG),Y,Z)
        SIGNG=1.E0      ! factor to scale or reverse (if negative)
                        ! field after half a period
        SIGNG2=0.E0     ! factor to scale or reverse (if negative)
                        ! field after a full period
			! is ignored if zero
 $END

 $BBHELM
        P0HELM(1,1)=-0.000    !x-position of coil center
        P0HELM(3,1)=0.0	      !z-position of coil center
        P0HELM(1,2)=0.0
        P0HELM(3,2)=0.0
        P0HELM(1,3)=0.000
        P0HELM(3,3)=0.0
        R0HELM(1)=0.883782970238297  !radius [m] of coil
        R0HELM(2)=0.2
        R0HELM(3)=0.6
        B0HELM(1)=-1.5
        B0HELM(2)=7.5
        B0HELM(3)=0.
        INTHELM=100	  ! number of linear segments to form coil
        $END

 $BBFELD
		! field is not MAXWELL conform
		! selected by flag KBFELD

       	XM1=-1. !entrance [m]
        XP1=+1. !exit[m]
       	BBY1=1. !field [T]
	YSOFT1(1)=0.1    !width of left fring field[m]
	YSOFT1(2)=0.1    !width of right fring field [m]
	
       	XM2=2. !entrance [m]
        XP2=3. !exit[m]
       	BBY2=1. !field [T]
	YSOFT2(1)=0.0    !width of left fring field[m]
	YSOFT2(2)=0.0    !width of right fring field [m]
	
       	XM3=4. !entrance [m]
        XP3=5. !exit[m]
       	BBY3=1. !field [T]
	YSOFT3(1)=0.0    !width of left fring field[m]
	YSOFT3(2)=0.0    !width of right fring field [m]
	
       	XM4=6. !entrance [m]
        XP4=7. !exit[m]
       	BBY4=1. !field [T]
	YSOFT4(1)=0.0    !width of left fring field[m]
	YSOFT4(2)=0.0    !width of right fring field [m]
	
       	XM5=8. !entrance [m]
        XP5=9. !exit[m]
       	BBY5=1. !field [T]
	YSOFT5(1)=0.0    !width of left fring field[m]
	YSOFT5(2)=0.0    !width of right fring field [m]
	
       	XM6=10. !entrance [m]
        XP6=11. !exit[m]
       	BBY6=1. !field [T]
	YSOFT6(1)=0.0    !width of left fring field[m]
	YSOFT6(2)=0.0    !width of right fring field [m]
	
       	XM7=12. !entrance [m]
        XP7=13. !exit[m]
       	BBY7=1. !field [T]
	YSOFT7(1)=0.0000    !width of left fring field[m]
	YSOFT7(2)=0.0000    !width of right fring field [m]
	
	$END

 $HALBACH
			! coordinate system here different from the
			! standard of WAVE, HALBACH's convention used
			! i.e. z is longitudinal device axis
			! the system is internally converted to WAVE standard

	B0HALBA=3	! peak field [T]
	XLHALBA=0  	! 2*pi/kx (horizontal gradient) [m]
			! XLHALBA=0 means YLHALBA=ZLHALBA (no gradient)
	YLHALBA=9999	! is calculated from the relation ky**2=kx**2+kz**2
	ZLHALBA=0.051	! 2*pi/kz [m]
	ZLENHAL=9999. 	! total device length [m]
	PERHAL=68	! number of periods (NOT NECESSARYLY INTEGER)
			! if positive then ZLENHAL is recalculated
			!            ZLENHAL=ZLHALBA*PERHAL
			! if negative then ZLHALBA is recalculated
			!            ZLHALBA=-ZLENHAL/PERHAL
	$END

 $HALBASY
			! endpoles are also described by HALBACH formulas
			! the pole width is adjusted to have zero first and
			! second field integrals
			! the field is refered to as simple WLS model
			! (usually one main pole)
	B0HALBASY=3    ! peak field [T]
	XLHALBASY=0	! 2*pi/kx for global horizontal gradient [m]
			! XLHALBASY=0 means YLHALBASY=ZLHALBASY (no gradient)
	YLHALBASY=9999	! calculated from ky**2=kx**2+kz**2
	ZLHALBASY=0.051	! 2*pi/kz of main poles [m]
	FASYM=0	! asymmetry parameter, i.e.
			! absolute value of peak field ratio of main-
			! and endpoles
			! for FASYM=2.0, cos(k*x)+cos(2*k*x) is used, i.e.
			! sign changes at ZLHALBASY/6.
			! for FASYM=2.0+eps, cos(k*x)+cos(2*k*x) is used, i.e.
			! sign changes at ZLHALBASY/4.
	AHWPOL=68	! number of main poles
	IAHWFOUR=0	! use field composed by Fourier superposition of
			! HALBACH devices; fourier coefficients A(1)...A(NFOUR)
			! are calculated analytically
			! parameter NFOUR in namelist FOURIER
        XCENHAL=0     ! longitudinal position of undulator center [m]
	
	$END

$UCROSSN
                        ! undulator, a modulator, and a vertical undulator
                        ! each device consists of main poles and two end poles

        B0UCROSS(1)=-0.125 ! peak field of first undulator (horizontal) [T]
        B0UCROSS(2)= 0.035 ! peak field of modulator [T]
        B0UCROSS(3)=-0.125 ! peak field of second undulator (vertical) [T]

        UASYM(1)=2.4      ! asymmetry parameter, i.e.
                          ! absolute value of peak field ratio of main-
                          ! and endpoles
        UASYM(2)=1.5
        UASYM(3)=2.4

        NMUPOL(1)=11      ! number of main poles of first undulator
        NMUPOL(2)=1       ! number of main poles of modulator
        NMUPOL(3)=13      ! number of main poles of second undulator

        ZLUHAL(1)=0.084 !period length of first undulator [m]
        ZLUHAL(2)=0.140 !period length of modulator [m]
        ZLUHAL(3)=0.084 !period length of second undulator [m]

        IUCRSAX=0       !IUCRSAX.NE.0 end pole splitting 1:3:4
                        !IUCRSAX=2 horizontal undulator is centered
                        !IUCRSAX=3 vertical undulator is centered

	$END


 $ELLIPN

 	PARKELL=4.	! if not zero, it is effective K-parameter of undulator
	                ! mag. fields B0ELLIPV and B0ELLIPH are adjusted
			! signs and ratio of B0ELLIPV and B0ELLIP are kept
        B0ELLIPV=0.353553E0   ! vertical peak field   [T]
        B0ELLIPH=0.353553E0	  ! horizontal peak field   [T]
        XLELLIP=0.056   ! period length [m]
        PERELLIP=31.    ! number of periods
        ELLSHFT=0.25    ! shift of horiz. and vert. fields [periods]

	NHARMELL=0      ! if not zero, magnetic field is calculated such, that
			! the energy of the NHARMth harmonic is HARMELL
			! signs and ratio of B0ELLIPV and B0ELLIP are kept
			! OVERWRITES PARKELL!
	HARMELL=2000.	! photon energy of considered harmonic [eV]
			!-9999.: HARMELL=(FREQLOW+FREQHIG)/2 or
			!        or = FREQLOW for single photon energy
        XCENELL=0.0     ! longitudinal position of undulator center [m]

        $END

 $ELLANAN
 			 ! hard edge endpoles (be careful)

        B0ELLANA=1.     ! field amplitude [T]
	NPERELLA=32	! number of periods
        XLELLANA=0.2  	! lx [m]
        ZLELLANA=0.112  ! lz [m]
	X0ELLANA=0.0205	! x0 [m], distance of magnet center from device axis
	GAPELL=0.024	! full gap [m]
	REFGAPELL=0.02	! reference gap of coefficiens [m]	
        SHELLANA=0.25   ! shift in units of ZLELLANA
        ROWSHELLA=0.    ! additional row shift of lower rows 	
                        ! shift in units of ZLELLANA
        IELLS2S3=1      !>=0: S3-MODE; <0: S2-MODE
        IELLCOEF=0      !>0: read IELLCOEF Fourier coefficients from file
			!    bellana.coef
                        !=<0: First and second coefficients only with C0=0.5,
			!     and C1=1.

        $END

 $FOURIER
			!axis
			!coefficients are weights for superposition of
			!a series of HALBACH devices

        NFOUR=-9999     !number of coefficient taken for superposition
                        !-9999 NFOUR is read from file FILEF (IRFILF set)
	NFOURWLS=32	!number of coefficients written to file FILEF
	IFOUR0=0	![0/1] coefficient A(0) is not/is set to zero
			!this allows one to adjust first and second
			!integral of magnetic field to zero
	XLENFOUR=0.0	!2*pi/kx (to superimpose horizontal gradient) [m]
	DBHOMF=0.0001	!x is calculated for which dB(x)/B(0) = DBHOMF [m]
	IPRNTF=0	!to print coefficients to output file WAVE.OUT

	$END

$DEPOLA
	RDIPOL=	4.359	! 1.3 Tesla
	UMFANG=	240.	
	TAUKRIT=4.0	

			! natural emittance 	epsilon_n=6.1E-9

			     ! high beta:

				! 		beta_x   =16.2
				!		sigma_x  =3.1436E-04
				!		sigma_xp =1.9405E-5

				!		SIG_X_10m=3.6943E-4

				! (3 % coupl.)	beta_y  =3.1
				!		sigma_y =2.3818E-5
				!		sigma_yp=7.6832E-6

				!		SIG_Y_10m=8.0439E-5

			     ! low beta:

				! 		beta_x   =0.94
				!		sigma_x  =7.5723E-5
				!		sigma_xp =8.0557E-5

				!		SIG_X_10m=8.0912E-4

				! (3 % coupl.)	beta_y  =2.1
				!		sigma_y =1.9604E-5
				!		sigma_yp=9.3350E-6

				!		SIG_Y_10m=9.5387E-5


	BETFUN=0.0       ! hori. beta-function in the center, where the
	                ! derivative is zero
			! 0.: calculated from BSIGZ(1) in namelist WFOLDN	
	                ! -9999.: BETAH and BETAPH are calculated as periodic
			!        solution from lineare Transfermatrix
	BETAH=9999.	! hor. beta-function at entrance of device
	       		! 9999.: calculated from BETFUN with parabolic ansatz
			! under the assuption, that the derivative is zero
			! where the hori. beta-function equals BETFUN
	       		! -9999.: calculated analytically from BETFUN
			! under the assuption, that the derivative is zero
			! where the hori. beta-function equals BETFUN
        BETAPH=9999.    ! derivative of hor. beta-function at entrance of device
	       		! 9999.: calculated from BETFUN with parabolic ansatz
			! under the assuption, that the derivative is zero
			! where the hor. beta-function equals BETFUN
	       		! -9999.: calculated analytically from BETFUN
			! under the assuption, that the derivative is zero
			! where the hori. beta-function equals BETFUN
			
	EPS0H=0.0	! 6.1D-9 is actually natural emittance, not the
	                ! horizontal one
			! 0.: calculated from BSIGZ(1) and BSIGZP(1)
			!     in namelist WFOLDN
			
	BETFUNV=0.0      ! vert. beta-function in the center
			! 0.: calculated from BSIGZ(1) in namelist WFOLDN	
	                ! -9999.: BETAV and BETAPV are calculated as periodic
			!        solution from lineare Transfermatrix
	BETAV=9999.     ! vert. beta-function at entrance of device
	       		! 9999.: calculated from BETFUNV with parabolic ansatz
			! under the assuption, that the derivative is zero
			! where the vert. beta-function equals BETFUNV
	       		! -9999.: calculated analytically from BETFUNV
			! under the assuption, that the derivative is zero
			! where the vert. beta-function equals BETFUNV
        BETAPV=9999.    ! derivative of vert. beta-function at entrance of device
	       		! 9999.: calculated from BETFUNV with parabolic ansatz
			! under the assuption, that the derivative is zero
			! where the vert. beta-function equals BETFUNV
	       		! -9999.: calculated analytically from BETFUNV
			! under the assuption, that the derivative is zero
			! where the vert. beta-function equals BETFUNV
			
        EPS0V=0.0
			! 0.: calculated from BSIGY(1) and BSIGYP(1)
			!     in namelist WFOLDN

	DISP0=0.0	! external dispersion [m]
        DDISP0=0.0	! derivative of external dispersion [m]

	DI2RING=1.4414  ! radiation integral I2 of storage ring
	DI4RING=0.0	! I4
	DI5RING=0.0020588 ! I5

	DELGAM=0.0007		
				
	$END

 $WLSOPTN
		! one main pole and two endpoles
		! refere to namelist HALBASY
		! the three parameters are variated on a grid
		! the device which meets best the boundary
		! condition is selected

	B0MIN=6.0	! minimum peak field of main pole
	B0MAX=6.0	! maximum peak field of main pole
	DB0=  0.1	! step size for variation

	XLAM0MN=0.4	! minimum double width of main pole
	XLAM0MX=1.0	! maximum double width of main pole
	DXLAM0=0.01	! step size of variation

	FASYMMN=2.0	! minimum asymmetry parameter
	FASYMMX=10.0	! maximum asymmetry parameter
	DFASYM= 0.1	! step size

	EMICRTMX=1.0	! critical emittance change that can be accepted
			! relative factor i.e. emittance of ring + wls
			! over emittance of ring
			! referes to actual beam energy (DMYENERGY)
	IEMICRIT=0	! if not zero EMICRTMX referes to minimal beam energy
			! that is acceptable from polarization time
			! for this option must DISP0=0
	TAUCRTMX=4.	! critical beam polarization time that is acceptable [h]
	POLLEVMN=.80	! critical final beam polarization that is required
			! referes to lowest beam energy [POLLEVMN < 0.92]
	ZMAXMN=0.015	! minimum required displacement of trajectory [m]
	ZMAXMX=1.0	! maximum required displacement of trajectory [m]
	DXHOM=0.0	! x-value for which homogenity requirements of the
			! magnetic field are still fulfilled
			! homogenity limit is given by DBHOMF in
			! namelist FOURIER
	$END

 $MYFILES
		! all other files written or read have names beginning with
		! WAVE_....
                ! the logical unit numbers below 50 are used by WAVE
		! and must not be used by the user

	FILEOB=		'observ.in'		! list of observation points
	LUNOB=		71

	FILEFR=		'freqs.in'		! list of photon energies
	LUNFR=		72

	FILESP0=	'wave.sp0'		! data of calculated spectrum
	LUNSP0=		73

	FILEPOW=	'wave.pow'		! power distributions
	LUNPOW=		73

	FILEINT=	'wave_int.dat'		! integrand of spectrum
	LUNINT=		74			! calculations


	FILEHB=		'wave_histo.his' 	! HBOOK/PAW histogram file
	LUNHB=		75

	FILEL0=		'wave_l0.dat'		! source points
	LUNL0=		76

	FILERAY=	'wave_ray.dat'		! data for RAY
	LUNRAY=		80

	FILEO=		'wave_optic.dat'	! set of trajectories for
	LUNO=		81			! generating function fit

	FILED=		'wave_disper.dat' 	! obsolete
	LUND=		82

	FILECOD=	'WAVE_CODE.DAT'		! program run counter (ICODE)
	LUNCOD=		83

	FILEF=		'btab.fou'		! Fourier coefficients of
	LUNF=		84			! magnetic field

	FILETB=		'btab.dat'
	LUNTB=		85

	FILETBZ=	'bz.dat'	! 1D table of magnetic field Bz
	LUNTBZ=		70

	FILETR=		'wave_track.dat' 	! trajectory and magnetic field
	LUNTR=		86

	FILEP=		'wave_poisson.dat' 	! POISSON output data
	LUNP=		87			! (modified version of POISSON)

	FILEJ=		'wave_adjust.dat'	! scratch file for option IJUST
	LUNJ=		88

	FILEB0='bmap.dat'	! 3D table of B-field
	LUNB0=		89

	FILEBE=		'wave_beta.dat'		! obsolete
	LUNBE=		89

	FILEWB=		'wave_wbeta.dat'	! optical functions
	LUNWB=		90

	FILEZZPYYP=	'wave_zzpyyp.dat'       ! phase space trajectory
	LUNZZPYYP=	 91

	FILESPF=	'wave_specf.dat'	! data of folded spectrum
	LUNSPF=		92

	FILEWBT=	'wave_wbtab.dat'	! magnetic field and integral
	LUNWBT=		93			! multipole terms along
						! straight line
	
	FILEABS=	'sigma_tot.pb'		! absorption coefficients
	LUNABS=		94			! of filter

	FILEFF=		'gold.eff'		! photo yield of gold
	LUNEFF=		94			

	FILEMG=		'magseq.in'		! sequence of magnets
	LUNMG=		95		

	FILEFL0=	'wave_flux0.dat'	! flux through pinhole
	LUNFL0=		96

	FILEFLF=	'wave_fluxf.dat'	! folded flux through pinhole
	LUNFLF=		97

	FILESTO=	'wave_stokes.dat'	! stokes dist. in  pinhole
	LUNSTO=		98

	FILESTOF=	'wave_stokesf.dat'	! f-folded stokes dist. in
						! pinhole
	LUNSTOF=	99

	FILESTOE=	'wave_stokese.dat'	! e-folded stokes in pinhole

	FILESTOEF=	'wave_stokesef.dat'	! ef-folde stokes in  pinhole

        FILES=          'wave_stokes_flux.dat'  ! STOKES vector of flux through
        LUNS=           69

        FILESE=         'wave_stokese_flux.dat' ! STOKES vector of flux through
        LUNSE=          69                      ! with beam energy spread

        FILESF=         'wave_stokesf_flux.dat' ! STOKES vector of flux through
        LUNSF=          69                      ! with beam emittance

        FILESEF=        'wave_stokesef_flux.dat' ! STOKES vector of flux through
        LUNSEF=         69                      ! with beam energy spread and e

        FILEC=          'wave_stokes_selected.dat'  ! STOKES vector of flux through
        LUNC=           69

        FILECE=         'wave_stokese_selected.dat' ! STOKES vector of flux through
        LUNCE=          69                      ! with beam energy spread

        FILECF=         'wave_stokesf_selected.dat' ! STOKES vector of flux through
        LUNCF=          69                      ! with beam emittance

        FILECEF=        'wave_stokesef_selected.dat' ! STOKES vector of flux through
        LUNCEF=         69                      ! with beam energy spread and e

        FILEBRILL='wave_stokes_brilliance_selected.dat'  ! brilliance of STOKES vector of flux through


        FILEBRILLE='wave_stokes_brilliance_e_selected.dat' ! brilliance of STOKES vector of flux through
                                                           ! with beam energy spread

        FILEBRILLF='wave_stokes_brilliance_f_selected.dat' ! brilliance of STOKES vector of flux through
          						   ! with beam emittance

        FILEBRILLEF='wave_stokes_brilliance_ef_selected.dat' ! brilliance of STOKES vector of flux through
        						     ! with beam energy spread and e

	FILEAM=		'abscoef_merge.in'	!List of files to be merged
                                                !OR input files
                                                !for option IFILMUL
	LUNAM=		67

        FILEAMO=	'ABSCOEF_MERGE.OUT'	!Resulting absorption coefficients
        LUNAMO=		68

        FILEREC=        'rec.par'           ! REC-structure
        LUNREC=         69

        FILEBMAP=       'bmap.dat'        ! Magnetic field map
        LUNBMAP=        67

        FILE3DCOE=      'bpoly3d.coef'          ! REDUCE coefficient file
        LUN3DCOE=      67

        FILE3DFIT=      'bpoly3d.fit'           ! fitted coefficient file

        FILE2DHFIT=      'bpoly2dh.fit'        ! fitted coefficient file
        LUN2DHFIT=      67

        FILEPHFIT=      'bpharm.fit'        ! fitted coefficient file
        LUNPHFIT=      67


        FILEPH=      'phase.his'        ! NTUPLE-file for sr phase
        LUNPH=      67

        FILEAMPLI=   'reaima.dat'       ! File for field amplitudes
        LUNAMPLI=      67

       FILEFTH=   'htaper.dat'       ! File for field amplitudes
       FILEFTV=   'vtaper.dat'       ! File for field amplitudes
       LUNFT=      50

       FILEGENL=   'genesis.lat'      ! Lattice-File of FEL-code GENESIS
       LUNGENL=      67

       FILEGENI=   'genesis.lat'      ! Lattice-File of FEL-code GENESIS
       LUNGENI=      67

        $END

 $TRALINN
          !(DELTAZ,0,0,0), (0,DELTAZP,0,0), ...
	  ! matrix is written to file TRALIN.WAV
	  ! entrance and exit planes are perpendicular to closed orbit
          ! be careful for dipoles (are treated as sectors)

          ! Phasespace ellipses are calculated, if IPHELLIP.ne.0

          ! the transfer matrix is also applied to the variables of namelist
          ! PHASETRACKN

        DELTAZ= 0.0	!horizontal coordinate [m]
        DELTAZP=0.0	!horizontal slope [radian]
        DELTAY= 0.0  !vertical coordinate [m]
        DELTAYP=0.0  !vertical slope [radian]
	DELTAE=0.0  !rel. energy spread

        $END

 $PHASETRACKN
      PHTRZ0=0.001    !Z0 in phase with respect to closed orbit (hori.)
      PHTRZP0=0.001   !ZP0 in phase with respect to closed orbit
      PHTRY0=0.001    !Y0 in phase with respect to closed orbit (vert.)
      PHTRYP0=0.001   !YP0 in phase with respect to closed orbit
                      !the hor. ellipse is calculated for y=PHTRY0
                      !and yp=PHTRYP0, the vert. with z=PTHRZ0 etc.
                      !the results are written files
                      !wave_phase_ellipse_hori.wva and
                      !wave_phase_ellipse_vert.wva
		
      IPHELLIP=0      !number of angle steps for calculation of phasespace
      		      !ellipses: PTHTRZ0,... are
      		      !taken as half-axis of phasespace ellipses
      PHDISPH=0.0E0   !horizontal displacement
      PHBETAH=0.0E0   !horizontal beta-function
      PHDISPV=0.0E0   !vertical displacement
      PHBETAV=0.0E0   !vertical beta-function
		
      $END

$OPTIK
	! coefficients of generating function	
	! trajectories are spaced on a grid with a mesh size of
	! 2*DZOPT,2*DYOPT etc ...
        ! e.g. IZ=-NZOPT,...,-4,-2,0,2,4,...,NZOPT  or IZ=...,-3,-1,1,3,...
        ! ****  its a hollow beam if NZOPT etc. are odd ****
	! the phase space is defined by a collimator
	! trajectories are written to file FILEO

	! for mash sizes of the grid i.e. e.g DZOPT=9999.
	! mash is fit do aperture according to number of mash points

        NZOPT=8     !grid of horizontal displacement
        DZOPT=9999.  !grid of horizontal displacement
        NYOPT=8     !grid of vertical displacement
        DYOPT=9999.  !grid of vertical displacement

        NZPOPT=8     !grid of horizontal slope
        DZPOPT=9999. !grid of horizontal slope
        NYPOPT=8     !grid of vertical slope
        DYPOPT=9999. !grid of vertical slope

        DLAPER=9999  ! length of collimator, if eq. 9999. then DLAPER is device
		     ! length, collimator is centered around reference orbit
        ZAPERT=0.00005   ! horizontal apertur is +/- ZAPERT
        YAPERT=0.00005  ! vertical apertur is +/- YAPERT

        IPHASPAC=0      ! aperture cut takes phase space according to
                        ! subsequent beta functions into account
        IHPHSPAC=0      ! store tracks and phase space distribution in ntuple
                        ! on histogram file
	
        BETA0ZL=10.0     ! value of horizontal low beta function
        BETA0ZH=10.0     ! value of horizontal high beta function
        BETA0YL=10.0     ! value of vertical low beta function
        BETA0YH=10.0     ! value of vertical high beta function

 	OPSTARTX=9999.	! point in starting plane for the tracking
			! the point (OPSTARTX,OPSTARTY,OPSTARTZ)
			! defines together with the vector (OPNX,OPNY,OPNZ)
			! the entrance plane of the device
			! OPSTARTX=9999. ->
			!(OPSTARTX,...Y,...Z)=(XSTART,YSTART,ZSTART)
	OPSTARTY=0.0	
	OPSTARTZ=0.0

	OPNX=9999.	! normal vector of starting plane
		! starting plane is normal to reference orbit
		! OPNX=9999. -> (OPNX,OPNY,OPNZ)=(VXIN,VYIN,VZIN)
	OPNY=0.0
	OPNZ=0.0

	OPENDX=9999.	! x of point in exit plane of device
                        ! (9999. -> OPENDX=XF0, OPENDY=YF0, OPENDZ=ZF0)
	OPENDY=0.0       ! y of point in exit plane of device
	OPENDZ=0.0       ! z of point in exit plane of device

	OPNFX=9999. ! normal vector of end plane
		    ! OPNFX=+9999. means vector is calculated
                    ! from reference orbit where it reaches (OPENDX)
	OPNFY=0.0
	OPNFZ=0.0

	DRANDO=0. ! start values of trajectories are modified by adding
		   ! random numbers in the range of DRANDO * mesh-size
	DSCALE=1.  ! scaling factor for linear equation system

	ISNORDER=0 ! 0/1 to increase precision of tracking a little bit
	           ! and slow down the program

	I2DIM=0	   ! to restrict problem to orbit plane; y,y' are taken
		   ! from matrix of drift space
	$END

 $TRANPON
		! reads in a set of trajectories from file FILEO

        NTRAJ=-9999 !use only mtraj trajectories for fitting
                    ! -9999: use all trajectories
                    ! -1: use as much trajectories as number of coeffs. to fit

	ISELECT=51 ! if set to ISELECT=N, each Nth of the tracks is printed

	IKOEFF=1 ! IKOEFF.NE.0 -> coefficients are printed

	IHALBA=0 ! to get equivalent HALBACH device (I2DIM must be 0)

	NPERTRA=78  ! number of periods of equivalent HALBACH device

	IQUAD=1  ! calculate quadrupole matrix

	IA1000=0 ! IA1000.NE.0 means A1000 is not fittet
	IA0100=0 ! IA0100.NE.0 means A0100 is not fittet
	IA0010=0 ! IA0010.NE.0 means A0010 is not fittet
	IA0001=0 ! IA0001.NE.0 means A0001 is not fittet

	IA11A20=0 ! IA11A20.NE.0 means set to A1100=1 and A2000=0,
                  ! coefficients are not fitted

	IWLSHOR=0 ! IWLSHOR.NE.0 means that in the horizontal plane only
		  ! the first and second order are fitted

	ISYM=0	  ! ISYM.NE.0 means symmetry is assumed with respect to the
		  ! orbit plane

	DRAUSCHX=0.  ! absolute amplitudes of the noise superimposed on the
		   	! final coordinates and slopes (standard deviation)
	DRAUSCHY=0.  ! XF(1:2,I)=XF(1:2,I)+XRAN(1:2)*DRAUSCHX
		     ! XF(3:4,I)=XF(3:4,I)+XRAN(3:4)*DRAUSCHY
		     ! XRAN is normal random number
		     ! (test purposes, to simulate noise in tracking routine)
	STRAILEN=5.8 ! full length of straigth section

	$END

 $COLLIN
	 ! calculations (just two rectangular pinholes)
	 ! this collimator selects the sources taken into account
	 ! Once having defined the sources, the collimator is ignored
	 !
	 ! The aperture given by APERX,...,APERHIG, is taken into
	 ! account during the spectrum calculations. All
	 ! contributions to the photon flux at a given observation point
	 ! are ignored if a straight line from the electron to the
	 ! observer does not pass the aperture

	CX1=9999.	! (CX1,CY1,CZ1) is center of first pinhole [m,m,m]
                        ! 9999. means according to PINCEN(1) or OBSV(1,1)
	CY1=9999.		! 9999. means according to PINCEN(2) or OBSV(2,1)
	CZ1=9999.		! 9999. means according to PINCEN(2) or OBSV(3,1)
	WID1=9999.	! width of first pinhole [m]
			! 9999. WID1=PINW+4.*PINW/MPINZ
	HIG1=9999.	! height of first pinhole [m]
			! 9999. HIG1=PINH+4.*PINW/MPINY	

	CX2=9999.       ! datas of second pinhole
                        ! 9999. means according to PINCEN(1) or OBSV(1,1)
	CY2=9999.
	CZ2=9999.
	WID2=9999.	! 9999. WID2=PINW+4.*PINW/MPINZ
	HIG2=9999.	! 9999. HIG2=PINH+4.*PINW/MPINY

	WGWINFC=45	! defines source points; those parts of the trajectory
			! are taken into account for which the radiation cone of
			! opening angle +/- WGWINFG/GAMMA passes the collimator
			! 9999. means WGWINFC is calculated by SR SETWGWIN

	WBL0CUT=0.0	! cut on magnetic field; source starts at
			! B > (WBL0CUT*WBL0HYS)
			! source ends at B < WBL0CUT

	WBL0HYS=1.0	! hysteresis for cut on magnetic field
			! at beginning of source WBL0CUT-->WBL0CUT/WBL0HYS
			! at end of the source WBL0CUT-->WBL0CUT*WBL0HYS

	IBL0CUT=0	! for IBL0CUT greater zero source is split when the
			! sign of the vertical magnetic field changes
			! IBL0CUT=-1 means source points are accepted
			! even for zero field
			! IBL0CUT=-2 means whole trajectory is single source

	ISOUREXT=0	! program extends source by ISOUREXT points
			! to check if neighbouring sources overlap and
			! should be treated as coherent source
	                ! ISOUREXT.LT.0 means to ignored occured errors
	                ! due to overlapping sources


	! The following aperture works only for old version (ISPECMOD.GT.1)
	APERX=10.	! x-position of aperture
	APERY=0.	! y-position of aperture
	APERZ=0.0	! z-position of aperture

	APERWID=1.0	! full width of aperture
	APERHIG=1.0	! full hight of aperture

	$END

 $SPECTN
		! intensity is calculated from amplitude projected on this
		! vector
		
	VPOLA(1)=(0.,0.)	! linear horizontal     [(0,0),(0, 0),(-1,0)]
	VPOLA(2)=(0.0,0.0)	! right handed circular [(0,0),(0,-1),( 1,0)]
	VPOLA(3)=(-1.,0.0)	! left handed circular  [(0,0),(0,-1),(-1,0)]

	REFLEC(1)=(1.,0.)	! complex reflectivity coefficients
	REFLEC(2)=(1.,0.) 	! the field amplitude is multiplied with
	REFLEC(3)=(1.,0.) 	! these coefficients

	NPOLMX=1	! max. number of poles
			! (array dimension for, F90 only, replaces NDPOLP)

	XWALLI=0.	! begin of beamline for power density calculations
	XWALLE=15.	! end of beamline for power density calculations
	WALL(1)=+0.05	! z-positions of beamline walls 	
	WALL(2)=-0.05	! (WALL(1) .GE. WALL(2))

	XABSORB=9999.	! x-position of absorber normal to beamline
			! =9999. means XABSORB=XWALLE
	ZABSORB(1)=2.   ! upper edge (z) of absorber
			! =9999. means ZABSORB(1)=WALL(1)
	ZABSORB(2)=-2.   ! lower lower edge (z) of absorber
			! =9999. means ZABSORB(2)=WALL(2)

	NPWALL=1000	! number of points on beam line wall for plots

	POWBCUT=0.025	! cut on magnetic field to find poles
			! if B < POWBCUT the corresponding part of the
			! trajectory is ignored
			! cut should not be too small to avoid problems
			! in subroutine BEAMPOW	
			! maybe the product MYINUM * POWCUT is a criterion
                        ! POWCUT*MYINUM .GE. 25
	$END

 $WFOLDN


			! natural energy spread sigma_E  =7.E-4

			! natural emittance 	epsilon_n=6.1E-9

			     ! high beta (2.10.2009):

				! 		beta_z   =14.
				!		sigma_z  =0.000292232783924
				!		sigma_zp =0.0000208737702803

				!		SIG_Z_10m=

				! (1 % coupl.)	beta_y  =3.4
				!		sigma_y =0.0000144013888219
				!		sigma_yp=0.00000423570259468

				!		SIG_Y_10m=

			     ! low beta: ??

				! 		beta_z   =0.94
				!		sigma_z  =7.5723E-5
				!		sigma_zp =8.0557E-5

				!		SIG_Z_10m=8.0912E-4

				! (3 % coupl.)	beta_y  =2.1
				!		sigma_y =1.9604E-5
				!		sigma_yp=9.3350E-6

				!		SIG_Y_10m=9.5387E-05

	BSIGZ(1)=0.000292233		! horizontal beam size [m]
	BSIGZP(1)= 2.08738E-05		! horizontal beam divergency [rad]
				! if not zero WSIGZ-values are overwritten!!
	BSIGY(1)=1.44014E-05		! vertical beam size [m]
	BSIGYP(1)= 4.2357E-06		! vertical beam divergency [rad]
				! if not zero WSIGY-values are overwritten!!

        WSIGZ(1)=369.4E-6   	! sigmas of Gaussians for folding
				! if ISIGUSR is set
				! values are overwritten if BSIGZ or BSIGZP
				! not zero according to
				! WSIGZ=SQRT(BSIGZ**2+(PINCEN(1)*BSIGZP)**2)

	WSIGY(1)=84.E-6		! the same for the verticale direction
				! values are overwritten if BSIGY or BSIGYP
				! not zero according to
				! WSIGY=SQRT(BSIGY**2+(PINCEN(1)*BSIGYP)**2)

				! *** IF VALUES ZERO FOR FURTHER SOURCES,
				! *** VALUES A TAKEN FROM FIRST SOURCE.

	DGSIGZ(1)=3.		! number of sigmas taken into account for folding
	DGSIGY(1)=3.

	NGFOURZ=5	! the Gaussians are approximated by Fourier expansion
	NGFOURY=7	! these parameter give the number of used coefficients
			! (OBSOLETE, only for IFOLD=-1 OR IFOLD=-2)

	ISIGSTO=1	! sigmas for folding of STOKES vectors are taken
			! form source point ISIGSTO
	                ! ISIGSTO=0 means ISIGSTO=1

	SIGRC=1.	! empirical correction factor for SIGR
			! SIGR=SQRT(2*LAMBDA*L)/2/PI*SIGRC
			! needed for brilliance estimations
			! Walker agrees with WAVE flux, but brilliance is
			! twice that of WAVE
			!
			! Kim: SIGRC=1/2/SQRT(2)
			! SIGRC=0.353553, i.e. Faktor of 8 in brilliance,
			! for zero emittance

	SIGRPC=1.	! empirical correction factor SIGRP
			! SIGRP=SQRT(LAMBDA/2/L)*SIGRPC
			! needed for brilliance estimations
			! Kim: SIGRC=SQRT(2)
			! SIGRPC=1.414D0
			! Kim: SIGRC=SQRT(2)
			! SIGRC=1.4142136, i.e. Faktor of 2 in flux,
			! for zero emittance, which corresponds to the real
			! maximum of the flux, not to that, where the
			! brilliance has its maximum


	ESPREAD= 0!0.0007	! rel. energy spread of the beam (for energy folding)
	NSIGE=3		! number of sigmas for energy folding

	$END

 $BUNCHN

 !*** Still experimental!! Check results carefully ***!

                        ! The seed for the random number generator is
                        ! IAMPSEED in namelist AMPLIN

        NBUNCH=1 	! Number of bunches
	
 	NEINBUNCH=1    ! NEINBUNCH particles are treated coherently
			! all subbunches are treated incoherently

        ILINTRA=0       ! >0: read linear transfer matrices from file
			! wave_lintra.dat
              		! <0: write linear transfer matrices to file
			! wave_lintra.dat
			! Note: This matrix transforms from the
                        ! beginning of the source (not necessaryly XSTART) to
			! XLINTRA, NOT to the end
			! ISPEC and IBUNCH must not be zero
			! The matrix is calculated from BETAH, BETAPH,
                        ! BETAV, and BETAPV, which must correspond to XLINTRA
			! BSIGZ, BSIGZP, BSIGY, and BSIGYP must
			! be consistant with the beta-functions at XLINTRA
	XLINTRA=-9999.  ! x [m], where the alphah and alphav are zero, i.e.
	                ! minima or maxima of the beta-functions.
			! -9999. means source center
			! XLINTRA must lay within the source

        BUNCHLEN=1e-20  ! Length [m] of a  bunch.
	                    ! The phase of the field amplitude of each particle
			    ! is affected by BUNCHLEN.
			    ! =0: Also in this case the phase of the field
			    !     is randomized for each bunch
			    ! <0: No global phase randomization for bunches
			    !*** Since there is a variaty of
                            ! compinations of IAMPLI, IMAMPLI, IBUNCH, IUBUNCH
			    ! etc., there might be an unexpected behaviour.
			    ! Please, be careful and watch the effects
			    ! on the field amplitude and the flux-densities

	IUBUNCH=3	! to calculate phase space distribution of electrons
                        ! *** The principle trajectory from XSTART
			! etc. is taken as the center of the phase-space,
			! i.e. the coordinates and velocity are added to the
			! generated ones.
			!
			! 0: Gaussian distribution according to BSIGZ, BSIGY
			!    etc. in namelist WFOLDN
			!
			! 1: Gaussian distribution according to
			!    ESP0H, BETAH, BETAPH, PHASEH, and
			!    ESP0V, BETAV, BETAPV, PHASEV in namelist DEPOLA,
			!    which refer here to the beginning of the source.
			!    The might be different, depending e.g. on IAMPLI,
			!    so, please, check the source in wave.out
			!    and adjust the beta functions etc. accordingly.
			!    IFOLD must be zero, IBUNCH must be one.
			!
			! -1: user routine UBUNCH(x,y,z,yp,zp,gamma,dt),
			!     where x referes to the center of the bunch
			!
			! 2: routine BUNCH(dt) for longitudinale
			!    distribution according to Saldin,
			!    NIM A 539 (2005) 499-526
			!    with parameters BUNCHP0, BUNCHR56, NBUNCHHARM
 			!    and AMPFREQ in namelist AMPLIN
			!
			! 3: read phasespace distribution
			!    gamma,xbunch,x,y,z,dpy/p,dpz/p from
			!    file wave_phasespace.dat  (LUN=21)
                        !
                        ! 4: longitudinale distribution within bunch is read in
                        !    terms of FOURIER-coefficients from file
                        !    fourier-bunch.dat
                        !
                        !    Format:
                        !    Lines starting with * in first column or empty
                        !    lines are comments
                        !    other lines give coefficients c1...cn for harmonics
                        !    first nbunchharm coefficients are used
			
	BUNCHP0=250.E-6 ![GeV]
        BUNCHR56=30.E-6 !R56 [m]
	NBUNCHHARM=1	!number of harmonics of microbunching (IUBUNCH=2)

        BUNCHCHARGE=1.60218E-19   !charge per bunch [C]
	                !-9999.: BUNCHCHARGE is 1.60218E-19 * NEINBUNCH

	IBUNPHASE=0	! Treatment of overall phase of single electron in
			! a bunch.
                        ! 1: For each photon energy the field is  phase-shifted
                        !    such, that the imaginary part of the amplitude Az
                        !    vanishes for observation point IOBUNCH.
                        !    THIS IS A FULLY COHERENT BEAM (within each bunch)
	
        IOBUNCH=-9999   ! number of reference observation point for IBUNPHASE=1
                        ! 0: IOBUNCH=ICBRILL
                        ! -9999: IOBUNCH is taken, where flux-density is highest
	
        IHBUNCH=1       ! to get N-tuple of beam electrons
        IWBUNCH=1       ! write distribution of iwbunch electrons to file
                        ! wave_phasespace_bunch.dat (LUN=22)
			! (gamma,xbunch,x,y,z,dpy/p,dpz/p)

  	$END

 $PINHOLE
			! or single observation points are defined here

	PINCEN(1)=40  ! x-center of pinhole [m]
	PINCEN(2)=0	!y-center of pinhole [m]
			!9999. means centered according to IPBRILL, such
			!that corner or center is on-axis
			!-9999. means centered according to
			!YSTART+VYIN/VXIN*(PINCEN(1)-XSTART)
			!-9000. means estimate position by averaging
			! y(x)+vy(x)/vx(x)*(x-pincen(1))
			
	PINCEN(3)=0 !z-center of pinhole [m]
			!9999. means centered according to IPBRILL, such
			!that corner or center is on-axis
			!-9999. means centered according to
			!ZSTART+VZIN/VXIN*(PINCEN(1)-XSTART)
			!-9000. means estimate position by averaging
			! z(x)+vz(x)/vx(x)*(x-pincen(1))

        IPBRILL=0	! observation point inside pinhole for brilliance calculations
			! =0 center of pinhole
			! =1 lower left corner
			! =2 lower right corner
			! =3 upper right corner
			! =4 upper left corner
	                ! if no pinhole specified first (IPBRILL=0)
	                ! or observation point IPBRILL is taken

        MPINZ=40	! number of horizontal grid points, if OBSVDZ is zero,
			! otherwize calculated from PINW and OBSVDZ
        MPINY=40	! number of vertical grid points, if OBSVDY is zero,
			! otherwize calculated from PINH and OBSVDY

			! for undulator radiation it might be useful to use
			! cylindrical grid for observation points.
			! If MPINR is not zero, this option is assumed
        MPINR=0	        ! number of radial grid points, if OBSVDR is zero,
			! otherwize calculated from PINRAD and OBSVDR
			! if 9999, MPINR is set to max(MPINZ,MPINY)*sqrt(2)
			
			
        MPINPHI=16	! number of azimuthal grid points, if OBSVDPHI is zero

	MEDGEZ=1	! outer edge outside of pinhole to avoid edge effects
	MEDGEY=1	! must be at least 1

	MMEDGEZ=0	! inner edge outside of pinhole to avoid edge effects
	MMEDGEY=0	! may be 0

	OBSVDZ=0.	! horizontal mesh width in pinhole
			! (is calculated from PINW and MPINZ if zero)
	OBSVDY=0.	! vertical mesh width in pinhole
			! (is calculated from PINH and MPINY if zero)

        PINW=0.24	! width of pinhole [m]
			! 9999. means automatic calculation if flag
			! IUNDULATOR is not zero
	PINWSC=1.       ! to scale PINW			
	
        PINH=0.04	! height of pinhole [m]
			! 9999. means automatic calculation if flag
			! IUNDULATOR is not zero
	PINHSC=1.       ! to scale PINH	
	
	PINR=0.1	! radius of circular pinhole [m]
			! if PINR=-9999., PINR is set to max(PINW/2.,PINH/2.)
			! if PINR=9999., PINR is set to sqrt(PINW*PINH/PI)
			
	PINRAD=9999.	! radius of circular pinhole for routine SOUINTRPHI [m]
			! triggered by MPINR.NE.0
			! if 0., PINRAD is set to PINR
			! if 9999., PINRAD is set to
			! sqrt(obsvy(nobsv)**2+obsvz(nobsv)**2)

	OBSVDR=0.	! radial mesh width in pinhole
			! (is calculated from PINRAD and MPINR if zero)
			! OBSVDR=9999. means OBSVDR=min(OBSVDZ,OBSVDY)

	OBSVDPHI=0.	! angle steps [degree]
			! (is calculated from MPINR if zero)

        IQUADPHI=0	! if not zero, phi is limited to 90 degree, i.e.
			! first quadrant of pinhole, and 4-fold symmetry is
			! assumed
			
	IRFILOB=0	! =1 to read list of observation points
			! from file FILEOB (IPIN must not be set)

	OBS1X=40	! coordinates of single observation point
			! -9999. means value from PINCEN(1)
	OBS1Y=0		! if IPIN and IRFILOB are not set (normal 0.0064702725814005, anderer 0.00542202, mittlerer 0.00601205)

			!-9999. means centered according to
			!YSTART+VYIN/VXIN*(PINCEN(1)-XSTART)
	OBS1Z=0		! [m,m,m] (normal 0, anderer -0.000324038, mittlerer -0.000153918)
			!-9999. means centered according to
			!ZSTART+VZIN/VXIN*(PINCEN(1)-XSTART)

	$END

 $FREQN

        FREQLOW=5000	!lowest photon energy for spectrum calculations
			! -9999. means automatic calculation if flag
			! IUNDULATOR is not zero (estimation might fail,
			! if mag. field is not strictly period)
        FREQHIG=100000	!highest photon energy for spectrum calculations
			! -9999. means automatic calculation if flag
			! IUNDULATOR is not zero (estimation might fail,
			! if mag. field is not strictly period)
        NINTFREQ=20 	!number of photon energies for IFREQ2P>2 (namelist
			!CONTRL)
        FRSCALE=1.	!scaling factor for window [FREQLOW,FREQHIG]
			!i.e. center and width are scaled to get higher
			!harmonics
			!-1: FREQLOW, FREQHIG, and NINTFREQ are scaled
        IFILTER=0       !absorbing filter is applied to spectrum
                        !absorption coefficients on file FILEABS
			!IFILTER = 1: F(X)=AA*X**BB interpolation of coef.
			!IFILTER > 1: linear interpolation of coef.
                        !IFILTER < 0 means files of list FILEAM are merged
			!IFILTER = -1: F(X)=AA*X**BB interpolation of coef.
			!IFILTER < -1: linear interpolation of coef.
                        !by SR ABSCOEF_MERGE and written to file FILEAMO
        IFILMUL=0       !IFILMUL = N:  N absorbing filters are applied to
                        !spectrum. Filter thicknesses and filenames
                        !of coefficient files are read from FILEAM
        IEFFI=0         !detector efficiency filter is applied to spectrum
                        !factors are read from file FILEFF
			!IEFFI > 0: spline interpolation of yield function
			!IEFFI = -1: F(X)=AA*X**BB interpolation
			!IEFFI < -1: linear interpolation
	IHFIL=0		!Ntuples of absorption coefficients
  	SPECCUT=0.	!if the photon energy exceeds SPECCUT times the critical
			!energy belonging to the maximal field strength of the
			!source point, the flux is set to zero in SR SOUADD
			!SPECCUT=0. means option is ignored.
	ABSTHI=0.002  	!thickness of absorber [m]
	AREAM2=628.E-6 	!area of probe [m**2] for program DESYNC (flag IDESYNC)
	$END

 $WBTABN
			! along straight line parallel to the x-axis
			! of the device or along trajectory to file FILEWBT
			!
			! File format:
			! 1. line: Run number and CODE
			! 2. line: Scaling factors vor X and BY
			! 3. line: Number of following data lines
			! Data lines: x By y z 1.Int(By) 2.Int(By) Int(
			!   1. Col.: x
			!   2. Col.: By
			!   3. Col.: y
			!   4. Col.: z
			!   5. Col.: first integral of By, i.e. Int(By,dx)
			!   6. Col.: second integral of By,
			!            i.e Int(Int(By,dx),dx)
			!   7. Col.: Int(dBy/dz,dx)
			!   8. Col.: Int(d2By/dz**2,dx)
			!   9. Col.: Int(d2Bz/dz**2,dx)
			!  10. Col.: Int(d2By/dy**2,dx)
			!  11. Col.: Int(d2By/dy**2,dx)
			!  12. Col.: Int(Int(d2By/dz**2,dx),dx)
			!  13. Col.: Int(Int(d2Bz/dz**2,dx),dx)
			!  14. Col.: Int(Int(d2By/dy**2,dx),dx)
			!  15. Col.: Int(Int(d2By/dy**2,dx),dx)
			!  16. Col.: Int(Ay,dx)
			!  17. Col.: Int(Az,dx)

	BTABS=9999.	! x of first point (9999. means XSTART)
	BTABE=9999.	! x of last point (9999. MEANS XSTOP)
	BTABY=0.0	! y of first point
	BTABZ=0.0	! z of first point

	NPWBTAB=1001	! number of points
	                ! (the trajectory is recalculated with this number)
			! 9999 means number of points of main  trajectory taken

	BTABEPS=0.0001	! epsilon for numerical differentiations
	$END

 $RECN

        BCRAN=0.0	! sigma of rel. random noise on BC(IMAG)
                        ! BCRAN.lt.0 means 1.+BCRAN is scaling factor without
        		! random noise (see also NURANMOD)
        BCRANSIG=1000.0	! allowed max. for BCRAN (in multiple of rms-value)
			! if generated error exceeds BCRANSIG*BCRAN it's
			! generated once again
	IRECSEED=1	! seed for generation of random errors
        K90270=0	! K90270.ne.0 means BCRAN acts only on theta=90,270
			! (only for NURANMOD.EQ.0)
        BCSTART=9999.	! begin of random error region (9999. means no limit)
			! [mm]
        BCEND=9999.	! end of random error region (9999. means no limit)
			! [mm]
        WINREC=1.0      ! Window for calculation of magnetic field
                        ! of REC-structure (SR REC_BFELD) [m]
        RANGREC=1.0     ! Tracking starts and stops at distance RANGREC
                        ! from beginning and end of structure [m]
                        ! (only if XSTART, XSTOP = 9999.)
        SCALADD=0.0      ! to scale strength of additional magnets on FILEREC
        SCALKL=0.0       ! to scale strength of all but additional magnets

        IPLREC=-1        ! >0 on-line plotting of REC-structure including
			! plotfile
			! *** For statically linked versions of WAVE, the
			! program might crash due to incompatible libc.
			! Workaround: IPLREC=-1 and view postscript file
			! rec_plotm.ps
                        !  0 no plotting
                        ! <0 plotfile of REC-structure
	RPLXMN=9999.	! plotting range [mm]
	RPLXMX=9999.	! 9999. means defaults used,
	!RPLXMN=-100.	! plotting range [mm]
	!RPLXMX=100.	! 9999. means defaults used,
	!RPLXMN=-2100.	! plotting range [mm]
	!RPLXMX=-2020.	! 9999. means defaults used,
	RPLYMN=9999.	! minima and maxima
	RPLYMX=9999.	! (or XSTART, XSTOP if -9999. in x)
	RPLZMN=9999.
	RPLZMX=9999.

        RECGAP=7.5      ! half gap [mm]
        USHIFT= 0.0      ! shift parameter [mm]

	DSHIFT=0.0      ! additional row shift [mm]

	IRECMODU=0	! call to special modulator routine

        IHTAPER=0	! to apply horizontal taper function to pos. of mags.
        		! function is given as two columns table in file
        		! FILEFTH
			! Format:
			! 1. comment
			! 2. x-scale-factor, y-scaling-factor
			! 3. data lines

        IVTAPER=0	! to apply vertical taper function to pos. of mags.
        		! function is given as two columns table in file
        		! FILEFTV	
			! Format:
			! 1. comment
			! 2. x-scale-factor, y-scaling-factor
			! 3. data lines

        IRECU=0         ! number of additional simple undulator
	NURANMOD=1	! modus for field error generation:
			! 0: BCRAN is applied as explained above, no special
			!    treatment of additional undulators
			! 1: BCRAN is applied for additional undulators
			!    in a -B/2,+B,-B/2 scheme
			! 2: BCRAN is applied for additional undulators
			!    in a +B,-B scheme
			! 3: BCRAN is applied for additional undulators,
			!    for each pole errors are generated,
			!    kick is compensated by endpoles
			!    (planar devices only, so far)
			! 4: same as 3, but in addition offset is
			!    compansated by first endpole

        KRECPER(1)=117    ! number of periods
        URECLX(1)=4.25  ! length of magnets [mm]
        URECLY(1)=40.   ! height of magnets [mm]
        URECLZ(1)=40.   ! width of magnets [mm]
        URECGAP(1)=2.  ! half gap of undulator [mm]
	UTAPER(1)=0.0	! taper (dy/dx of half gap)
        URECCX(1)=0.    ! center in x of undulator [mm]
        URECCZ(1)=0.    ! center in z of undulator [mm]
        URECBC(1)=1.22    ! field strength of magnets [T]
	UBANGERR(1)=0.0	! angle error of magnets [degree]
	USIGOFFY(1)=0.0	! allowed offset for accumulated angle error
			! if SUM(angle-errors) > UBANGERR the center
			! of the Gaussian errors will be shifted such
			! that the trajektory comes back to the orbit plane
			! set to 1.D30 if zero

        IUHELI(1)=0     ! helical undulator
                        ! positive value means S3 mode
                        ! negative value means S2 mode
        URSPLIT(1)=0.0  ! horizontal distance of rows for helical undulator [mm]
        URSHIFT(1)=10.  ! rowshift for helical undulator [mm]
			! lower-left (+URSHIFT) and upper-right (-URSHIFT)
			! rows are shifted
        URSHADD(1)=50.  ! additional shift for lower rows [mm]

        IKRESTOR=0      ! <0 means magnet strukture is stored on
                        ! rec.store
                        ! >0 means magnet strukture is read form
                        ! rec.restore
        $END

 $MODUN

        SCALMOD=1.      ! scaling factor for modulator field
        SCALRAD=1.      ! scaling factor for radii of magnets
	SCALTHE=1.      ! scaling factor for theta of magnets

	NMAGMOD=16	! number of modulator magnets
	NSLICE=51	! number of slices per magnet

	RADIMOD(1) =6.3	! radius of magnet [mm]
	RADIMOD(2) =6.3	! radius of magnet [mm]
	RADIMOD(3) =6.3	! radius of magnet [mm]
	RADIMOD(4) =6.3	! radius of magnet [mm]
	RADIMOD(5) =11.	! radius of magnet [mm]
	RADIMOD(6) =11.	! radius of magnet [mm]
	RADIMOD(7) =11.	! radius of magnet [mm]
	RADIMOD(8) =11.	! radius of magnet [mm]
	RADIMOD(9) =11.	! radius of magnet [mm]
	RADIMOD(10)=11.	! radius of magnet [mm]
	RADIMOD(11)=11.	! radius of magnet [mm]
	RADIMOD(12)=11.	! radius of magnet [mm]
	RADIMOD(13)=6.3	! radius of magnet [mm]
	RADIMOD(14)=6.3	! radius of magnet [mm]
	RADIMOD(15)=6.3	! radius of magnet [mm]
	RADIMOD(16)=6.3	! radius of magnet [mm]

	ZLENMOD(1)=90.	! length in z of magnet [mm]
	ZLENMOD(2)=90.	! length in z of magnet [mm]
	ZLENMOD(3)=90.	! length in z of magnet [mm]
	ZLENMOD(4)=90.	! length in z of magnet [mm]
	ZLENMOD(5)=90.	! length in z of magnet [mm]
	ZLENMOD(6)=90.	! length in z of magnet [mm]
	ZLENMOD(7)=90.	! length in z of magnet [mm]
	ZLENMOD(8)=90.	! length in z of magnet [mm]
	ZLENMOD(9)=90.	! length in z of magnet [mm]
	ZLENMOD(10)=90.	! length in z of magnet [mm]
	ZLENMOD(11)=90.	! length in z of magnet [mm]
	ZLENMOD(12)=90.	! length in z of magnet [mm]
	ZLENMOD(13)=90.	! length in z of magnet [mm]
	ZLENMOD(14)=90.	! length in z of magnet [mm]
	ZLENMOD(15)=90.	! length in z of magnet [mm]
	ZLENMOD(16)=90.	! length in z of magnet [mm]

	CENMODX(1) =-2086.   ! x of magnet center [mm]
	CENMODY(1) =+30.00	    ! y of magnet center [mm]
	CENMODX(2) =-2086.   ! x of magnet center [mm]
	CENMODY(2) =-30.00	    ! y of magnet center [mm]
	CENMODX(3) =-2046.   ! x of magnet center [mm]
	CENMODY(3) =+30.00	    ! y of magnet center [mm]
	CENMODX(4) =-2046.   ! x of magnet center [mm]
	CENMODY(4) =-30.00	    ! y of magnet center [mm]

	CENMODX(5) =-90.   ! x of magnet center [mm]
	CENMODY(5) =+30.00	    ! y of magnet center [mm]
	CENMODX(6) =-90.   ! x of magnet center [mm]
	CENMODY(6) =-30.00	    ! y of magnet center [mm]
	CENMODX(7) =-30.0   ! x of magnet center [mm]
	CENMODY(7) =+30.00	    ! y of magnet center [mm]
	CENMODX(8) =-30.0   ! x of magnet center [mm]
	CENMODY(8) =-30.00	    ! y of magnet center [mm]
	CENMODX(9) =30.0   ! x of magnet center [mm]
	CENMODY(9) =+30.00	    ! y of magnet center [mm]
	CENMODX(10) =30.0   ! x of magnet center [mm]
	CENMODY(10) =-30.00	    ! y of magnet center [mm]
	CENMODX(11) =+90.   ! x of magnet center [mm]
	CENMODY(11) =+30.00	    ! y of magnet center [mm]
	CENMODX(12)=+90.   ! x of magnet center [mm]
	CENMODY(12)=-30.00	    ! y of magnet center [mm]

	CENMODX(13) =2046.   ! x of magnet center [mm]
	CENMODY(13) =+30.00	    ! y of magnet center [mm]
	CENMODX(14) =2046.   ! x of magnet center [mm]
	CENMODY(14) =-30.00	    ! y of magnet center [mm]
	CENMODX(15) =2086.   ! x of magnet center [mm]
	CENMODY(15) =+30.00	    ! y of magnet center [mm]
	CENMODX(16) =2086.   ! x of magnet center [mm]
	CENMODY(16) =-30.00	    ! y of magnet center [mm]

	THEROT(1) =0.0	    ! rotation angle of magnet [degree]
	THEROT(2) =0.0	    ! rotation angle of magnet [degree]
	THEROT(3) =0.0	    ! rotation angle of magnet [degree]
	THEROT(4) =0.0	    ! rotation angle of magnet [degree]

        THEROT(5) =0.0     ! rotation angle of magnet [degree]
	THEROT(6) =0.0	    ! rotation angle of magnet [degree]
	THEROT(7) =0.0	    ! rotation angle of magnet [degree]
	THEROT(8) =0.0	    ! rotation angle of magnet [degree]
	THEROT(9) =0.0	    ! rotation angle of magnet [degree]
	THEROT(10)=0.0	    ! rotation angle of magnet [degree]
	THEROT(11)=0.0	    ! rotation angle of magnet [degree]
	THEROT(12)=0.0	    ! rotation angle of magnet [degree]

	THEROT(13) =0.0	    ! rotation angle of magnet [degree]
	THEROT(14) =0.0	    ! rotation angle of magnet [degree]
	THEROT(15) =0.0	    ! rotation angle of magnet [degree]
	THEROT(16) =0.0	    ! rotation angle of magnet [degree]

	BCMOD(1) =1.22878	    ! strength of magnet [T]
	BCMOD(2) =1.22878	    ! strength of magnet [T]
	BCMOD(3) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(4) =1.22877642516581265E+00	    ! strength of magnet [T]

	BCMOD(5) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(6) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(7) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(8) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(9) =1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(10)=1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(11)=1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(12)=1.22877642516581265E+00	    ! strength of magnet [T]

	BCMOD(13)=1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(14)=1.22877642516581265E+00	    ! strength of magnet [T]
	BCMOD(15)=1.22878	    ! strength of magnet [T]
	BCMOD(16)=1.22878	    ! strength of magnet [T]

	$END

 $POLYMAGN

       BSCALEPM=1.         ! Scaling factor for mag. field
       WINPM=1.0           ! Window in x for calculation of magnetic field [m]
       RANGPM=0.5          ! Tracking starts and stops at distance RANGPM
                           ! from beginning and end of structure [m]
                           ! (only if XSTART, XSTOP = 9999.)
       LUNPM=32		   ! logical unit for FILEPM

			   ! all sift values are added to those of polymag.in
       SHIFTLL=0.0	   ! shift of lower-left magnets
       SHIFTLR=0.0	   ! shift of lower-right magnets
       SHIFTUL=0.0	   ! shift of upper-left magnets
       SHIFTUR=0.0	   ! shift of upper-right magnets

       GAPPM=20.	   ! full gap [mm]; value is added to y-pos. of magnets

       FILEPM='polymag.in' ! input file for POLYMAG routines

 $END

 $BMAPN

           IBMAPX=1     ! x-component
                        ! 1 means written
                        ! 0 means not written i.e. set to -9999.
           IBMAPY=1     ! y-component
           IBMAPZ=1     ! z-component
                        !

	   IBMRADIAL=0	
			! IBMRADIAL=1:
			! X is taken as radial coordinate [m]
			! Y is taken as azimuth angle [degree]
			! IBMRADIAL=2:
			! Z is taken as radial coordinate [m]
			! Y is taken as azimuth angle [degree]
	   BMRADX0=0.0	! X/Z center of radial map
	   BMRADY0=0.0	! Y center of radial map

           XMAPMN=9999.	 ! xmin of map (9999. means XSTART taken)
           XMAPMX=9999.  ! xmax of map (9999. means XSTOP taken)
           NMAPX=-9999   ! number of data points in x
			 ! -9999 means: NMAXP=(XSTOP-XSTART)*MYINUM
                         !
           YMAPMN=-0.007 ! ymin of map
           YMAPMX=+0.007 ! ymax of map
           NMAPY=7       ! number of data points in y
                         !
           ZMAPMN=-0.03	 ! zmin of map
           ZMAPMX=+0.03  ! zmax of map
           NMAPZ=31      ! number of data points in z

	   IWBMAPEXT=0	 ! to extend fitted field map for IWBMAP = 4
	   $END

 $BAMWLSN

        MBAMWLS=0       ! mode:
                        ! 0: field map
                        ! 1: btab

        CORRMS=1.       ! scaling for side poles
        CORRMM=1.       ! scaling for main pole

        CURRL=97.6585   ! current of upstream corrector [A]
        CURRR=13.22435  ! current of downstream corrector [A]

        CORRL=1.0      ! field correction factor of upstream corrector [A]
        CORRR=1.03264  ! field correction factor of downstream corrector [A]

        XCORRL=-1.035  ! X-position of upstream steerer [m]
        XCORRR=1.735   ! X-position of downstream steerer [m]

        XLCORRL=0.0     ! transversal fundamental length [m]
        XLCORRR=0.0     ! transversal fundamental length [m]

        $END

 $BPOLY3DN

           X3DMIN=-0.02 ! Xmin of fitted region (9999. lowest x taken)
           X3DMAX=0.02 	! Xmax of fitted region (9999. largest x taken)
           Y3DMIN=-0.007 ! Ymin of fitted region (9999. lowest y taken)
           Y3DMAX=0.007 ! Ymax of fitted region (9999. largest y taken)
           Z3DMIN=0.02 ! Zmin of fitted region (9999. lowest z taken)
           Z3DMAX=0.03 ! Zmax of fitted region (9999. largest z taken)

           XYZ3DSC=100.E0 ! scaling factor for x,y, and z

           LORD3D=1     ! lowest used order of polynomial potential
           MORD3D=10     ! highest used order of polynomial potential
           NDORD3D=1    ! step of used orders of polynomial potential

           IHBPOLY3D=0  ! Ntuple of fitted field or field map of SR WBMAP

           $END

 $BPOLY2DHN

           NORD2DH=13    !harmonical order of fit

	   PERLEN2DH=0.212 !period length [m]
	   PHASE2DH=0.25 	!long. shift:
			 !X is set to X+PERIODLENGTH*X2DHSHIFT for
			 !the fitting and field calculations
			 !this is done before scaling with XYZ2DH

           X2DHMIN=9999. ! Xmin of fitted region (9999. lowest x taken)
           X2DHMAX=9999. ! Xmax of fitted region (9999. largest x taken)
           Y2DHMIN=9999. ! Ymin of fitted region (9999. lowest y taken)
           Y2DHMAX=9999. ! Ymax of fitted region (9999. largest y taken)
           Z2DHMIN=-0.02 ! Zmin of fitted region (9999. lowest z taken)
           Z2DHMAX=0.02 ! Zmax of fitted region (9999. largest z taken)
			 ! this values refere to the unshifted data!!

           XYZ2DH=100.E0  ! scaling factor for x,y, and z

           IHBPOLY2DH=0  !Ntuple of fitted field or field map of SR WBMAP

           $END

 $BPHARMN

	   NTRANS0=1	!lowest transversal order of fit
	   NTRANS=21	!highest transversal order of fit
	   NTRANSD=2	!increment of transversal order of fit	

	   NHARM0=1	!lowest longitudinal order of fit
	   NHARM=21	!highest longitudinal order of fit
	   NHARMD=2	!increment of longitudinal order of fit	
			!even orders correspond to horizontal sine-like fields??
			! VS:=-B0S/KXS(N,NXY)*COS(NXY*KYS*Y)
                        !    *SINH(KXS(N,NXY)*X)*SIN(N*KZ*Z)

           PERLENPH=0.212 !period length [m]
           PHASEPH=0. 	 !long. shift:
                         !X is set to X+PERIODLENGTH*XPHSHIFT for
                         !the fitting and field calculations

           XPHMIN=9999. ! Xmin of fitted region (9999. lowest x taken)
           XPHMAX=9999. ! Xmax of fitted region (9999. largest x taken)
           YPHMIN=9999. ! Ymin of fitted region (9999. lowest y taken)
           YPHMAX=9999. ! Ymax of fitted region (9999. largest y taken)
           ZPHMIN=-0.03 ! Zmin of fitted region (9999. lowest z taken)
           ZPHMAX=0.03 ! Zmax of fitted region (9999. largest z taken)
                         ! this values refere to the unshifted data!!

           XLENCPH=9999.  !Lambda_x of cos-like device [m]
			!x here horizontal coordinate
			!9999. means horizontal fit-range
           YLENSPH=9999.  !Lambda_y of sin-like device [m]
			!9999. means vertical fit-range

           IHBPHARM=0  !Ntuple of fitted field or field map of SR WBM

           $END

 $BGRIDN

            NTUPGRID=0	! NTUPGRID greater than zero means read field from
			! Ntuple on file FILEB0
			! NTUPGRID equal zero otherwise column format is
			! assumed for file
			! NTUPGRID lower zero creates Ntuple of read map

            MORD3DG=3	! polynomial order in potential of fit coefficients
            NBMDATX=4	! number of data points in x-direction for fit
            NBMDATY=4	! number of data points in y-direction for fit
            NBMDATZ=4	! number of data points in z-direction for fit

            $END

 $SPECDIPN

            NDIP=1	   ! number of dipoles (limited to 100)
            BXDIP(1)=0.0   ! field strength of dipoles [T]
            BYDIP(1)=1.3   ! field strength of dipoles [T]
            BZDIP(1)=0.0   ! field strength of dipoles [T]
			   ! *** only the field perpendicular to
			   ! (VXDIP,VYDIP,VZDIP) is used
            X0DIP(1)=0.0   ! x-position of source i.e. tangent point [m]
            Y0DIP(1)=0.0   ! Y-position of source [m]
            Z0DIP(1)=0.0   ! Z-position of source [m]
            VXDIP(1)=1.0   ! velocity vector of electron at source (a.u)
            VYDIP(1)=0.0   ! velocity vector of electron at source (a.u)
            VZDIP(1)=0.0   ! velocity vector of electron at source (a.u)

            APERTHICK=0.0  ! thickness of aperture pinhole [m]
            APERHANG=0.0   ! horizontal angle of aperture pinhole [rad]
            APERVANG=0.0   ! vertical angle of aperture pinhole [rad]
            ! option is only valid for small angles, i.e.
            ! cos(x) approximatly 1

            $END

 $BFORCN

	BFCENX=0.0  !x-position of volume center
	BFCENY=0.0  !y-position of volume center
	BFCENZ=0.0  !z-position of volume center

        BFLENX=1.   !Length of volume [m]
        BFLENY=1.   !height of volume [m]
        BFLENZ=1.   !width of volume

	TORQCENX=0.0 !x-position of reference point for torques
	TORQCENY=0.0 !y-position of reference point for torques
	TORQCENZ=0.0 !z-position of reference point for torques

	NBFORCX=1   !number of longitudinal intervalls
	NBFORCY=1   !number of vertical intervalls
	NBFORCZ=1   !number of intervalls in z

	$END

 $PHASEN

        PHCENX=0.0      !x of source plan center
        PHCENY=0.0      !y of source plan center
			!-9999: PHCENY=YSTART+VYIN/VXIN*(PHCENX-XSTART)
        PHCENZ=0.0      !z of source plan center
			!-9999: PHCENZ=ZSTART+VZIN/VXIN*(PHCENX-XSTART)

        PHWID=-9999. !full width of source plan
	            !-9999.: Estimated from device length and photon energy
        PHHIG=-9999. !full heigth of source plan
	            !-9999.: Estimated from device length and photon energy

        !The fields calculated for the NPHASEZ x NPHASEY
	!points. The other points given be MPHASEZ, MPHASEY
	!serve as edge for the folding procedure
        NPHASEZ=51      !number of horizontal mesh points
        NPHASEY=51      !number of vertical mesh points
        MPHASEZ=-9999      !total number of horizontal mesh points
	                !-9999: MPHASEZ according to dgsigz(1) and the
			!       sigma of the Gaussian
        MPHASEY=-9999      !total number of vertical mesh points
	                !-9999: MPHASEY according to dgsigy(1) and the
			!       sigma of the Gaussian
	
        IPHFOLD=1       !Folding of flux-density distribution according
	                !to beta functions PHBETH and PBETV, and the
			!emittances EPS0H and ESP0V of namelist DEPOLA	
			!>0: use util_function_fold_gauss(...)
			!<0: use util_function_fold_gauss_lin(...)
	PHBETH=-9999.   !Hori. beta-function at PHCENX
	                ! -9999.: Calculate via option IEMIT=1	
	PHBETV=-9999.   !vert. beta-function at PHCENX
	                ! -9999.: Calculate via option IEMIT=1	

	PHAPERZM=-1.	!neg. hor. phasespace cut (geom. optic)
	PHAPERZP=+1.	!pos. hor. phasespace cut (geom. optic)
	PHAPERZPM=-1.	!neg. hor. slope phasespace cut (geom. optic)
	PHAPERZPP=+1.	!pos. hor. slope phasespace cut (geom. optic)
	PHAPERYM=-1.	!neg. vert. phasespace cut (geom. optic)
	PHAPERYP=+1.	!pos. vert. phasespace cut (geom. optic)
	PHAPERYPM=-1.	!neg. vert. slope phasespace cut (geom. optic)
	PHAPERYPP=+1.	!pos. vert. slope phasespace cut (geom. optic)

	NPHELEM=0	!number of optical elements in beamline
			! phase space cuts PHAPER... are applied first
			! PHELEM(1:4,1:4,n) is matrix of optical
			! element n
			! PHELEM(5,1:4,n) is phase space aperture of
			! optical element n
	PHELEM(1,1,1)=1.
	PHELEM(2,2,1)=1.
	PHELEM(3,3,1)=1.
	PHELEM(4,4,1)=1.
	PHELEM(5,1,1)=1.   !low aperture in z
	PHELEM(5,2,1)=1.   !high aperture in z
	PHELEM(5,3,1)=1.   !low aperture in y
	PHELEM(5,4,1)=1.   !high aperture in y

	IHSEL=0		!to get histograms of integrated phasespace

        $END

 $AMPLIN

	IAMPSKIP=0  ! if not zero, spectrum calculation is skipped and
		    ! SR ADDAMPLI is called immediately

	IAMPTERM=0  ! if not zero program terminates after call
		    ! to SR ADDAMPLI

	IAMPCOMP=3	!component of field to adjust phase

	IMAMPLI=0   ! mode flag
		    !  1:   write amplitude array REAIMA to new file
		    !  2:   append amplitude array REAIMA to file
                    !  3:   same as 1, but in addition
		    !       write amplitude array REAIMA to files
		    !       eyre*.dat, eyim*.dat, ezre*.dat, ezim*.dat, ey2*.dat
		    !       for program PHASE of Johannes Bahrdt
		    !	    (one photon energy per file)
		    ! -1:   read amplitude array REAIMA from file,
		    !	    fill arrays for spectrum calculations, i.e.
		    !	    SPEC, STOKES ...
		    !	    sum up all spectra on file applying
		    !	    phaseshifts AMPSHIFT
		    !        *** Be careful, if the field was written
		    !       under for IBUNCH.ne.0. The flux-density and the
		    !       field might differ with respect to the
		    !       phase, especially if BUNCHLEN was lower
		    !       then zero, while writing the file
                    ! -3:   same as -1, but in addition
		    !       write amplitude array REAIMA to files for
                    !       program PHASE of Johannes Bahrdt
		    !	    (one photon energy per file)

        IAMPSUP=0       ! write resulting field amplitude to file
                        ! FILEAMPLI"_SUPER"

	AMPSHIFT(1)=0. ! From distance AMPSHIFT [m] a phaseshift for the
		       ! amplitude is calculated for each photon energy
		       ! before the amplitude is added to the spectrum.
		       ! The index referes to the spectrum on the file.
		       ! The phaseshift corresponds to the phase advance
		       ! of a photon with respect to an electron in a
		       ! drift space (phi=L/c/2g**2*w). In an undulator
		       ! field the phase advance is given by
		       ! phi=L*(1+K**2/2)/c/2g**2*w

	AMPSCALE(1)=1. ! the scaling factor AMPSCALE is applied to
		       ! amplitude before adding amplitude
		       ! the index referes to the spectrum on the file

        IAMPREP=0   ! number of superpositions of field
		    ! *** no correction for depth of field effects
                    ! (option IAMPLI<0 is recommended instead)
		
                    ! IAMPREP<0: Superposition is done according to
                    ! longitudinal density of electrons as defined by
                    ! IAMPCOH. In this case, the spectra are normlized to
                    ! AMPBUNCHCHARGE if AMPBUNCHCHARGE not zero

        IAMPCOH=0   ! mode to calculate longitudinale
		    ! distribution of electrons
                    ! the first 10000 phase shifts [nm] are
                    ! written to file wave_bunch.dat			
		    !
		    ! 0: Gaussian distribution with sigma=AMPCOHSIG
		    !
		    ! -1: user routine UBUNCH(x,y,z,yp,zp,gamma,dt),
		    !     where x referes to the center of the bunch
		    !
		    ! 2: routine BUNCH(dt,weight) according to Saldin,
		    !    NIM A 539 (2005) 499-526
		    !    with parameters BUNCHP0, BUNCHR56, NBUNCHHARM
 		    !    and AMPFREQ
		    !
		    ! 3: read phasespace distribution
		    !    x,y,z,dpx/p,dpy/p,dpz/p,weight from
		    !    file wave_phasespace.dat (LUN=21)
                    !
                    ! 4: density distribution within bunch is read in
                    !    terms of FOURIER-coefficients from file
                    !    fourier-bunch.dat (LUN=21)
                    !
                    !    Format:
                    !    Lines starting with * in first column or empty
                    !    lines are comments
                    !    other lines give coefficients c1...cn for harmonics
                    !    first NAMPBUNCHHARM are used

	IAMPINCOH=0 !    suppress incoherent background
	            !    use with care!!

        AMPCOHSIG=2.64E-07 ! sigma of Gaussian [m] for IAMPCOH=0.and.IAMPREP<0

	AMPBUNCHLEN=2.E-08 ! length [m] of the whole bunch
	AMPBUNCHCHARGE=2.E-08 ! charge [C] of the whole bunch
                              ! if zero, normalization is done according
                              ! to number of electron, i.e. -IAMPREP

	AMPBUNCHP0=250.E-6 ![GeV]
        AMPBUNCHR56=30.E-6 !R56 [m]
	NAMPBUNCHHARM=1	!number of harmonics of microbunching (IAMPCOH=2)

        AMPRAN=0.0   !rel. rms of gaussian random phaseshift error
		    !(referes to AMPFREQ)
		
	IAMPSEED=0	! seed for random numbers [1...900000]
			! -9999: Current job runnumber is used as seed
			
        AMPFREQ=-9999.     ! photonenergy [eV] to which AMPPHI referes
		    !-9999. means is taken from 1. harm. of considered device
		    !*** Be careful: Only correct for one period devices, since
		    !*** it scales with number of periods
		    !0: Is allowed and avoids check of AMPFREQ (useful for
		    !   IAMPSKIP=1),
		
        AMPR2CORR=-9999. !effective length of repeated section [m]
	              !if the repeated is long, e.g. a whole undulator,
		      !this is the lenght of the undulator without the
		      !zero field section between repeated undulators.
		      !-9999. means full length of repeated section, which
		      !       is a good approximation

        AMPPHI(1)=1. !
		    !----------------
		    !  AMPPHI.GT.0:
		    !----------------
		    ! phaseshift for superpositions in fractions of 2*pi
		    ! *** Attention: AMPPHI corresponds to phase advance
		    ! due to the length of the trajectory through the
		    ! phase-shifting device.
		    ! Hence AMPPHI + 1 is not the same as AMPPHI!!
		    !----------------
		    !  AMPPHI.LT.0:
		    !----------------
		    ! AMPPHI is detour of trajectory [m] through phase-shifting
		    ! device, i.e. total length of trajectory minus AMPSHIFT

	$END

 $ROIN

	NROI=0		!number of ROI-boundaries for spectrum calculation
			!ROI are regions between the boundaries, i.e.
			!e.g. third ROI is between ROIX(3) and ROIX(4)
			!zero values means: NROI set to 2, roi is whole source,
			!relative precision is set to one
			!negative values means equally spaced ROIs within
			!source, i.e. values of ROIX are ignored
			!IF ROIS ARE USED, THE RANGE  XSTART->XSTOP MUST
			!BE COVERED.
	ROIX(1)=0.0	!x-value of ROI-boundary
	ROIP(1)=1.	!relative precision i.e. number of integration steps
			!per unitlength is multiplied with this factor
			!within the ROI
			!zero-value is set to one
	ROIX(2)=0.0	!x-value of ROI-boundary
	ROIP(2)=1.	!relative precision i.e. number of integration steps
	ROIX(3)=0.0	!x-value of ROI-boundary
	ROIP(3)=1.	!relative precision i.e. number of integration steps
	ROIX(4)=0.0	!x-value of ROI-boundary
	ROIP(4)=1.	!relative precision i.e. number of integration steps
	ROIX(5)=0.0	!x-value of ROI-boundary
	ROIP(5)=1.	!relative precision i.e. number of integration steps
	ROIX(6)=0.0	!x-value of ROI-boundary
	$END

 $BERRORN

        !*** CHECK ERROR FIELD BY PLOTTING TO AVOID CONFUSION

        B0ERROR=1.      ! amplitude of field error
        IBERRSEED=0     ! seed for random numbers [1...900000]
	NBERRMOD=0	! mode of error treatment:
			! 1: error applies for two poles with +B,-B
			! 2: error applies for single pole with +B
			! else: error applies for three poles with -B/2,+B,-B/2

        XLENERR=0.      ! 2*pi/kx for global horizontal gradient [m]
                        ! XLERROR=0 means YLERROR=ZLERROR (no gradient)
			! *** NEGATIVE: BELLANA is used to calculate error
			! ***           field, B0ERROR is taken for B0ELLANA
			
        ZLENERR=0.017 ! 2*pi/kz of poles [m]
	
        NBERROR=-9999  ! number of poles
		       !  for NERRMOD=0 one error affects three poles,
		       !  for NERRMOD=1 one error affects two poles,
		       !  for NERRMOD=2 one error affects one pole
		       !  for NERRMOD=-1 poles from Fibonacci series,
                       !      error is B0ERROR=const
                       !  file fibonacci_used_cut.dat contains used cut
                       !  file fibonacci_available_cuts.dat contains
                       !  available cuts of series		
		       ! -9999 means number of poles are calculated from
		       ! XSTART and XSTOP	
        XCENERR=0.      ! center of error field in X [m]
        ETAFIBO=4.05177 ! eta for Fibonacci-series
        ICUTFIBO=1     ! use cut with icut .gt. ICUTOFIBO of series 	

        $END

 $PHOTONN

        IHPHOTONS=1 ! to get Ntuple with photons generated for IENELOSS=-1
	
	EECMAXG1=5.0 ! max. energy of generated photons in units of Ec
	NBING1=1000  ! number of bins for histogram of probability
	             ! distribution

        IPHMODE=0    !0: use WAVE routine to generate photons
                     !1: use HRNDM1 from CERN to generate photons
                     !<0: use WAVE routine to generate photons
		     !    addionally with transversal momentum

 $END

 $USERN

        USER(1)=0.	!USER ARRAY (1000)
	                !The first 10 values are also stored as Ntuple 223
			!or n223 for PAW or root respectively

 	$END

 $WAVES
	INULL=0
	IONE=1
        ITWO=2
        ITHREE=3
        IFOUR=4
        IFIVE=5
        ISIX=6
        ISEVEN=7
        IEIGHT=8
        ININE=9
        DWAVES=0.0E0      !DUMMY
        RWAVES=0.	 !DUMMY
        IWAVES=0	 !DUMMY
        CWAVES=(0.,0.)	 !DUMMY
	IAMPW=0
	IAMPNW=1
	IAMPNP=1
	IAMPLI11=0
	IAMPLI21=0
	IAMPLI12=0
	IAMPLI22=0
        INURAN=1
        IRBMAP=0
        IRBMAP2=0
        IWBMAPT=0
	TROTCHIC0=0.0
	TROTCHIC=0.0
        TROTMODU0=0.0
	TROTMODU=0.0
	T180=180.
	TROT=86.76
	TROTEND=90.
	TROT900=90.
	TROT90=0.0
        TROTM=0.0
	TROT1800=180.
	TROT180=0.0
	UE112SH=0.0	
	UE112SH=0.	
        SHLL=0.0
        SHLR=+1.0
        SHUL=-1.0
        SHUR=0.0
	UESHIFTLL=0.0
	UESHIFTUL=0.0
	UESHIFTLR=0.0
	UESHIFTUR=0.0
	SHIFTLLM=0.0
	SHIFTULM=0.0
	SHIFTLRM=0.0
	SHIFTURM=0.0
	UESHIFTLLM=0.0
	UESHIFTULM=0.0
	UESHIFTLRM=0.0
	UESHIFTURM=0.0
	IUE112MOD=1
	NUE112MOD=0
	IUE46=0
	IUE56=0
	IUE112=0
	IWORK1=0
	IWORK2=0
	IWORK3=0
 	IBEAMFOLD=0
	IBEAMEFOLD=0
	IAMPREPP=0
	MPINRT=0
	IBUNCHT=1
	R9999=9999.
	IPINHV=0
	IPINWV=0
	IPINRV=1
	IPIN3=0
 $end
WAVEINCONFIGENDE

# Den Text splitten und in den Hash geben
our @waveIn = split /\n/, $waveInText;

our %waveInArray = ();
my $sub = "";

foreach (@waveIn) {
  if ($_ =~ /^[\s]*([\w|\(\)]+)=[\s]*([^!]*).*$/) {
    $waveInArray{"$1"} = "$2";
  }
}

return 1;