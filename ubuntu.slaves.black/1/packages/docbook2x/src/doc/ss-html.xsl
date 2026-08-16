<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: ss-html.xsl,v 1.15 2006/03/19 20:47:49 stevecheng Exp $
     ********************************************************************

     docbook2texi-xslt customization for docbook2X documentation
     
     ******************************************************************** -->

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk.xsl" />

<xsl:param name="chunker.output.encoding" select="'us-ascii'" />
<xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>

<!--  Fast chunking breaks custom navigation templates
<xsl:param name="chunk.fast" select="'yes'" />
-->

<xsl:param name="use.id.as.filename" select="1" />

<xsl:param name="css.decoration" select="0" />
<xsl:param name="spacing.paras" select="0" />

<xsl:param name="refentry.xref.manvolnum" select="0" />

<xsl:param name="generate.index" select="1" />

<xsl:param name="root.filename" select="'docbook2X'" />

<xsl:param name="html.stylesheet" select="'docbook2X.css'" />

<!-- Poor man's profiling.
     (You could use the profiling stylesheets from the DocBook
      XSL distribution while converting to man pages and Texinfo,
      but our documentation build system is already complicated
      as it is.  We shall only need very simple profiling.)
-->
<xsl:template match="*[@role='man-page']" priority="10.0">
  <!-- Omit anything that is designated as man-page only -->
</xsl:template>

<!-- Old-style olinks (using the targetdocent attribute).
     The new-style olinks (with targetdoc and targetdocptr
     attributes) are overkill for our purposes,
     and anyway require substantial effort to implement
     in the Texinfo stylesheets. -->
<xsl:template match="olink">
  <xsl:choose>
    <xsl:when test="@targetdocent = 'docbook2man-xslt'">
      <a href="../xslt/documentation/docbook2man-xslt.html/docbook2man-xslt.html"><xsl:apply-templates /></a>
    </xsl:when>
    <xsl:when test="@targetdocent = 'docbook2texi-xslt'">
      <a href="../xslt/documentation/docbook2texi-xslt.html/docbook2texi-xslt.html"><xsl:apply-templates /></a>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- Suppress display of the abstracts; they are only for Texinfo -->
<xsl:template match="abstract[@role='texinfo-node']" 
              mode="sect1.titlepage.recto.mode">
</xsl:template>
<xsl:template match="abstract[@role='texinfo-node']" 
              mode="sect2.titlepage.recto.mode">
</xsl:template>
<xsl:template match="abstract[@role='texinfo-node']" 
              mode="appendix.titlepage.recto.mode">
</xsl:template>

<xsl:template match="abstract[@role='texinfo-node']" 
              mode="article.titlepage.recto.mode">
</xsl:template>

<xsl:param name="toc.max.depth" select="2" />

<!-- There seem to be two bugs in the DocBook XSL stylesheets;
     refentry and index are not included in the toc.  So fix that. -->
<xsl:template match="sect1" mode="toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="refentry
                                         |bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes" select="section|sect1|refentry
                                         |article|bibliography|glossary
                                         |appendix|index
                                         |bridgehead[not(@renderas)
                                                     and $bridgehead.in.toc != 0
]
                                         |.//bridgehead[@renderas='sect1'
                                                        and $bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>


<xsl:param name="local.l10n.xml" select="document('')" />
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:gentext key="nav-home" text="Table of Contents" />
    <l:gentext key="nav-prev" text="&lt;&lt; Previous" />
    <l:gentext key="nav-next" text="Next &gt;&gt;" />
  </l:l10n>
</l:i18n>

<xsl:template name="user.footer.navigation">
  <p class="footer-homepage"><a href="http://docbook2x.sourceforge.net/" title="docbook2X: Home page">docbook2X home page</a></p>
</xsl:template>

<xsl:param name="link.mailto.url">
  <xsl:text>mailto:stevecheng@users.sourceforge.net</xsl:text>
</xsl:param>

<!-- Want to make a better title for each HTML page -->
<xsl:template match="*" mode="object.title.markup.textonly">
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="self::article">
      <xsl:text>docbook2X: Documentation Table of Contents</xsl:text>
    </xsl:when>
    <!-- There is some mistake in the usual title code here, so fix it -->
    <xsl:when test="self::*[@id='wrapper-scripts']">
      <xsl:text>docbook2X: Wrapper scripts</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>docbook2X: </xsl:text><xsl:value-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:param name="appendix.autolabel" select="0" />

<xsl:template match="author" mode="article.titlepage.recto.mode">
  <p class="{name(.)}">
    <b>Author: </b>
    <xsl:call-template name="person.name" />
    (<xsl:apply-templates mode="titlepage.mode" select="./affiliation/address/email"/>)
  </p>
</xsl:template>


<!-- This stylesheet was created by template/titlepage.xsl; do not edit it by hand. -->

<xsl:template name="article.titlepage.recto">
  <xsl:choose>
    <xsl:when test="articleinfo/title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/title"/>
    </xsl:when>
    <xsl:when test="artheader/title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/title"/>
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="title"/>
    </xsl:when>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="articleinfo/subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/subtitle"/>
    </xsl:when>
    <xsl:when test="artheader/subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/subtitle"/>
    </xsl:when>
    <xsl:when test="subtitle">
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/releaseinfo"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/releaseinfo"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/corpauthor"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/corpauthor"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/authorgroup"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/authorgroup"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/author"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/author"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/othercredit"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/othercredit"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/copyright"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/copyright"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/legalnotice"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/legalnotice"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/pubdate"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/pubdate"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/revision"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/revision"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/revhistory"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/revhistory"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="articleinfo/abstract"/>
  <xsl:apply-templates mode="article.titlepage.recto.auto.mode" select="artheader/abstract"/>
</xsl:template>

<xsl:template name="article.titlepage.verso">
</xsl:template>

<xsl:template name="article.titlepage.separator"><hr/>
</xsl:template>

<xsl:template name="article.titlepage.before.recto">
</xsl:template>

<xsl:template name="article.titlepage.before.verso">
</xsl:template>

<xsl:template name="article.titlepage">
  <div class="titlepage">
    <div>
    <xsl:call-template name="article.titlepage.before.recto"/>
    <xsl:call-template name="article.titlepage.recto"/>
    </div>
    <div>
    <xsl:call-template name="article.titlepage.before.verso"/>
    <xsl:call-template name="article.titlepage.verso"/>
    </div>
    <xsl:call-template name="article.titlepage.separator"/>
  </div>
</xsl:template>

<xsl:template match="*" mode="article.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="article.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="title" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="subtitle" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="releaseinfo" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="corpauthor" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="authorgroup" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="author" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="othercredit" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="copyright" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="legalnotice" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="pubdate" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="revision" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="revhistory" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

<xsl:template match="abstract" mode="article.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="article.titlepage.recto.style">
<xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
</div>
</xsl:template>

</xsl:stylesheet>

