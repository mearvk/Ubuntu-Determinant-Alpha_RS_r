<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: admon.xsl,v 1.14 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Admonitions</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="admonition-title">
  <xsl:call-template name="make-caption">
    <xsl:with-param name="content">
      <xsl:choose>
        <xsl:when test="./title">
          <xsl:apply-templates select="./title" mode="title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext-title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="note|important|warning|caution|tip">
  <quotation>
    <xsl:call-template name="anchor" />
    <xsl:call-template name="admonition-title" />
  
    <xsl:apply-templates />
  </quotation>
</xsl:template>

</xsl:stylesheet>
