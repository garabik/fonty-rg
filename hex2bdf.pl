#!/usr/bin/perl


# There are now four ways to call hex2bdf:
# 1. hex2bdf <unifont.hex >unifont.bdf
# 2. hex2bdf yes <unifont.hex >unifont-double.bdf
# 3. hex2bdf both <unifont.hex >unifont-both.bdf
# 4. hex2bdf shrink <unifont.hex >unifont-shrink.bdf

# 1. & 2. are as in the original hex2bdf.

# 3. includes both single and double width characters in a single font
# (since some applications prefer this, e.g. GNU emacs 21 work fine with
# this). It was done like that in the older GNU unifont versions.

# And 4. generates a font, which has all 16-wide characters shrunken to
# 8-wide ones (for cell-spaced font application like konsole).



$double = shift(ARGV);
if ($double =~ /^(y(es)?|t(rue)|1)/i) {
    $double = 'yes';
} elsif ($double =~ /^s(hrink)?/i) {
    $double = 'shrink';
} elsif ($double =~ /^b(oth)?/i) {
    $double = 'both';
} elsif (($double =~ /^no?/i) || ($double eq '')) {
    $double = 'no';
} else {
    warn "unknown double specifier '$double'";
    $double = 'no';
}

if ($double eq 'yes') {
  while (<>) { $glyph{$1} = $2 if /(....):([0-9A-Fa-f]{64})\n/; }
  $boxwidth = 16;
  $halffull = 'f';
        $spacing = 'c';
  $defaultchar = 0xFF0A; # FULLWIDTH ASTERISK
}
elsif ($double eq 'no') {
  while (<>) { $glyph{$1} = $2 if /(....):([0-9A-Fa-f]{32})\n/; }
  $boxwidth = 8;
  $halffull = 'h';
        $spacing = 'c';
  $defaultchar = 0xFFFD;
} elsif ($double eq 'shrink') {
  for (my $i=0; $i<256; $i++) {
                my $t = (($i&0x80)?0x8:0) | (($i&0x40)?0x8:0) |
                                    (($i&0x20)?0x4:0) | (($i&0x10)?0x4:0) |
                                                (($i&0x08)?0x2:0) | (($i&0x04)?0x2:0) |
                                                (($i&0x02)?0x1:0) | (($i&0x01)?0x1:0);
                $narrow{sprintf "%02X", $i} = sprintf "%X", $t;
  };
  while (<>) {
                        next unless /(....):([0-9A-Fa-f]{32,64})\n/;
                        my $i = $1;
      my $g = $2;
                        $g =~ s/(..)/$narrow{$&}/ge if length($g) eq 64;
                        $glyph{$i} = $g;
  }
  $boxwidth = 8;
  $halffull = '';
        $spacing = 'c';
  $defaultchar = 0xFFFD;
  $namesuffix = '.shrink';
} elsif ($double eq 'both') {
  while (<>) { $glyph{$1} = $2 if /(....):([0-9A-Fa-f]{32,64})\n/; }
  $boxwidth = 16;
  $halffull = '';
        $spacing = 'p';
        $namesuffix = '.twowidth';
  $defaultchar = 0xFF0A; # FULLWIDTH ASTERISK
};

@chars = sort keys %glyph; $[ = 1;
# dbmopen (%charname, "/usr/share/unicode/unidata/charname.db", 0);

print <<EOF;
STARTFONT 2.1
FONT
-gnu-fixed$namesuffix-medium-r-normal-$halffull-$boxwidth-160-75-75-$spacing-80-\
iso10646-1
SIZE 16 75 75
FONTBOUNDINGBOX $boxwidth 16 0 -2
STARTPROPERTIES 18
FONTNAME_REGISTRY ""
FOUNDRY "gnu"
FAMILY_NAME "fixed"
WEIGHT_NAME "medium"
SLANT "r"
SETWIDTH_NAME "normal"
ADD_STYLE_NAME "$halffull"
PIXEL_SIZE 16
POINT_SIZE 160
RESOLUTION_X 75
RESOLUTION_Y 75
SPACING "c"
AVERAGE_WIDTH 80
CHARSET_REGISTRY "iso10646"
CHARSET_ENCODING "1"
DEFAULT_CHAR $defaultchar
FONT_ASCENT 14
FONT_DESCENT 2
ENDPROPERTIES
CHARS $#chars
EOF

foreach $character (@chars)
{
        $encoding = hex($character); $glyph = $glyph{$character};
        $width = length ($glyph) > 32 ? 2 : 1;
        $dwidth = $width * 8; $swidth= $width * 500;
        $glyph =~ s/((..){$width})/\n$1/g;
        $character = "$character $charname"
            if $charname = $charname{pack("n",hex($character))};

        print "STARTCHAR U+$character
ENCODING $encoding
SWIDTH $swidth 0
DWIDTH $dwidth 0
BBX $dwidth 16 0 -2
BITMAP $glyph
ENDCHAR\n";
}

print "ENDFONT\n";

