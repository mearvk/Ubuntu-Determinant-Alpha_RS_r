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
     $Id: chunk.xsl,v 1.5 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Output the preamble</title>
</doc:reference>

<!-- ==================================================================== -->

<!-- This is where all processing starts. -->
<xsl:template match="/">
  <texinfoset>
    <xsl:call-template name="make-nodenamemap" />
    <xsl:apply-templates mode="top-chunk" />
  </texinfoset>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode mode="top-chunk" xmlns="">
<refpurpose>Process a top-level chunk</refpurpose>
<refdescription>
<para>
This mode is supposed to output all the Texi-XML markup
required for the beginning of the Texinfo file,
e.g. <sgmltag class="element">settitle</sgmltag>, 
Texinfo directories, etc.   After that, it goes onto
normal processing.
</para>
</refdescription>
</doc:mode>

<!-- ==================================================================== -->

<xsl:template match="*" mode="top-chunk">
  <xsl:variable name="is-node">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>

  <texinfo>
    <xsl:attribute name="file">
      <xsl:call-template name="get-texinfo-file-name" />
    </xsl:attribute>
      
    <settitle>
      <xsl:apply-templates select="." mode="for-title" />
    </settitle>
  
    <xsl:call-template name="make-texinfo-directory" />

    <xsl:if test="$is-node = ''">
      <xsl:call-template name="make-texinfo-node" />
      <xsl:call-template name="make-texinfo-section" />
    </xsl:if>

    <xsl:apply-templates select="." />
  </texinfo>
</xsl:template>

</xsl:stylesheet>
