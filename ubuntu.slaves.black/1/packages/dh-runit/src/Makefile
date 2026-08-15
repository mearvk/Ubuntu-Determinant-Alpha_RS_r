all:
testrunner: testrunner.hs
	ghc $<
check: testrunner
	./testrunner
autopkgtest: testrunner
	AUTOPKGTEST=1 ./testrunner
.PHONY: check
