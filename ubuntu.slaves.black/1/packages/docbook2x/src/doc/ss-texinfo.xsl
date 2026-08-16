<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: ss-texinfo.xsl,v 1.15 2006/04/15 18:46:07 stevecheng Exp $
     ********************************************************************

     docbook2texi-xslt customization for docbook2X documentation
     
     ******************************************************************** -->
<xsl:import href="http://docbook2x.sourceforge.net/latest/xslt/texi/docbook.xsl" />

<xsl:param name="explicit-node-names" select="false()" />

<!-- Do not make nodes for the more specific sections.
     Sections are short in this document. -->
<xsl:template match="sect2|sect3|sect4|sect5|simplesect"
              mode="is-texinfo-node">
</xsl:template>

<!-- Poor man's profiling.
     (You could use the profiling stylesheets from the DocBook
      XSL distribution while converting to man pages and Texinfo,
      but our documentation build system is already complicated
      as it is.  We shall only need very simple profiling.)
-->
<xsl:template match="*[@role='man-page']" priority="10.0">
  <!-- Omit anything that is designated as man-page only -->
</xsl:template>
<xsl:template match="*[@role='html']" priority="10.0">
  <!-- Omit anything that is designated as HTML only -->
</xsl:template>

<!-- Old-style olinks (using the targetdocent attribute).
     The new-style olinks (with targetdoc and targetdocptr
     attributes) are overkill for our purposes,
     and anyway require substantial effort to implement 
     in the Texinfo stylesheets. -->
<xsl:template match="olink">
  <xsl:choose>
    <xsl:when test="@targetdocent = 'docbook2man-xslt'">
      <ref node="Top" file="docbook2man-xslt" printmanual="docbook2X Man-pages Stylesheets Reference">
        <xsl:apply-templates />
      </ref>
    </xsl:when>
    <xsl:when test="@targetdocent = 'docbook2texi-xslt'">
      <ref node="Top" file="docbook2texi-xslt" printmanual="docbook2X Texinfo Stylesheets Reference">
        <xsl:apply-templates />
      </ref>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- Ignore ulinks that are marked as merely "informative";
     since unlike in HTML, the Info viewer cannot hide the URL
     and it clutters up the display. -->
<xsl:template match="ulink[@role='informative']">
  <xsl:apply-templates />
</xsl:template>

<!-- Texinfo puts quotes around a @dfn, which is used to translate
     firstterm.  We do not want the quotes, so just use italic instead.
     -->
<xsl:template match="firstterm">
  <i><xsl:apply-templates /></i>
</xsl:template>

<!-- parameter to get correct paths in refentry pages -->
<xsl:template match="processing-instruction('install-datadir')">
  <xsl:value-of select="$install-datadir" />
</xsl:template>

</xsl:stylesheet>

