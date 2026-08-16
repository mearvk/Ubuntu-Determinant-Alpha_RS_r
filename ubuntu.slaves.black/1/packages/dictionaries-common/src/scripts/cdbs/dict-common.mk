$(patsubst %,install/%,$(DEB_PACKAGES)) ::
	installdeb-ispell -p$(cdbs_curpkg)
	installdeb-wordlist -p$(cdbs_curpkg)
	installdeb-aspell -p$(cdbs_curpkg)
	installdeb-myspell -p$(cdbs_curpkg)
	installdeb-hunspell -p$(cdbs_curpkg)
