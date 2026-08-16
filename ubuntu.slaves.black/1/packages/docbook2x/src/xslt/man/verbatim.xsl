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
     $Id: verbatim.xsl,v 1.6 2006/04/19 20:38:56 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->
     
<doc:reference xmlns="">
<title>Verbatim environments</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="literallayout">
  <verbatim>
    <xsl:apply-templates mode="verbatim" />
  </verbatim>
</xsl:template>
  
<xsl:template match="programlisting|screen">
  <verbatim><tt>
    <xsl:apply-templates mode="verbatim" />
  </tt></verbatim>
</xsl:template>

<xsl:template match="address">
  <indent>
    <verbatim>
      <xsl:apply-templates mode="verbatim" />
    </verbatim>
  </indent>
</xsl:template>

<doc:mode mode="verbatim">
<refpurpose>
  Process content where line breaks and whitespace are to be preserved
</refpurpose>
<refdescription>
  <para>
    Under this mode, line breaks and whitespace are to be preserved.
  </para>
  <para>
    Also some elements under this mode 
    may be processed differently than normal.
    For example, hyperlinks may be forced to be displayed in the footnote
    style, to avoid cluttering a verbatim display.
  </para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="verbatim">
  <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="synopsis" mode="verbatim">
  <xsl:apply-templates mode="synopsis" />
</xsl:template>

<xsl:template match="text()" mode="verbatim">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
