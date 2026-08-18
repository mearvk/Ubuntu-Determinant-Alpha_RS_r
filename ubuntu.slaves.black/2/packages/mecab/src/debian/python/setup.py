#!/usr/bin/env python

from distutils.core import setup,Extension,os
import string

def cmd1(str):
    return os.popen(str).readlines()[0][:-1]

def cmd2(str):
    return string.split (cmd1(str))

setup(name = "mecab-python",
	version = cmd1("../mecab-config --version"),
	py_modules=["MeCab"],
	ext_modules = [
		Extension("_MeCab",
			  ["MeCab_wrap.cxx",],
			  include_dirs=['../src'], #cmd2("mecab-config --inc-dir"),
			  library_dirs=['../src/.libs'], #cmd2("mecab-config --libs-only-L"),
			  libraries=['mecab', 'stdc++']) #cmd2("mecab-config --libs-only-l")
			])
