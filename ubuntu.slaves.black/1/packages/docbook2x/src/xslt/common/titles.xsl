<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: titles.xsl,v 1.11 2004/08/04 02:05:40 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X.  title mode.  Will need to go over this
     code.

     ********************************************************************
-->
		

<!-- ============================================================ -->

<doc:mode mode="for-title" xmlns="">
<refpurpose>Provides access to element titles</refpurpose>
<refdescription>
<para>Processing an element in the
<literal role="mode">title</literal> mode produces the
title of the element. This does not include the label.
</para>
</refdescription>
</doc:mode>

<xsl:template match="title" mode="title">
  <xsl:apply-templates mode="title" />
</xsl:template>

<xsl:template match="*" mode="title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no-anchors" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="title">
  <xsl:value-of select="." />
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="set" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:apply-templates select="(setinfo/title|title)[1]"
                       mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:param name="suppress-error" select="false()" />
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]" mode="title">
	<xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>

    <xsl:when test="$suppress-error">
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="user-message">
        <xsl:with-param name="key">Erroneous request for title for this element</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key">[missing text]</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="book" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:apply-templates select="(bookinfo/title|title)[1]"
                       mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="part" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:apply-templates select="(partinfo/title|docinfo/title|title)[1]"
                       mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />

  <xsl:variable name="title" select="(docinfo/title
                                      |prefaceinfo/title
                                      |chapterinfo/title
                                      |appendixinfo/title
                                      |title)[1]"/>
  <xsl:apply-templates select="$title" mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="partintro" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <!-- partintro's don't have titles, use the parent (part or reference)
       title instead. -->
  <xsl:apply-templates select="parent::*" mode="for-title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dedication" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="colophon" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="article" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="(artheader/title
                                      |articleinfo/title
                                      |title)[1]"/>

  <xsl:apply-templates select="$title" mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="reference" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:apply-templates select="(referenceinfo/title|docinfo/title|title)[1]"
                       mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refentry" mode="for-title">
  <xsl:param name="allow-anchors" select="false()"/>
  <xsl:variable name="refmeta" select=".//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="title">
          <xsl:with-param name="allow-anchors" select="$allow-anchors" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="title">
          <xsl:with-param name="allow-anchors" select="$allow-anchors" />
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="user-message">
          <xsl:with-param name="key">refentry has no title</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="gentext-text">
          <xsl:with-param name="key">No title</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$title"/>
</xsl:template>


<xsl:template match="refsynopsisdiv" mode="for-title">
  <xsl:param name="allow-anchors" select="false()"/>
  <xsl:choose>
    <xsl:when test="./title">
      <xsl:apply-templates select="./title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 

<xsl:template match="section
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3
                     |simplesect"
              mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="(sectioninfo/title
                                      |sect1info/title
                                      |sect2info/title
                                      |sect3info/title
                                      |sect4info/title
                                      |sect5info/title
                                      |refsect1info/title
                                      |refsect2info/title
                                      |refsect3info/title
                                      |title)[1]"/>

  <xsl:apply-templates select="$title" mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="bibliography" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="(bibliographyinfo/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossary" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="(glossaryinfo/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="index" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="(indexinfo/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure|table|example|equation" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:apply-templates select="title" mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="qandaset|qandadiv" mode="for-title">
  <xsl:param name="allow-anchors" select="false()"/>
  <xsl:apply-templates select="title" mode="title">
    <xsl:with-param name="allow-anchors" select="$allow-anchors" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="abstract" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="caution|tip|warning|important|note" mode="for-title">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:variable name="title" select="title[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title">
        <xsl:with-param name="allow-anchors" select="$allow-anchors" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-title" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- ============================================================ -->

<xsl:template match="*" mode="no-anchors">
  <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="footnote" mode="no-anchors">
</xsl:template>

<xsl:template match="anchor" mode="no-anchors">
</xsl:template>

<xsl:template match="ulink" mode="no-anchors">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="link" mode="no-anchors">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="olink" mode="no-anchors">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="indexterm" mode="no-anchors">
</xsl:template>

<xsl:template match="xref" mode="no-anchors">
  <!-- FIXME: this should generate the text without the link... -->
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>

