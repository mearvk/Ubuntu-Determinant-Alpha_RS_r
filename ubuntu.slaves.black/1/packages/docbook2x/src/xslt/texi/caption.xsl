<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY lsquo "&#x2018;">
<!ENTITY rsquo "&#x2019;">
<!ENTITY ldquo "&#x201C;">
<!ENTITY rdquo "&#x201D;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: caption.xsl,v 1.13 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Captions (really headings)</title>
</doc:reference>

<!-- ==================================================================== -->

<doc:template name="make-caption" xmlns="">
<refpurpose>Render as a &lsquo;caption&rsquo;</refpurpose>
<refdescription>
<para>
This template renders content (usually titles in certain block objects) 
as a &lsquo;caption&rsquo;.  What this exactly means depends on the value 
of the <varname>captions-display-as-headings</varname> parameter.
</para>
</refdescription>
<refparameter>
<variablelist>
<varlistentry>
<term><parameter>content</parameter></term>
<listitem><para>
The result tree fragment to render.  If not specified, defaults to
applying <function>for-title</function> mode to the 
<emphasis>context</emphasis> node.
</para></listitem>
</varlistentry>
</variablelist>
</refparameter>
</doc:template>

<xsl:template name="make-caption">
  <xsl:param name="content">
    <xsl:apply-templates select="." mode="for-title" />
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$captions-display-as-headings">
      <xsl:call-template name="make-texinfo-section">
        <xsl:with-param name="level">
          <xsl:call-template name="get-texinfo-section-level">
            <xsl:with-param name="heading-class" select="'chapheading'" />
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="title" select="$content" />
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <para>
        <strong>
          <xsl:copy-of select="$content" />
        </strong>
      </para>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    
<!-- ==================================================================== -->

</xsl:stylesheet>
