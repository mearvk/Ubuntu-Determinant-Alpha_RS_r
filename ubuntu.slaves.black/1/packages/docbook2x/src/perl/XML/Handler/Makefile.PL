use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'ABSTRACT'  => 'SGMLSpl-like event dispatcher for Perl SAX2',
    'AUTHOR'    => 'Steve Cheng <stevecheng@users.sourceforge.net>',
    'NAME'	=> 'XML::Handler::SGMLSpl',
    'VERSION_FROM' => 'SGMLSpl.pm', # finds $VERSION
);
