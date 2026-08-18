require Font::AFM;

my $test_font  = $ENV{TEST_FONT};
my $test_width = $ENV{TEST_FONT_WIDTH};

$test_font  = "Helvetica" unless defined $test_font  and length $test_font;
$test_width = 4279        unless defined $test_width and length $test_width;

eval {
   $font = Font::AFM->new($test_font);
};
if ($@) {
   if ($@ =~ /Can't find the AFM file for/) {
	print "1..0 # Skipped: Can't find required font\n";
	print "# $@";
   } else {
	print "1..1\n";
        print "# $@";
	print "not ok 1 Found font OK\n";
   }
   exit;
}
print "1..1\n";

$sw = $font->stringwidth("Gisle Aas");

if ($sw == $test_width) {
    print "ok 1 Stringwith for \"$test_font\"(font) seems to work\n";
} else {
    print "not ok 1 The stringwidth of 'Gisle Aas' should be $test_width (it was $sw)\n";
}

