require 'test/unit'
require 'dhelp'
require 'set'

class TC_DocBaseDocumentPool < Test::Unit::TestCase
  def doc_base_document(path)
    Dhelp::DocBaseDocument.new("test/doc-base-pool/#{path}")
  end

  def setup
    @pool = Dhelp::DocBaseDocumentPool.new(:dirs => ['test/doc-base-pool'])
    @doc_base_id_set = Set.new(['docbook-xsl-doc-html',
                                'pica-manual',
                                'pica-manual-2'])
  end

  def test_each
    doc_id_set = Set.new
    @pool.each do |doc|
      doc_id_set << doc.document
    end
    assert_equal @doc_base_id_set, Set.new(doc_id_set)
  end

  def test_section
    sections = []
    @pool.each_section do |s, docs|
      sections << s
    end
    assert_equal ['Apps/Text', 'Admin'], sections
  end

  def teardown
    @pool = nil
  end
end
