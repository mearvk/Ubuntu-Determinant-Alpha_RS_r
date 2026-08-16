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
     $Id: info.xsl,v 1.8 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>The <sgmltag class="element"><replaceable>*</replaceable>info</sgmltag>
wrappers</title>
</doc:reference>

<!-- ==================================================================== -->


<!-- These templates define the "default behavior" for info
     elements.  Even if you don't process the *info wrappers,
     some of these elements are needed because the elements are
     processed from named templates that are called with modes.
     Since modes aren't sticky, these rules apply. 
     (TODO: clarify this comment) -->

<!-- ==================================================================== -->
<!-- called from named templates in a given mode -->

<xsl:template match="corpauthor">
    <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="jobtitle">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="orgname">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="orgdiv">
    <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- Ignore meta-info wrappers -->

<xsl:template match="docinfo|prefaceinfo|chapterinfo|appendixinfo|articleinfo|artheader|glossaryinfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="bookinfo|setinfo|seriesinfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="partinfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="referenceinfo|refentryinfo|refsect1info|refsect2info|refsect3info|refsynopsisdivinfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="sect1info|sect2info|sect3info|sect4info|sect5info|sectioninfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="objectinfo">
  <xsl:apply-templates mode="info-wrapper" />
</xsl:template>

<xsl:template match="node()" mode="info-wrapper">
  <!-- ignore -->
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
