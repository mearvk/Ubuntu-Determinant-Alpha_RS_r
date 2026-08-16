<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: manpage.xsl,v 1.6 2006/04/20 13:45:55 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->
     
<doc:reference xmlns="">
<title>Man page chunk</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="manpage-filename">
  <xsl:param name="filename" />
  <xsl:value-of select="normalize-space(translate($filename, &quot; /&quot;, &quot;__&quot;))" />
</xsl:template>


<xsl:template name="manpage">
  <xsl:param name="title" />
  <xsl:param name="section" select="$default-manpage-section" />
  <xsl:param name="h1" select="$title" />
  <xsl:param name="h2" select="$section" />
  
  <xsl:param name="h3" select="$header-3" />
  <xsl:param name="h4" select="$header-4" />
  <xsl:param name="h5" select="$header-5" />

  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>

  <manpage sect="{$section}"
            h1="{$h1}" h2="{$h2}"
            h3="{$h3}" h4="{$h4}" h5="{$h5}">
    <xsl:attribute name="title">
      <xsl:call-template name="manpage-filename">
        <xsl:with-param name="filename" select="$title" />
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="preprocessors">
      <xsl:if test=".//tgroup">
        <xsl:text>t</xsl:text>
      </xsl:if>
    </xsl:attribute>

    <xsl:copy-of select="$content" />
            
  </manpage>
</xsl:template>
            
</xsl:stylesheet>
