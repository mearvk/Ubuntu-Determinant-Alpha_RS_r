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
     $Id: block.xsl,v 1.7 2007/02/25 21:12:28 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Block-level objects</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="block-object">
  <para>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template name="indented.block-object">
  <indent>
    <xsl:apply-templates/>
  </indent>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="para|simpara">
  <para>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="formalpara">
  <xsl:call-template name="run-in-para">
    <xsl:with-param name="heading">
      <xsl:apply-templates select="title/node()" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="formalpara/para">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="run-in-para">
  <xsl:param name="heading" />
  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>

  <xsl:param name="separator">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'run-in-title-separator'" />
    </xsl:call-template>
  </xsl:param>

  <para>
    <b>
      <xsl:copy-of select="$heading" />
    </b>
    <xsl:copy-of select="$separator" />
    <xsl:copy-of select="$content" />
  </para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="blockquote">
  <indent>
    <xsl:apply-templates/>
    <xsl:apply-templates select="attribution" mode="blockquote-attribution" />
  </indent>
</xsl:template>

<xsl:template match="blockquote/title">
  <xsl:call-template name="make-caption" />
</xsl:template>

<xsl:template match="attribution"></xsl:template>
<xsl:template match="attribution" mode="blockquote-attribution">
  <para>&#x2014; <xsl:apply-templates /></para>
  <!-- FIXME: need i18n for #x2014=&mdash? -->
</xsl:template>

<xsl:template match="epigraph">
  <xsl:apply-templates />
  <xsl:apply-templates select="attribution" mode="blockquote-attribution" />
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="sidebar">
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="abstract">
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="msgset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgentry">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="simplemsgentry">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="msg">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="msgmain">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgmain/title">
  <strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="msgsub">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgsub/title">
  <strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="msgrel">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgrel/title">
  <strong><xsl:apply-templates/></strong>
</xsl:template>

<xsl:template match="msgtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msginfo">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="msglevel|msgorig|msgaud">
  <xsl:call-template name="make-caption">
    <xsl:with-param name="content">
      <xsl:call-template name="gentext-title"/>
      <xsl:text>: </xsl:text><!-- FIXME -->
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="msgexplan">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="msgexplan/title">
  <para><strong><xsl:apply-templates/></strong></para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="revhistory">
  <multitable distribution=".33 .33 .33">
    <xsl:apply-templates />
  </multitable>
</xsl:template>
  
<xsl:template match="revhistory/revision">
  <xsl:variable name="revnumber" select=".//revnumber"/>
  <xsl:variable name="revdate"   select=".//date"/>
  <xsl:variable name="revauthor" select=".//authorinitials"/>
  <xsl:variable name="revremark" select=".//revremark|../revdescription"/>

  <item />
  <xsl:if test="$revnumber">
    <xsl:call-template name="gentext-title"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="$revnumber"/>
  </xsl:if>
  
  <tab />
  <xsl:apply-templates select="$revdate"/>

  <tab />
  <xsl:if test="count($revauthor)!=0">
    <xsl:apply-templates select="$revauthor"/>
  </xsl:if>

  <xsl:if test="$revremark">
    <item />
      <xsl:apply-templates select="$revremark"/>
  </xsl:if>
</xsl:template>

<xsl:template match="revision/revnumber">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/date">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/authorinitials">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/authorinitials[1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/revremark">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/revdescription">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="ackno">
  <xsl:call-template name="block-object" />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
