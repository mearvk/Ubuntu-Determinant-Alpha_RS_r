REPORTER = dot

test:
	mocha \
		--require test/common \
		--reporter $(REPORTER) \
		--growl \
		test/tests.js

test-browser:
	@./node_modules/.bin/serve .

.PHONY: test
