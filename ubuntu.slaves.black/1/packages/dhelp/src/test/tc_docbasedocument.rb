require 'test/unit'
require 'dhelp'
require 'fileutils'

class TC_DocBaseDocument < Test::Unit::TestCase
  def doc_base_file(path)
    "test/doc-base/#{path}"
  end

  def test_simple
    file = Dhelp::DocBaseDocument.new(doc_base_file('pica-manual'))

    assert_equal 'pica-manual', file.document
    assert_equal 'PICA Manual', file.title
    assert_equal 'Esteban Manchado Velázquez', file.author
    assert_equal 'Admin', file.section
    assert_equal "This manual describes what PICA is and how it can be used to administer your machines and keep them up-to-date and secure.", file.abstract

    assert_equal 2, file.formats.size
    ps_format, html_format = file.formats
    assert_equal "postscript", ps_format.format
    assert_equal %w(test/share-doc/pica/manual.ps.gz), ps_format.files

    assert_equal "html", html_format.format.downcase
    assert_equal "test/share-doc/pica/manual.html/index.html", html_format.index
    assert_equal %w(test/share-doc/pica/manual.html/*.html), html_format.files
  end

  def test_docbook_docbase
    file = Dhelp::DocBaseDocument.new(doc_base_file('docbook-xsl-doc-html'))

    assert_equal 'docbook-xsl-doc-html', file.document
    assert_equal 'DocBook XSL Stylesheet Documentation', file.title
    assert_equal 'Norman Walsh <ndw@nwalsh.com> and members of the DocBook Project <docbook-developers@sf.net>', file.author
    assert_equal 'Apps/Text', file.section
    assert_equal "Reference material for stylesheet parameters and templates. Included is a brief introduction to XSL and instructions for using the stylesheets with some common XSLT processors.", file.abstract

    assert_equal 1, file.formats.size
    html_format = file.formats.first
    assert_equal "html", html_format.format.downcase
    assert_equal "test/share-doc/docbook-xsl-doc-html/doc/index.html", html_format.index
    assert_equal %w(test/share-doc/docbook-xsl-doc-html/doc/*.html test/share-doc/docbook-xsl-doc-html/doc/*/*.html), html_format.files
  end

  def test_pstoedit
    file = Dhelp::DocBaseDocument.new(doc_base_file('pstoedit-man'))

    assert_equal 'pstoedit-man', file.document
    assert_equal 'pstoedit', file.title
    assert_equal 'Dr. Wolfgang Glunz', file.author
    assert_equal 'Graphics', file.section
    assert_equal "pstoedit translates PostScript and PDF graphics into other vector formats.", file.abstract

    assert_equal 1, file.formats.size
    html_format = file.formats.first
    assert_equal "html", html_format.format.downcase
    assert_equal "test/share-doc/pstoedit/index.htm", html_format.index
    assert_equal %w(test/share-doc/pstoedit/pstoedit.htm), html_format.files
  end

  def test_ghc6
    file = Dhelp::DocBaseDocument.new(doc_base_file('ghc6-users-guide'))

    assert_equal 'ghc6-users-guide', file.document
    assert_equal 'GHC6 User\'s manual', file.title
    assert_equal 'The GHC Team', file.author
    assert_equal 'Devel', file.section
    assert_equal "Version 6 of the Glorious Glasgow Haskell Compilation system (GHC). GHC is a compiler for Haskell98. <br> Haskell is \"the\" standard lazy functional programming language. Haskell98 is the current version of the language. The language definition and additional documentation can be found in the `haskell-doc' package. Alternatively, there is an online version at http://haskell.org/onlinereport/.", file.abstract

    assert_equal 1, file.formats.size
    html_format = file.formats.first
    assert_equal "html", html_format.format.downcase
    assert_equal "test/share-doc/ghc6-doc/html/index.html", html_format.index
    assert_equal %w(test/share-doc/ghc6-doc/html/*/*.html), html_format.files
  end

  def test_without_author
    file = Dhelp::DocBaseDocument.new(doc_base_file('without-author'))

    assert_equal 'ghc6-users-guide', file.document
    assert_equal 'GHC6 User\'s manual', file.title
    assert_equal nil, file.author
    assert_equal 'Devel', file.section
    assert_equal "Version 6 of the Glorious Glasgow Haskell Compilation system (GHC). GHC is a compiler for Haskell98. <br> Haskell is \"the\" standard lazy functional programming language. Haskell98 is the current version of the language. The language definition and additional documentation can be found in the `haskell-doc' package. Alternatively, there is an online version at http://haskell.org/onlinereport/.", file.abstract

    assert_equal 1, file.formats.size
    html_format = file.formats.first
    assert_equal "html", html_format.format.downcase
    assert_equal "test/share-doc/ghc6-doc/html/index.html", html_format.index
    assert_equal %w(test/share-doc/ghc6-doc/html/*/*.html), html_format.files
  end
end
