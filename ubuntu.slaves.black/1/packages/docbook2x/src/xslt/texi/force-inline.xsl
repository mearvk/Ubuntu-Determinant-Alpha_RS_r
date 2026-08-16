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
     $Id: force-inline.xsl,v 1.10 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Process only inline content</title>
</doc:reference>

<!-- ==================================================================== -->

<doc:mode mode="coerce-into-inline" xmlns="">
<refpurpose>Process only inline content</refpurpose>
<refdescription>
<para>A few elements in DocBook, namely <sgmltag class="element">entry</sgmltag>
and <sgmltag class="element">footnote</sgmltag>, have content models
that allow block-level content (as well as inline-level content), but
the mapping to Texinfo does not allow block-level content.
This mode selects only the inline content and loudly complains to the
user if block-level elements are found.
</para>
<para>
Additionally, simple paragraphs are converted to inline content.
</para>
</refdescription>
</doc:mode>

<xsl:template 
  match="calloutlist|glosslist|itemizedlist|orderedlist|segmentedlist|
         simplelist|variablelist|
         caution|important|note|tip|warning|
         literallayout|programlisting|programlistingco|
         screen|screenco|screenshot|
         synopsis|cmdsynopsis|funcsynopsis|
         classsynopsis|fieldsynopsis|
         constructorsynopsis|destructorsynopsis|methodsynopsis|
         formalpara|
         address|blockquote|
         graphic|graphicco|mediaobject|mediaobjectco|
         informalequation|informalexample|informalfigure|informaltable|
         equation|example|figure|table|
         msgset|procedure|qandaset"
  mode="coerce-into-inline">
  <xsl:call-template name="user-message">
    <xsl:with-param name="key">non-inline content not supported</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'block-object-placeholder'" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="para|simpara" mode="coerce-into-inline">
  <xsl:if test="preceding-sibling::para | preceding-sibling::simpara">
    <xsl:call-template name="user-message">
      <xsl:with-param name="key">non-inline content not supported</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'block-object-placeholder'" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates mode="coerce-into-inline" />
</xsl:template>

<xsl:template match="*|text()" mode="coerce-into-inline">
  <xsl:apply-templates select="." />
</xsl:template>
 
</xsl:stylesheet>

