# -*- coding: utf-8 -*-
import unittest
import axi
import axi.indexer
import os.path

class AxiTestBase(unittest.TestCase):
    def assertCleanIndex(self):
        self.assert_(os.path.exists(axi.XAPIANINDEX))
        self.assert_(os.path.exists(axi.XAPIANDBSTAMP))
        self.assert_(os.path.exists(axi.XAPIANDBVALUES))
        self.assert_(os.path.exists(axi.XAPIANDBDOC))
        self.assert_(not os.path.exists(axi.XAPIANDBUPDATESOCK))

        # Index is clean and up to date: an indexer should tell us that it does
        # not need to run
        progress = axi.indexer.SilentProgress()
        indexer = axi.indexer.Indexer(progress, True)
        self.assert_(indexer.lock())
        self.assert_(not indexer.setupIndexing())
        indexer = None
