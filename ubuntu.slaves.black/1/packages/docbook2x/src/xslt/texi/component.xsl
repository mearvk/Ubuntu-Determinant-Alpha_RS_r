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
     $Id: component.xsl,v 1.12 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     Derived from files in Norman Walsh's XSL DocBook Stylesheet
     Distribution and Mark Burton's dbtotexi stylesheets.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="dedication">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'unnumbered'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="colophon">
  <xsl:call-template name="section" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="preface">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'unnumbered'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter">
  <xsl:call-template name="section" />
</xsl:template>

<xsl:template match="appendix">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'appendix'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->


<xsl:template match="article">
  <xsl:call-template name="section" />
</xsl:template>
 
<!-- ==================================================================== -->

</xsl:stylesheet>
 
