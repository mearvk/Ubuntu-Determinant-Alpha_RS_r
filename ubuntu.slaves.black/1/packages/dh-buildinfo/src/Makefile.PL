use ExtUtils::MakeMaker;
WriteMakefile(
	NAME    => 'dh-buildinfo',
	VERSION	=> '0.10',
	AUTHOR  => 'Yann Dirson <ydirson@altern.org>',

	EXE_FILES => [ 'dh_buildinfo' ],
	MAN1PODS => {
		'dh_buildinfo' => 'blib/man1/dh_buildinfo.1',
	},
);
