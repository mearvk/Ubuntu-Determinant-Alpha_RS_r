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
     $Id: qandaset.xsl,v 1.15 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Question-and-answer markup</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="question|answer">
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="for-label" />
  </xsl:variable>
  <varlistentry>
    <term>
      <xsl:call-template name="anchor" />
      <xsl:if test="$label != ''">
        <xsl:text>&#xA0;&#xA0;</xsl:text>
      </xsl:if>
      <xsl:copy-of select="$label" />
    </term>

    <listitem>
      <xsl:apply-templates />
    </listitem>
  </varlistentry>
</xsl:template>

<xsl:template match="qandaentry">
  <xsl:call-template name="anchor" />
  <xsl:apply-templates />
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="qandaset|qandadiv">
  <xsl:if test="title">
    <xsl:call-template name="make-caption" />
  </xsl:if>

  <xsl:call-template name="anchor" />
      
  <xsl:choose>
    <xsl:when test="qandaentry">

      <!-- Warning: Tables with paragraphs inside cells is formatted 
           horribly with Info. Don't use these. -->
      <!-- 
      <multitable cols="2">
        <colspec colwidth="1*"/>
        <colspec colwidth="19*" />
        <tbody>
          <xsl:apply-templates />
        </tbody>
      </multitable>
      -->

      <varlist>
        <xsl:apply-templates />
      </varlist>
      
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="label"></xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
