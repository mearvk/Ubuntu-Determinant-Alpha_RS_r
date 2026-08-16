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
     $Id: verbatim.xsl,v 1.11 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Verbatim environments</title>
<partintro>
<para>These templates transform DocBook verbatim environments to their
Texinfo equivalents.</para>

<section>
<title>Verbatim environments: processing expectations</title>

<para>
The verbatim environments in the printed output (TeX) are not very wide,
and TeX will choke on lines that ordinarily fit comfortably on the screen
in Info and HTML output (an <quote>overfull <markup>@hbox</markup></quote>).  
So if you want Texinfo printed output, trim down the offending lines in the 
verbatim environments.  The stylesheets cannot do that for you.
</para>

</section>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="literallayout[@class='monospaced']">
  <example>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates mode="no-inline-markup" />
  </example>
</xsl:template>

<xsl:template match="literallayout">
  <display>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates />
  </display>
</xsl:template>
  
<xsl:template match="programlisting|screen">
  <example>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates mode="no-inline-markup" />
  </example>
</xsl:template>

<xsl:template match="address">
  <format>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates />
  </format>
</xsl:template>

</xsl:stylesheet>
