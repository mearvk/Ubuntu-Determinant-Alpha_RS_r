use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Strange',
    'ABSTRACT'  => 'Perl extension for blah blah blah',
    'AUTHOR'    => [ 'A. U. Thor, a.u.thor@a.galaxy.far.far.away' ],
    'VERSION'   => 2.1,
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'BUILD_REQUIRES'  => {
        'Module::Build::Tiny' => 0,
    },
    'TEST_REQUIRES'   => {
        'Test::Deep' => 0,
    }
);
