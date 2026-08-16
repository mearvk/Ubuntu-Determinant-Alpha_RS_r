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
     $Id: docbook.xsl,v 1.39 2006/03/19 20:38:57 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:include href="../common/version.xsl" />

<!-- i18n templates -->
<xsl:include href="../common/string.xsl" />
<xsl:include href="../common/l10n.xsl" />
<xsl:include href="../common/messages.xsl" />
<xsl:include href="../common/gentext.xsl" />
<xsl:include href="../common/ucase.xsl" />

<!-- Common DocBook stuff -->
<xsl:include href="../common/check-idref.xsl" />
<xsl:include href="../common/cmdsynopsis.xsl" />
<xsl:include href="../common/labels.xsl" />
<xsl:include href="../common/lists.xsl" />
<xsl:include href="../common/person.xsl" />
<xsl:include href="../common/titles.xsl" />
<xsl:include href="../common/whitespace.xsl" />



<!-- Default parameters  -->
<xsl:include href="param.xsl"/>

<!-- Texinfo node handling -->
<xsl:include href="texifile.xsl" />
<xsl:include href="texinode.xsl" />
<xsl:include href="texinode-base.xsl" />
<xsl:include href="chunk.xsl" />

<!-- Texinfo menus -->
<xsl:include href="autotoc.xsl"/>
<xsl:include href="menudescrip.xsl" />

<!-- Texinfo automatic indexing -->
<xsl:include href="index.xsl"/>

<!-- Sectioning -->
<xsl:include href="sectioning.xsl" />
<xsl:include href="component.xsl" />
<xsl:include href="division.xsl" />
<xsl:include href="sections.xsl" />
<xsl:include href="refentry.xsl" />

<!-- Block objects -->
<xsl:include href="admon.xsl" />
<xsl:include href="block.xsl" />
<xsl:include href="caption.xsl" />
<xsl:include href="formal.xsl" />
<xsl:include href="synop.xsl" />
<xsl:include href="verbatim.xsl" />

<!-- Other objects -->
<xsl:include href="footnote.xsl" />
<xsl:include href="force-inline.xsl" />
<xsl:include href="inline.xsl" />
<xsl:include href="math.xsl" />
<xsl:include href="qandaset.xsl" />
<xsl:include href="table.xsl" />

<!-- Cross references -->
<xsl:include href="xref.xsl" />

<!-- Lists -->
<xsl:include href="glossary.xsl" />
<xsl:include href="lists.xsl" />

<!-- Graphics -->
<xsl:include href="callout.xsl" />
<xsl:include href="graphics.xsl" />

<!-- Metadata -->
<xsl:include href="biblio.xsl" />
<xsl:include href="info.xsl" />
<xsl:include href="keywords.xsl" />
<xsl:include href="toc.xsl" />

<!-- Page layout -->
<xsl:include href="beginpage.xsl" />

<!-- Processing instructions -->
<xsl:include href="pi.xsl" />

<!-- ==================================================================== -->

<xsl:output method="xml" encoding="utf-8" standalone="yes" />
<!--
            doctype-public="-//Steve Cheng//DTD Texi-XML V0.8.4//EN"
            doctype-system="http://docbook2x.sf.net/latest/dtd/Texi-XML"
-->

<!-- ==================================================================== -->

<xsl:key name="id" match="*[@id]" use="@id" />

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

<xsl:template match="text()">
  <xsl:value-of select="."/> 
</xsl:template>

<!-- ==================================================================== -->

<doc:reference xmlns="">
<title>Texinfo XSLT stylesheets driver</title>
<partintro>

<para>
This file is the basic driver of the Texinfo XSLT stylesheets.  It
includes all the other stylesheet files.
</para>

<para>
You can use this stylesheet directly, or create your own custom
stylesheet that imports this one (or one of the other driver files):

<example>
<title>Importing stylesheets</title>

<programlisting>&lt;xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"&gt;

  &lt;xsl:import 
    href="http://docbook2x.sf.net/latest/xslt/texi/docbook.xsl" /&gt;

  <replaceable>&#x2026; your own stylesheet code goes here &#x2026;</replaceable>
    
&lt;/xsl:stylesheet&gt;</programlisting>
</example>

Importing the stylesheet allows you to specify stylesheet options and
customize the stylesheets without changing the standard stylesheets.
</para>
</partintro>
</doc:reference>

</xsl:stylesheet>
