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
     $Id: glossary.xsl,v 1.22 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Glossaries</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="glossary">
  <xsl:call-template name="section">
    <xsl:with-param name="content">

      <!-- Looks like a poorly thought out content model here :( -->
      <xsl:choose>
        <xsl:when test="glossentry">
          <xsl:apply-templates select="(glossentry[1]/preceding-sibling::*)"/>
          <varlist>
            <xsl:apply-templates select="glossentry" />
          </varlist>
        </xsl:when>

        <xsl:otherwise>
          <xsl:apply-templates select="(glossdiv[1]/preceding-sibling::*)"/>
          <xsl:apply-templates select="glossdiv" />
        </xsl:otherwise>
      </xsl:choose>

    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="glosslist">
  <varlist>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates />
  </varlist>
</xsl:template>
  
<!-- ==================================================================== -->

<xsl:template match="glossdiv">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>

    <xsl:with-param name="content">
      <xsl:apply-templates select="(glossentry[1]/preceding-sibling::*)"/>
      <varlist>
        <xsl:apply-templates select="glossentry"/>
      </varlist>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>



<!-- ==================================================================== -->

<xsl:template match="glossentry">
  <varlistentry>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </varlistentry>
</xsl:template>
  
<xsl:template match="glossentry/glossterm">
  <term><xsl:apply-templates/></term>
</xsl:template>

<xsl:template match="glossentry/acronym">
  <term><xsl:apply-templates/></term>
</xsl:template>
  
<xsl:template match="glossentry/abbrev">
  <term><xsl:apply-templates/></term>
</xsl:template>
  
<xsl:template match="glossentry/revhistory">
  <term><xsl:apply-templates/></term>
</xsl:template>

<xsl:template match="glossentry/glossdef">
  <listitem>
    <xsl:apply-templates/>
  </listitem>
</xsl:template>

<!-- ==================================================================== -->
  
<xsl:template match="glossentry/glosssee|glossseealso">
  <para>
    <xsl:call-template name="gentext-rendering">
      <xsl:with-param name="content">
        <xsl:choose>
          <xsl:when test="./@otherterm">
            <xsl:apply-templates select="key('id', ./@otherterm)" 
                                 mode="glosssee-xref" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </para>
</xsl:template>

<xsl:template match="glossentry" mode="glosssee-xref">
  <xsl:apply-templates mode="glosssee-xref" />
</xsl:template>

<xsl:template match="glossentry/glossterm[1]" mode="glosssee-xref">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="*" mode="glosssee-xref">
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
