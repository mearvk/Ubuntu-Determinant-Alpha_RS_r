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
     $Id: glossary.xsl,v 1.8 2004/08/22 22:46:04 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Glossaries</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="glossary[glossentry[1]/preceding-sibling::*]">
  <xsl:call-template name="SS-section">
    <xsl:with-param name="content">
      <xsl:apply-templates select="glossentry" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="glossary">
  <xsl:call-template name="SS-section">
    <xsl:with-param name="content">
      <xsl:apply-templates select="(glossdiv[1]/preceding-sibling::*)"/>
      <xsl:apply-templates select="glossdiv" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="glosslist">
  <xsl:apply-templates />
</xsl:template>
  
<!-- ==================================================================== -->

<xsl:template match="glossdiv">
  <xsl:apply-templates />
</xsl:template>



<!-- ==================================================================== -->

<xsl:template match="glossentry">
  <TP>
    <xsl:apply-templates/>
  </TP>
</xsl:template>
  
<xsl:template match="glossentry/glossterm">
  <TPtag><xsl:apply-templates/></TPtag>
</xsl:template>

<xsl:template match="glossentry/acronym">
  <TPtag><xsl:apply-templates/></TPtag>
</xsl:template>
  
<xsl:template match="glossentry/abbrev">
  <TPtag><xsl:apply-templates/></TPtag>
</xsl:template>
  
<xsl:template match="glossentry/revhistory">
</xsl:template>

<xsl:template match="glossentry/glossdef">
  <TPitem>
    <xsl:apply-templates/>
  </TPitem>
</xsl:template>

<!-- ==================================================================== -->
  
<xsl:template match="glossentry/glosssee|glossseealso">
  <para>
    <xsl:call-template name="gentext-rendering">
      <xsl:with-param name="content">
        <xsl:choose>
          <xsl:when test="./@otherterm">
            <xsl:apply-templates select="key('id', ./@otherterm)" 
                                 mode="glosssee.xref" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </para>
</xsl:template>

<xsl:template match="glossentry" mode="glosssee.xref">
  <xsl:apply-templates mode="glosssee.xref" />
</xsl:template>

<xsl:template match="glossentry/glossterm[1]" mode="glosssee.xref">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="*" mode="glosssee.xref">
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
