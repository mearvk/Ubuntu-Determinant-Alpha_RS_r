# -*- coding: utf-8 -*-
import unittest
import os
import axi
import axi.indexer
import shutil
import subprocess
import tools

def smallcache(pkglist=["apt", "libept-dev", "gedit"]):
    class sc(object):
        def __init__(self, cache):
            self._pkgs = pkglist
            self._cache = cache

        def has_key(self, name):
            return name in self._pkgs

        def __len__(self):
            return len(self._pkgs)

        def __iter__(self):
            for p in self._pkgs:
                yield self._cache[p]

        def __getitem__(self, name):
            if name not in self._pkgs:
                raise KeyError("`%s' not in wrapped cache" % name)
            return self._cache[name]

    return sc

class TestIndexer(tools.AxiTestBase):
    def setUp(self):
        # Remove the text index if it exists
        if os.path.exists(axi.XAPIANDBPATH): shutil.rmtree(axi.XAPIANDBPATH)
        # Prepare a quiet indexer
        progress = axi.indexer.SilentProgress()
        self.indexer = axi.indexer.Indexer(progress, True)

    def tearDown(self):
        # Explicitly set indexer to none, otherwise in the next setUp we rmtree
        # testdb before the indexer had a chance to delete its lock
        self.indexer = None

    def testAptRebuild(self):
        self.indexer._test_wrap_apt_cache(smallcache())

        # No other indexers are running, ensure lock succeeds
        self.assert_(self.indexer.lock())

        # No index exists, so the indexer should decide it needs to run
        self.assert_(self.indexer.setupIndexing())

        # Perform a rebuild
        self.indexer.rebuild()

        # Close the indexer
        self.indexer = None

        # Ensure that we have an index
        self.assertCleanIndex()

    def testDeb822Rebuild(self):
        pkgfile = os.path.join(axi.XAPIANDBPATH, "packages")
        subprocess.check_call("apt-cache show apt libept-dev gedit > " + pkgfile, shell=True)

        # No other indexers are running, ensure lock succeeds
        self.assert_(self.indexer.lock())

        # No index exists, so the indexer should decide it needs to run
        self.assert_(self.indexer.setupIndexing())

        # Perform a rebuild
        self.indexer.rebuild([pkgfile])

        # Close the indexer
        self.indexer = None

        # Ensure that we have an index
        self.assertCleanIndex()

    def testIncrementalRebuild(self):
        # Perform the initial indexing
        progress = axi.indexer.SilentProgress()
        pre_indexer = axi.indexer.Indexer(progress, True)
        pre_indexer._test_wrap_apt_cache(smallcache(["apt", "libept-dev", "gedit"]))
        self.assert_(pre_indexer.lock())
        self.assert_(pre_indexer.setupIndexing())
        pre_indexer.rebuild()
        pre_indexer = None
        curidx = open(axi.XAPIANINDEX).read()

        # Ensure that we have an index
        self.assertCleanIndex()

        # Prepare an incremental update
        self.indexer._test_wrap_apt_cache(smallcache(["apt", "coreutils", "gedit"]))

        # No other indexers are running, ensure lock succeeds
        self.assert_(self.indexer.lock())

        # An index exists the plugin modification timestamps are the same, so
        # we need to force the indexer to run
        self.assert_(not self.indexer.setupIndexing())
        self.assert_(self.indexer.setupIndexing(force=True))

        # Perform a rebuild
        self.indexer.incrementalUpdate()

        # Close the indexer
        self.indexer = None

        # Ensure that we have an index
        self.assertCleanIndex()

        # Ensure that we did not create a new index
        self.assertEqual(open(axi.XAPIANINDEX).read(), curidx)

    def testIncrementalRebuildFromEmpty(self):
        # Prepare an incremental update
        self.indexer._test_wrap_apt_cache(smallcache())

        # No other indexers are running, ensure lock succeeds
        self.assert_(self.indexer.lock())

        # No index exists, so the indexer should decide it needs to run
        self.assert_(self.indexer.setupIndexing())

        # Perform an incremental rebuild, which should fall back on a normal
        # one
        self.indexer.incrementalUpdate()

        # Close the indexer
        self.indexer = None

        # Ensure that we have an index
        self.assertCleanIndex()

