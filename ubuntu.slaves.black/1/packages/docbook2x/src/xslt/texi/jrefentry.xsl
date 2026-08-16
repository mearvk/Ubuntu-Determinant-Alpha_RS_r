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
     $Id: jrefentry.xsl,v 1.3 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title><sgmltag class="element">jrefentry</sgmltag> support</title>
<partintro>
<note>
<para>
The templates in this file are not included by default, as
<sgmltag class="element">jrefentry</sgmltag> is not standard DocBook.
To use these, you must import this file explicitly along with
<filename>docbook.xsl</filename> in your stylesheet.
</para>
</note>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="refdescription">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Description</xsl:with-param>
  </xsl:call-template>
</xsl:template>
  
<xsl:template match="refauthor">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Author</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refversion">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Version</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refparameter">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Parameters</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refreturn">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Return value</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refexception|refthrows">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Exceptions thrown</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refsee">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">See also</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refsince">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Since</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refserial">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Serial</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refdeprecated">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="title">Deprecated</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
