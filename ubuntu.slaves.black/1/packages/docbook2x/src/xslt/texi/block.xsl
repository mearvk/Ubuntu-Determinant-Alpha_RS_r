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
     $Id: block.xsl,v 1.23 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************
     
     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Block-level objects</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="block-object">
  <para>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="para|simpara">
  <para>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="formalpara">
  <para>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="formalpara/title">
  <strong>
    <xsl:apply-templates />
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'run-in-title-separator'" />
    </xsl:call-template>
  </strong>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="formalpara/para">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="blockquote">
  <quotation>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
    <xsl:apply-templates select="attribution" mode="blockquote-attribution" />
  </quotation>
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

<!-- sidebar is not a chunk, because it can be mixed in
     within the other content of a section. -->
<xsl:template match="sidebar">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="abstract">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="msgset">
  <itemize>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </itemize>
</xsl:template>

<xsl:template match="msgentry">
  <listitem>
    <xsl:call-template name="anchor" />
  </listitem>
</xsl:template>

<xsl:template match="simplemsgentry">
  <listitem>
    <xsl:call-template name="anchor" />
  </listitem>
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
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="msglevel|msgorig|msgaud">
  <para>
    <xsl:call-template name="gentext-label" />
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="msgexplan">
  <xsl:call-template name="block-object"/>
</xsl:template>

<xsl:template match="msgexplan/title">
  <para><strong><xsl:apply-templates/></strong></para>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="revhistory">
  <xsl:call-template name="anchor" />
  <multitable>
    <colspec colnum="1" colwidth="2*" /><!-- revnumber -->
    <colspec colnum="1" colwidth="2*" /><!-- date -->
    <colspec colnum="1" colwidth="1*" /><!-- authorinitials -->
    <colspec colnum="1" colwidth="5*" /><!-- remarks -->

    <tbody>
      <xsl:apply-templates />
    </tbody>

  </multitable>
</xsl:template>
  
<xsl:template match="revhistory/revision">
  <xsl:variable name="revnumber" select=".//revnumber"/>
  <xsl:variable name="revdate"   select=".//date"/>
  <xsl:variable name="revauthor" select=".//authorinitials"/>
  <xsl:variable name="revremark" select=".//revremark|../revdescription"/>

  <row>
    <entry>
      <xsl:if test="$revnumber">
        <xsl:call-template name="gentext-title">
          <xsl:with-param name="content">
            <xsl:apply-templates select="$revnumber"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </entry>

    <entry>
      <xsl:apply-templates select="$revdate"/>
    </entry>

    <entry>
      <xsl:apply-templates select="$revauthor"/>
    </entry>

    <entry>
      <xsl:apply-templates select="$revremark"/>
    </entry>
  </row>
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
