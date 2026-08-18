use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'MeCab',
    'CC'        => 'g++',	# mecab-config --cxx
    'LD'        => 'g++',	# mecab-config --cxx
    'INC'       => '-I../src',	# mecab-config --cflags
    'LIBS'	=> '-L../src/.libs -lmecab -lstdc++',	# mecab-config --libs
    'VERSION'	=> `../mecab-config --version`,
    'OBJECT'	=> 'MeCab_wrap.o'
);
