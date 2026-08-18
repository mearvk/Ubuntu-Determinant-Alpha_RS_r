#!/usr/bin/python3
# encoding=UTF-8

# Copyright © 2011 Jakub Wilk <jwilk@debian.org>
#           © 2013-2017 Dmitry Shachnev <mitya57@debian.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import urllib.parse
import urllib.request
import re
import unittest
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.0')
from gi.repository import GLib, Gtk, WebKit2

default_time_limit = 40.0

# HTTP browser
# ============

class Timeout(Exception):
    pass

class Browser(object):

    def __init__(self, options):
        settings = WebKit2.Settings()
        settings.set_property('allow-file-access-from-file-urls', True)
        settings.set_property('enable-write-console-messages-to-stdout', True)
        self._time_limit = 0
        self._view = WebKit2.WebView.new_with_settings(settings)
        self._view.connect('notify::title', self._on_title_changed)
        self._result = None
        self._id = 0

    def _on_title_changed(self, webview, user_data):
        contents = webview.get_property('title')
        webview.run_javascript('document.title = ""')
        found = re.match(r"(?P<n_results>\d+) (?P<n_links>\d+) (?P<n_highlights>\d+)", contents)
        if found:
            self._result = found.groupdict()
            Gtk.main_quit()
            GLib.source_remove(self._id)
            self._id = 0

    def _quit(self):
        self._view.run_javascript(
            "var n_results = $('#search-results > p:first').text().match(/found (\d+) page/)[1];\n"
            "var n_links = $('#search-results a').length;\n"
            "var n_highlights = $('#search-results .highlighted').length;\n"
            "document.title = `${n_results} ${n_links} ${n_highlights}`;")
        if self._time_limit < 0:
            self._result = None
            Gtk.main_quit()
            return GLib.SOURCE_REMOVE

        self._time_limit -= 1
        return GLib.SOURCE_CONTINUE

    def wget(self, url, time_limit=default_time_limit):
        self._view.load_uri(url)
        self._time_limit = time_limit
        self._id = GLib.timeout_add_seconds(1, self._quit)
        Gtk.main()
        if self._result is None:
            raise Timeout
        return self._result


# Actual tests
# ============

def test_html(result, options):

    class TestCase(unittest.TestCase):

        if options.n_results is not None:
            def test_n_results(self):
                n_results = int(result['n_results'])
                self.assertEqual(n_results, options.n_results)

        if options.n_links is not None:
            def test_n_links(self):
                n_links = int(result['n_links'])
                self.assertEqual(n_links, options.n_links)

        if options.n_highlights is not None:
            def test_n_highlights(self):
                n_highlights = int(result['n_highlights'])
                self.assertEqual(n_highlights, options.n_highlights)

    TestCase.__name__ = 'TestCase(%r)' % options.search_term

    suite = unittest.TestLoader().loadTestsFromTestCase(TestCase)
    return unittest.TextTestRunner(verbosity=2).run(suite)

def test_directory(directory, options, time_limit=default_time_limit):
    url = urllib.parse.urljoin('file:', urllib.request.pathname2url(directory))
    url = urllib.parse.urljoin(url, 'html/search.html?q=' + urllib.parse.quote_plus(options.search_term))
    browser = Browser(options)
    result = browser.wget(url, time_limit)
    return test_html(result, options)

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--time-limit', type=float, default=default_time_limit)
    parser.add_argument('directory', metavar='DIRECTORY')
    parser.add_argument('search_term', metavar='SEARCH-TERM')
    parser.add_argument('--n-results', type=int)
    parser.add_argument('--n-links', type=int)
    parser.add_argument('--n-highlights', type=int)
    options = parser.parse_args()
    test_directory(options.directory, options=options, time_limit=options.time_limit)

if __name__ == '__main__':
    main()

# vim:ts=4 sw=4 et
