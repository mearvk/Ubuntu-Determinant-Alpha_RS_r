require 'test/unit'
require 'dhelp'
require 'fileutils'
require 'set'

class TC_DhelpDocumentPool < Test::Unit::TestCase

  TEST_DOC_BASE_DIR     = 'test/doc-base-pool'
  TEST_DOC_DIR_DATABASE = 'test/dddb'
  TEST_INDEX_FILE       = 'test/index.swish++'
  TEST_PENDING_FILE     = 'test/pending.list'
  TEST_INDEXER_CONFIG   = 'config/swish++.conf'

  def doc_base_document(path)
    Dhelp::DocBaseDocument.new(TEST_DOC_BASE_DIR + "/#{path}")
  end

  def doc_id_set_in_pool(pool)
    doc_id_set = Set.new
    pool.each do |doc|
      doc_id_set << doc.document
    end
    doc_id_set
  end

  def setup
    @pool = Dhelp::DhelpDocumentPool.new(
              :doc_base_dir         => [TEST_DOC_BASE_DIR],
              :doc_dir_database     => TEST_DOC_DIR_DATABASE,
              :index_file           => TEST_INDEX_FILE,
              :indexer_config_file  => TEST_INDEXER_CONFIG,
              :pending_file         => TEST_PENDING_FILE
              )
    @doc_base_id_set = Set.new(['docbook-xsl-doc-html',
                                'pica-manual',
                                'pica-manual-2'])
  end

  def test_each
    assert_equal @doc_base_id_set, doc_id_set_in_pool(@pool)
  end

  def test_deregistration
    deregistered_docs = ['pica-manual']
    deregistered_docs.each do |doc|
      @pool.deregister(TEST_DOC_BASE_DIR + "/#{doc}")
    end
    assert_equal @doc_base_id_set - deregistered_docs,
      doc_id_set_in_pool(@pool)
  end

  def test_registration
    index_file = 'test/share-doc/pica/manual.html/index.html'
    doc_id     = 'pica-manual'
    doc        = doc_base_document(doc_id)
    # Make sure we're expecting the correct directory
    assert_equal index_file,
      doc.formats.find {|f| f.format.downcase == 'html'}.index
    # Register document, see if the containing directory is added
    @pool.register(doc)
    ddd = Dhelp::DocDirDatabase.open(DBM::READER, TEST_DOC_DIR_DATABASE)
    assert_equal doc_id, ddd.info_for_path(File.dirname(index_file)).first
    ddd.close
  end

  def test_section_tree
    expected_section_tree = {
      'Apps'  => {:documents   => [],
                  :subsections => {
                     'Text' => {:documents => [doc_base_document('docbook-xsl-doc-html')], :subsections => {}}}},
      'Admin' => {:documents   => [doc_base_document('pica-manual'),
                                   doc_base_document('pica-manual-2')],
                  :subsections => {}}}
    actual_section_tree   = @pool.section_tree
    # Can't compare the whole thing because the memory addresses for the
    # DocBaseDocument objects are different :-(
    assert_equal expected_section_tree.keys, actual_section_tree.keys
    assert_equal expected_section_tree['Apps'][:subsections].keys,
                 actual_section_tree['Apps'][:subsections].keys
    assert_equal expected_section_tree['Apps'][:subsections]['Text'][:documents].map {|d| d.document},
                 actual_section_tree['Apps'][:subsections]['Text'][:documents].map {|d| d.document}
    assert_equal expected_section_tree['Admin'][:documents].map {|d| d.document},
                 actual_section_tree['Admin'][:documents].map {|d| d.document}
  end

  def test_doc_base_dirs
    @pool.register(doc_base_document('docbook-xsl-doc-html'))
    dddbh1 = Dhelp::DocDirDatabase.open(DBM::READER, TEST_DOC_DIR_DATABASE)
    assert dddbh1.include?('test/share-doc/docbook-xsl-doc-html/doc'),
           "The docbook-xsl-doc-html directory should be registered"
    assert !dddbh1.include?('test/share-doc/pica/manual.html'),
           "The pica-manual directory should NOT be registered"
    dddbh1.close

    @pool.register(doc_base_document('pica-manual'))
    dddbh2 = Dhelp::DocDirDatabase.open(DBM::READER, TEST_DOC_DIR_DATABASE)
    assert dddbh2.include?('test/share-doc/docbook-xsl-doc-html/doc'),
           "The docbook-xsl-doc-html directory should still be registered"
    assert dddbh2.include?('test/share-doc/pica/manual.html'),
           "The pica-manual directory should be registered"
    dddbh2.close
  end

  def test_rebuild_indexing
    # Register all documents, all will be indexed
    @pool.rebuild
    # Now, once everything is indexed, force a reindexing (like the cron job)
    FileUtils.rm_f TEST_INDEX_FILE
    @pool.rebuild
    assert File.exist?(TEST_INDEX_FILE),
           "Index file should exist after rebuilding"
    assert(File.size(TEST_INDEX_FILE) > 0,
           "Index file should have non-zero size after rebuilding")
  end

  def test_rebuild_dirs
    # 1) Create a temporary directory with some documents
    tmp_dir     = 'test/tmp/doc-base-pool'
    dddb        = 'test/tmp/doc-base_dirs'
    index_file  = 'test/tmp/index'
    config_file = TEST_INDEXER_CONFIG
    FileUtils.mkdir_p tmp_dir
    FileUtils.cp 'test/doc-base/dir-test-1', tmp_dir
    FileUtils.cp 'test/doc-base/dir-test-2', tmp_dir
    # Create directories for documentation
    FileUtils.mkdir_p 'test/tmp/share-doc/dir-test-1/manual.html'
    FileUtils.mkdir_p 'test/tmp/share-doc/dir-test-2/manual.html'

    tmp_pool = Dhelp::DhelpDocumentPool.new(
                  :doc_base_dir         => [tmp_dir],
                  :doc_dir_database     => dddb,
                  :index_file           => index_file,
                  :indexer_config_file  => config_file
                  )
    # 2) Register everything
    tmp_pool.rebuild
    # 3) Deregister one of those documents
    path_to_deregister = "test/tmp/doc-base-pool/dir-test-1"
    tmp_pool.deregister(path_to_deregister)
    # 4) Delete that document
    FileUtils.rm path_to_deregister
    # 5) Rebuild, check that the directory database doesn't include the deleted
    #    document
    tmp_pool.rebuild
    doc_dir_db = Dhelp::DocDirDatabase.open(DBM::READER, dddb)
    assert !doc_dir_db.include?('test/tmp/share-doc/dir-test-1/manual.html'),
           "The directory for dir-test-1 should NOT exist"
    assert doc_dir_db.include?('test/tmp/share-doc/dir-test-2/manual.html'),
           "The directory for dir-test-2 should still exist"
    doc_dir_db.close

    # Cleanup
    FileUtils.rm_rf 'test/tmp'
  end

  def test_register_dirs
    doc    = Dhelp::DocBaseDocument.new('test/doc-base/ghc6-users-guide')
    @pool.register(doc)
    ddd = Dhelp::DocDirDatabase.open(DBM::READER, TEST_DOC_DIR_DATABASE)
    assert ddd.include?('test/share-doc/ghc6-doc/html/libraries'),
           "Docdir should include the libraries subdir"
    assert ddd.include?('test/share-doc/ghc6-doc/html'),
           "Docdir should include the index file subdir"
  end

  def teardown
    @pool = nil
    @doc_base_id_set = nil
    FileUtils.rm_f Dir.glob("#{TEST_DOC_DIR_DATABASE}.*")
    FileUtils.rm_f TEST_INDEX_FILE
    FileUtils.rm_f TEST_PENDING_FILE
  end
end