#    def test_url(self):
#        """ Environ: URL building """
#        request.bind({'HTTP_HOST':'example.com'}, None)
#        self.assertEqual('http://example.com/', request.url)
#        request.bind({'SERVER_NAME':'example.com'}, None)
#        self.assertEqual('http://example.com/', request.url)
#        request.bind({'SERVER_NAME':'example.com', 'SERVER_PORT':'81'}, None)
#        self.assertEqual('http://example.com:81/', request.url)
#        request.bind({'wsgi.url_scheme':'https', 'SERVER_NAME':'example.com'}, None)
#        self.assertEqual('https://example.com:80/', request.url)
#        request.bind({'HTTP_HOST':'example.com', 'PATH_INFO':'/path', 'QUERY_STRING':'1=b&c=d', 'SCRIPT_NAME':'/sp'}, None)
#        self.assertEqual('http://example.com/sp/path?1=b&c=d', request.url)
#
#    def test_dict_access(self):
#        """ Environ: request objects are environment dicts """
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        request.bind(e, None)
#        for k, v in e.iteritems():
#            self.assertTrue(k in request)
#            self.assertTrue(request[k] == v)
#
#    def test_header_access(self):
#        """ Environ: Request objects decode headers """
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['HTTP_SOME_HEADER'] = 'some value'
#        request.bind(e, None)
#        request['HTTP_SOME_OTHER_HEADER'] = 'some other value'
#        self.assertTrue('Some-Header' in request.header)
#        self.assertTrue(request.header['Some-Header'] == 'some value')
#        self.assertTrue(request.header['Some-Other-Header'] == 'some other value')
#
#
#    def test_cookie(self):
#        """ Environ: COOKIES """ 
#        t = dict()
#        t['a=a'] = {'a': 'a'}
#        t['a=a; b=b'] = {'a': 'a', 'b':'b'}
#        t['a=a; a=b'] = {'a': 'b'}
#        for k, v in t.iteritems():
#            request.bind({'HTTP_COOKIE': k}, None)
#            self.assertEqual(v, request.COOKIES)
#
#    def test_get(self):
#        """ Environ: GET data """ 
#        e = {}
#        e['QUERY_STRING'] = 'a=a&a=1&b=b&c=c'
#        request.bind(e, None)
#        self.assertTrue('a' in request.GET)
#        self.assertTrue('b' in request.GET)
#        self.assertEqual(['a','1'], request.GET.getall('a'))
#        self.assertEqual(['b'], request.GET.getall('b'))
#        self.assertEqual('1', request.GET['a'])
#        self.assertEqual('b', request.GET['b'])
#        
#    def test_post(self):
#        """ Environ: POST data """ 
#        sq = u'a=a&a=1&b=b&c=c'.encode('utf8')
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write(sq)
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = str(len(sq))
#        e['REQUEST_METHOD'] = "POST"
#        request.bind(e, None)
#        self.assertTrue('a' in request.POST)
#        self.assertTrue('b' in request.POST)
#        self.assertEqual(['a','1'], request.POST.getall('a'))
#        self.assertEqual(['b'], request.POST.getall('b'))
#        self.assertEqual('1', request.POST['a'])
#        self.assertEqual('b', request.POST['b'])
#
#    def test_params(self):
#        """ Environ: GET and POST are combined in request.param """ 
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write(tob('b=b&c=p'))
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = '7'
#        e['QUERY_STRING'] = 'a=a&c=g'
#        e['REQUEST_METHOD'] = "POST"
#        request.bind(e, None)
#        self.assertEqual(['a','b','c'], sorted(request.params.keys()))
#        self.assertEqual('p', request.params['c'])
#
#    def test_getpostleak(self):
#        """ Environ: GET and POST sh0uld not leak into each other """ 
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write(u'b=b'.encode('utf8'))
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = '3'
#        e['QUERY_STRING'] = 'a=a'
#        e['REQUEST_METHOD'] = "POST"
#        request.bind(e, None)
#        self.assertEqual(['a'], request.GET.keys())
#        self.assertEqual(['b'], request.POST.keys())
#
#    def test_body(self):
#        """ Environ: Request.body should behave like a file object factory """ 
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write(u'abc'.encode('utf8'))
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = str(3)
#        request.bind(e, None)
#        self.assertEqual(u'abc'.encode('utf8'), request.body.read())
#        self.assertEqual(u'abc'.encode('utf8'), request.body.read(3))
#        self.assertEqual(u'abc'.encode('utf8'), request.body.readline())
#        self.assertEqual(u'abc'.encode('utf8'), request.body.readline(3))
#
#    def test_bigbody(self):
#        """ Environ: Request.body should handle big uploads using files """
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write((u'x'*1024*1000).encode('utf8'))
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = str(1024*1000)
#        request.bind(e, None)
#        self.assertTrue(hasattr(request.body, 'fileno'))        
#        self.assertEqual(1024*1000, len(request.body.read()))
#        self.assertEqual(1024, len(request.body.read(1024)))
#        self.assertEqual(1024*1000, len(request.body.readline()))
#        self.assertEqual(1024, len(request.body.readline(1024)))
#
#    def test_tobigbody(self):
#        """ Environ: Request.body should truncate to Content-Length bytes """
#        e = {}
#        wsgiref.util.setup_testing_defaults(e)
#        e['wsgi.input'].write((u'x'*1024).encode('utf8'))
#        e['wsgi.input'].seek(0)
#        e['CONTENT_LENGTH'] = '42'
#        request.bind(e, None)
#        self.assertEqual(42, len(request.body.read()))
#        self.assertEqual(42, len(request.body.read(1024)))
#        self.assertEqual(42, len(request.body.readline()))
#        self.assertEqual(42, len(request.body.readline(1024)))
#
#class TestMultipart(unittest.TestCase):
#    def test_multipart(self):
#        """ Environ: POST (multipart files and multible values per key) """
#        fields = [('field1','value1'), ('field2','value2'), ('field2','value3')]
#        files = [('file1','filename1.txt','content1'), ('file2','filename2.py',u'äöü')]
#        e = tools.multipart_environ(fields=fields, files=files)
#        request.bind(e, None)
#        # File content
#        self.assertTrue('file1' in request.POST)
#        self.assertEqual('content1', request.POST['file1'].file.read())
#        # File name and meta data
#        self.assertTrue('file2' in request.POST)
#        self.assertEqual('filename2.py', request.POST['file2'].filename)
#        # UTF-8 files
#        x = request.POST['file2'].file.read()
#        if sys.version_info >= (3,0,0):
#            x = x.encode('ISO-8859-1')
#        self.assertEqual(u'äöü'.encode('utf8'), x)
#        # No file
#        self.assertTrue('file3' not in request.POST)
#        # Field (single)
#        self.assertEqual('value1', request.POST['field1'])
#        # Field (multi)
#        self.assertEqual(2, len(request.POST.getall('field2')))
#        self.assertEqual(['value2', 'value3'], request.POST.getall('field2'))

if __name__ == '__main__':
    unittest.main()
