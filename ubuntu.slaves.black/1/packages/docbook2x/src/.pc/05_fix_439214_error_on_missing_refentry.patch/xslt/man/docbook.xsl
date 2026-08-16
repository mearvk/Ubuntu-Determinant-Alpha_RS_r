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
     $Id: docbook.xsl,v 1.14 2006/04/11 19:00:19 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:include href="../common/version.xsl" />

<!-- i18n templates -->
<xsl:include href="../common/string.xsl" />
<xsl:include href="../common/l10n.xsl" />
<xsl:include href="../common/gentext.xsl" />
<xsl:include href="../common/messages.xsl" />
<xsl:include href="../common/ucase.xsl" />

<!-- Common DocBook stuff -->
<xsl:include href="../common/check-idref.xsl" />
<xsl:include href="../common/cmdsynopsis.xsl" />
<xsl:include href="../common/lists.xsl" />
<xsl:include href="../common/person.xsl" />
<xsl:include href="../common/titles.xsl" />
<xsl:include href="../common/whitespace.xsl" />

<!-- Default parameters  -->
<xsl:include href="param.xsl"/>

<!-- Sectioning -->
<xsl:include href="manpage.xsl" />
<xsl:include href="refentry.xsl" />
<xsl:include href="sectioning.xsl" />
<xsl:include href="sections.xsl" />

<!-- Block objects -->
<xsl:include href="admon.xsl"/>
<xsl:include href="block.xsl"/>
<xsl:include href="caption.xsl"/>
<xsl:include href="formal.xsl"/>
<xsl:include href="synop.xsl"/>
<xsl:include href="table.xsl"/>
<xsl:include href="verbatim.xsl"/>

<!-- Inline objects -->
<xsl:include href="inline.xsl"/>

<!-- Cross references -->
<xsl:include href="xref.xsl"/>

<!-- Lists -->
<xsl:include href="glossary.xsl"/>
<xsl:include href="lists.xsl"/>

<!-- Metadata -->
<xsl:include href="index.xsl"/>
<xsl:include href="info.xsl"/>
<xsl:include href="keywords.xsl"/>
<xsl:include href="toc.xsl"/>

<!-- Page layout -->
<xsl:include href="beginpage.xsl" />

<!-- Processing instructions -->
<xsl:include href="pi.xsl"/>

<!-- ==================================================================== -->

<xsl:output method="xml" encoding="utf-8" standalone="yes" />
<!--
            doctype-public="-//Steve Cheng//DTD Man-XML V0.8.4//EN"
            doctype-system="http://docbook2x.sf.net/latest/dtd/Man-XML"
-->

<!-- ==================================================================== -->

<xsl:template match="*">
  <xsl:call-template name="user-message">
    <xsl:with-param name="key">element not matched by any template</xsl:with-param>
  </xsl:call-template>

  <xsl:comment>
    <xsl:call-template name="gentext-rendering">
      <xsl:with-param name="key" select="'element-not-matched'" />
      <xsl:with-param name="content" select="name(.)" />
    </xsl:call-template>
  </xsl:comment>

  <xsl:apply-templates />
</xsl:template>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="child::refentry">
      <xsl:apply-templates />
    </xsl:when>

    <xsl:otherwise>
      <manpageset>
        <xsl:apply-templates select="descendant-or-self::refentry" />
      </manpageset>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/> 
</xsl:template>

</xsl:stylesheet>
