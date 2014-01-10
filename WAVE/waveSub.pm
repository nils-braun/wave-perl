# Verschiedene Funktionen zum Setzen von WAVE-Input Variablen

sub setStartposition() {
	my ($x, $y, $z) = @_;
	WAVE::setValue("XSTART", $x);
	WAVE::setValue("YSTART", $y);
	WAVE::setValue("ZSTART", $z);
}

sub setEndposition() {
	my ($x) = @_;
	WAVE::setValue("XEND", $x);
}

# todo klein schreiben
sub setMode() {
	my ($mode) = @_;
	if($mode == "expert") {
		WAVE::setValue("IEXPERT", 1);
		WAVE::setValue("IUNDULATOR", 0);
		WAVE::setValue("IWIGGLER", 0);
	}
	else if($mode == "undulator") {
		WAVE::setValue("IEXPERT", 1);
		WAVE::setValue("IUNDULATOR", 0);
		WAVE::setValue("IWIGGLER", 0);
	}
	else if($mode == "wiggler") {
		WAVE::setValue("IEXPERT", 1);
		WAVE::setValue("IUNDULATOR", 0);
		WAVE::setValue("IWIGGLER", 0);
	}
} 