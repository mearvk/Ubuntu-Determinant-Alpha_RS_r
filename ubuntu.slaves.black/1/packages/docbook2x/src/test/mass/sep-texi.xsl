<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="doc exslt"
                extension-element-prefixes="exslt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: sep-texi.xsl,v 1.2 2006/04/21 02:56:43 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     Write Texi-XML documents from DocBook transformation to separate files.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:import href="../../xslt/texi/docbook.xsl" />

<xsl:param name="path" select="'.'" />
<xsl:param name="doctype-system" select="'http://docbook2x.sf.net/latest/dtd/Texi-XML'" />

<xsl:template match="/">
  <xsl:variable name="filename">
    <xsl:call-template name="get-texinfo-file-name">
      <xsl:with-param name="node" select="*" />
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="href" select="concat($path,'/',$filename,'.txml')" />

  <xsl:message>
    <xsl:value-of select="$href" />
  </xsl:message>

  <exslt:document method="xml"
                  encoding="utf-8"
                  href="{$href}"
                  doctype-public="-//Steve Cheng//DTD Texi-XML V0.8.7//EN"
                  doctype-system="{$doctype-system}">
    <xsl:apply-imports />
  </exslt:document>
</xsl:template>

</xsl:stylesheet>
