<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:exslt="http://exslt.org/common"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:m="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc exslt m saxon"
                extension-element-prefixes="exslt saxon"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: db2x_manxml.xsl,v 1.25 2006/04/23 14:44:52 stevecheng Exp $
     ********************************************************************

     (C) 2003-2006 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X, DocBook to man page conversion.
     This stylesheet is a pure-XSLT implementation of db2x_manxml.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<xsl:include href="string.xsl" />
<xsl:include href="charmap.xsl" />
<xsl:include href="man-table.xsl" />

<xsl:param name="character-map" 
           select="document('../../charmaps/roff.charmap.xml')" />
<xsl:param name="encoding" select="'utf-8'" />
<xsl:param name="output-dir" select="''" />

<xsl:strip-space
  elements="m:manpageset m:manpage 
            m:refnameline m:refname m:refpurpose 
            m:SS m:SH 
            m:para 
            m:TP m:TPtag m:TPitem m:TPauto 
            m:indent
            m:leftindent
            m:b m:i m:tt" />

<!-- ****************************************************************** -->

<xsl:template match="m:manpageset">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<!-- ****************************************************************** -->

<!-- 
     The method of trimming extra blank lines works
     similarly the same as the Perl implementation:
     decide based on what the preceding element or text node is. 
     It may be easier to study the Perl implementation first
     before trying to understand this.
-->
<xsl:template name="block-break">
  <xsl:variable name="ps" 
    select="(preceding-sibling::*[1] | preceding-sibling::text()[1])[last()]" />

  <xsl:choose>
    <xsl:when test="self::m:manpage or not(preceding-sibling::node())">
    </xsl:when>

    <xsl:when test="$ps/self::m:TP">
      <xsl:text>&#10;.PP&#10;</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::m:TPitem">
      <xsl:if test="$ps">
        <xsl:text>&#10;&#10;</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:when test="$ps/self::m:para">
      <xsl:choose>
        <xsl:when test="parent::m:entry">
          <xsl:text>&#10;&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#10;.PP&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- text node -->
    <xsl:when test="name($ps) = ''">
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:output method="text" encoding="utf-8" />

<xsl:template match="m:para">
  <xsl:call-template name="block-break" />
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="text()">
    <xsl:call-template name="mixed-inline-start" />
  
    <!-- We want to normalize the space of text but
         without stripping the space which separates
         the rest of the text and an element.
         
         e.g. "Refer to <b>iconv</b>(1) for details..."
         must be rendered as "Refer to \fBiconv\fR(1) for details..."
    -->
  
    <!-- Test if the string begins with a space
         and the last thing is an element. -->
    <xsl:if test="preceding-sibling::node()[position() = 1 and name() != '']
                  and string-length(normalize-space(concat('X', .)))
                    = string-length(normalize-space(.))+2">
      <xsl:text> </xsl:text>
    </xsl:if>
    
    <xsl:call-template name="disambiguate-hyphen-minus">
      <xsl:with-param name="content">
        <xsl:call-template name="text-output-ns" />
      </xsl:with-param>
    </xsl:call-template>
  
    <!-- Test if the string ends with a space
         and the next thing is an element. -->
    <xsl:if test="following-sibling::node()[position() = 1 and name() != '']
                  and string-length(normalize-space(concat(., 'X')))
                    = string-length(normalize-space(.))+2">
      <xsl:text> </xsl:text> 
    </xsl:if>
</xsl:template>


<!-- ****************************************************************** -->

<xsl:template match="text()" mode="comment">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="m:comment">
  <xsl:call-template name="output-comment">
    <xsl:with-param name="lines">
      <xsl:apply-templates mode="comment" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="output-comment">
  <xsl:param name="lines" />
      
  <xsl:text>&#10;.\" </xsl:text>
  <xsl:value-of select="substring-before($lines,'&#10;')"/>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:if test="contains($lines,'&#10;')">
    <xsl:call-template name="output-comment">
      <xsl:with-param name="lines"
           select="substring-after($lines,'&#10;')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
  

<!-- ****************************************************************** -->

<xsl:template name="disambiguate-hyphen-minus">
  <xsl:param name="content" select="." />
  <xsl:choose>
    <xsl:when test="ancestor-or-self::m:tt or ancestor-or-self::m:verbatim">
      <xsl:call-template name="string-subst">
        <xsl:with-param name="content" select="$content" />
        <xsl:with-param name="replace" select="'-'" />
        <xsl:with-param name="with"    select="'\-'" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="text-output-ns">
  <xsl:param name="content" select="." />
  <xsl:call-template name="text-output">
    <xsl:with-param name="content"
         select="translate(normalize-space($content), '&#10;', ' ')" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="text-output">
  <xsl:param name="content" select="." />

  <xsl:call-template name="apply-character-map">
    <xsl:with-param name="character-map" select="$character-map" />
    <xsl:with-param name="content">
    
      <xsl:call-template name="string-subst">
      <xsl:with-param name="content">
      <xsl:call-template name="string-subst">
      <xsl:with-param name="content">
      <xsl:call-template name="string-subst">
        <xsl:with-param name="content" select="$content" />
        <xsl:with-param name="replace" select="'\'" />
        <xsl:with-param name="with"    select="'\e'" />
      </xsl:call-template>
      </xsl:with-param>
        <xsl:with-param name="replace" select="'.'" />
        <xsl:with-param name="with"    select="'\&amp;.'" />
      </xsl:call-template>
      </xsl:with-param>
        <xsl:with-param name="replace"><xsl:text>'</xsl:text></xsl:with-param>
        <xsl:with-param name="with"><xsl:text>\&amp;'</xsl:text></xsl:with-param>
      </xsl:call-template>

    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template name="output-arg">
  <xsl:param name="content" select="''" />
  
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content" select="$content" />
    <xsl:with-param name="replace" select="' '" />
    <xsl:with-param name="with" select="'\ '" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="roff-request">
  <xsl:param name="name" />
  <xsl:param name="arg-1" />
  <xsl:param name="arg-2" />
  <xsl:param name="arg-3" />
  <xsl:param name="arg-4" />
  <xsl:param name="arg-5" />
  <xsl:param name="break" select="true()" />

  <!-- This is a hack, we make a list of exceptions
       where there is supposed to be no line break before
       the roff request.  It produces the desired result,
       but is not modular code. -->
  <xsl:variable name="ps" select="preceding-sibling::node()[1]" />
  <xsl:if test="not(self::m:manpage or not($ps) or
                $ps/self::m:SH or $ps/self::m:SS or 
                $ps/self::m:refnameline or $ps/self::m:verbatim or
                $ps/self::m:nh or $ps/self::m:br or $ps/self::m:sp)">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$break">
      <xsl:value-of select="concat('.', $name, ' ')" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(&quot;'&quot;, $name, ' ')" />
    </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="output-arg">
    <xsl:with-param name="content" select="$arg-1" />
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="output-arg">
    <xsl:with-param name="content" select="$arg-2" />
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="output-arg">
    <xsl:with-param name="content" select="$arg-3" />
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="output-arg">
    <xsl:with-param name="content" select="$arg-4" />
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="output-arg">
    <xsl:with-param name="content" select="$arg-5" />
  </xsl:call-template>

  <xsl:text>&#10;</xsl:text>
</xsl:template>


<!-- ****************************************************************** -->

<xsl:template match="m:sp">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'sp'" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:br">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'br'" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:indent">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'RS'" />
  </xsl:call-template>

  <xsl:apply-templates />
  
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'RE'" />
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template name="mixed-inline-start">
  <xsl:choose>
    <xsl:when test="preceding-sibling::m:TP">
      <xsl:text>&#10;.PP&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="preceding-sibling::m:para | preceding-sibling::m:verbatim">
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>
    
<xsl:template match="m:b">
  <xsl:call-template name="mixed-inline-start" />
  <xsl:text>\fB</xsl:text>
  <xsl:apply-templates />
  <xsl:text>\fR</xsl:text>
</xsl:template>

<xsl:template match="m:i">
  <xsl:call-template name="mixed-inline-start" />
  <xsl:text>\fI</xsl:text>
  <xsl:apply-templates />
  <xsl:text>\fR</xsl:text>
</xsl:template>

<xsl:template match="m:tt">
  <xsl:text>\*(T&lt;</xsl:text>
  <xsl:apply-templates />
  <xsl:text>\*(T&gt;</xsl:text>
</xsl:template>

<xsl:template match="m:b" mode="verbatim">
  <xsl:text>\fB</xsl:text>
  <xsl:apply-templates mode="verbatim" />
  <xsl:text>\fR</xsl:text>
</xsl:template>

<xsl:template match="m:i" mode="verbatim">
  <xsl:text>\fI</xsl:text>
  <xsl:apply-templates mode="verbatim" />
  <xsl:text>\fR</xsl:text>
</xsl:template>

<xsl:template match="m:tt" mode="verbatim">
  <xsl:apply-templates mode="verbatim" />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="m:ulink">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'URL'" />
    <xsl:with-param name="arg-1">
      <xsl:call-template name="text-output-ns">
        <xsl:with-param name="content" select="@url" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="arg-2">
      <xsl:apply-templates mode="no-markup" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:ulink" mode="no-markup">
  <xsl:apply-templates mode="no-markup" />
  <xsl:text> \(lq</xsl:text>
  <xsl:call-template name="text-output-ns">
    <xsl:with-param name="content" select="@url" />
  </xsl:call-template>
  <xsl:text>\(rq </xsl:text>
</xsl:template>

<xsl:template match="m:ulink" mode="verbatim">
  <xsl:apply-templates mode="no-markup" />
  <xsl:text>\(lq</xsl:text>
  <xsl:call-template name="text-output-ns">
    <xsl:with-param name="content" select="@url" />
  </xsl:call-template>
  <xsl:text>\(rq</xsl:text>
</xsl:template>

  
<!-- ****************************************************************** -->

<xsl:template match="m:SH">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'SH'" />
    <xsl:with-param name="arg-1">
      <xsl:apply-templates select="." mode="no-markup" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:SS">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'SS'" />
    <xsl:with-param name="arg-1">
      <xsl:apply-templates select="." mode="no-markup" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="text()" mode="no-markup">
  <xsl:call-template name="text-output-ns" />
</xsl:template>

<xsl:template match="m:*" mode="no-markup">
  <xsl:apply-templates mode="no-markup" />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="m:TP">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'TP'" />
    <xsl:with-param name="arg-1" select="@indent" />
  </xsl:call-template>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="m:TPtag">
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="m:TPitem">
  <xsl:apply-templates />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="m:verbatim">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'nf'" />
  </xsl:call-template>

  <xsl:apply-templates mode="verbatim" />

  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'fi'" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="text()" mode="verbatim">
  <xsl:call-template name="disambiguate-hyphen-minus">
    <xsl:with-param name="content">
      <xsl:call-template name="text-output" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="m:refnameline">
  <xsl:call-template name="block-break" />
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="m:refname">
  <xsl:if test="preceding-sibling::m:refname">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:apply-templates />
</xsl:template>

<xsl:template match="m:refpurpose">
  <xsl:text> \- </xsl:text>
  <xsl:apply-templates />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template name="manpage-filename">
  <xsl:param name="title" />
  <xsl:param name="sect" />
  
  <xsl:value-of select="translate(normalize-space($title), ' ', '_')" />
  <xsl:text>.</xsl:text>
  <xsl:value-of select="translate(normalize-space($sect), ' ', '_')" />
</xsl:template>

<xsl:template name="manpage-chunk">
  <xsl:param name="filename" />
  <xsl:param name="content" />

  <xsl:variable name="path">
    <xsl:choose>
      <xsl:when test="$output-dir = ''">
      </xsl:when>
      <xsl:when test="substring($output-dir, string-length($output-dir)) != '/'">
        <xsl:value-of select="concat($output-dir, '/')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$output-dir" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$filename" />
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="element-available('exslt:document')">
      <exslt:document method="text" 
                      encoding="{$encoding}" 
                      href="{$path}">
        <xsl:text>.\" -*- coding: </xsl:text>
        <xsl:value-of select="$encoding" />
        <xsl:text> -*-&#10;</xsl:text>
        <xsl:copy-of select="$content" />
      </exslt:document>
    </xsl:when>
    <xsl:when test="element-available('saxon:output')">
      <saxon:output method="text" 
                    encoding="{$encoding}" 
                    href="{$path}">
        <xsl:text>.\" -*- coding: </xsl:text>
        <xsl:value-of select="$encoding" />
        <xsl:text> -*-&#10;</xsl:text>
        <xsl:copy-of select="$content" />
      </saxon:output>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>

  <xsl:message>
    <xsl:value-of select="$path" />
  </xsl:message>

</xsl:template>
      
<xsl:template name="manpage-solink">
  <xsl:param name="title" />
  <xsl:param name="sect" />
  <xsl:param name="main-filename" />
                  
  <xsl:call-template name="manpage-chunk">
    <xsl:with-param name="filename">
      <xsl:call-template name="manpage-filename">
        <xsl:with-param name="title" select="$title" />
        <xsl:with-param name="sect"  select="$sect"  />
      </xsl:call-template>
    </xsl:with-param>

    <xsl:with-param name="content">
      <xsl:text>.so man</xsl:text>
  
      <!-- Want only the number of the section -->
      <xsl:value-of select="translate($sect,
              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '')" />

      <xsl:text>/</xsl:text>
      <xsl:value-of select="$main-filename" />
      <xsl:text>&#10;</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:manpage">

  <xsl:variable name="content">
    <!-- Definitions to get nicer Postscript output from groff,
         including URL macros -->
    <xsl:text
>.if \n(.g .ds T&lt; \\FC
.if \n(.g .ds T> \\F[\n[.fam]]
.de URL
\\$2 \(la\\$1\(ra\\$3
..
.if \n(.g .mso www.tmac
</xsl:text>

    <xsl:call-template name="roff-request">
      <xsl:with-param name="name" select="'TH'" />
      <xsl:with-param name="arg-1">
        <xsl:apply-templates select="@h1" mode="no-markup" />
      </xsl:with-param>
      <xsl:with-param name="arg-2">
        <xsl:apply-templates select="@h2" mode="no-markup" />
      </xsl:with-param>
      <xsl:with-param name="arg-3">
        <xsl:apply-templates select="@h3" mode="no-markup" />
      </xsl:with-param>
      <xsl:with-param name="arg-4">
        <xsl:apply-templates select="@h4" mode="no-markup" />
      </xsl:with-param>
      <xsl:with-param name="arg-5">
        <xsl:apply-templates select="@h5" mode="no-markup" />
      </xsl:with-param>
    </xsl:call-template>
      
    <xsl:apply-templates />
 </xsl:variable>

  <xsl:variable name="filename">
    <xsl:call-template name="manpage-filename">
      <xsl:with-param name="title" select="@title" />
      <xsl:with-param name="sect" select="@sect" />
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="manpage-chunk">
    <xsl:with-param name="filename" select="$filename" />
    <xsl:with-param name="content" select="$content" />
  </xsl:call-template>

  <xsl:if test="$solinks">
    <xsl:variable name="manpage-node" select="." />
  
    <xsl:for-each select="m:refnameline/m:refname">
      <xsl:if test="string(.) != string($manpage-node/@h1)">
        <xsl:call-template name="manpage-solink">
          <xsl:with-param name="main-filename" select="$filename" />
          <xsl:with-param name="title" select="." />
          <xsl:with-param name="sect"  select="$manpage-node/@h2" />
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:param name="solinks" select="false()" />

<!-- ****************************************************************** -->


<xsl:template match="m:nh">
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'nh'" />
    <xsl:with-param name="break" select="false()" />
  </xsl:call-template>
  <xsl:apply-templates />
  <xsl:call-template name="roff-request">
    <xsl:with-param name="name" select="'ny'" />
    <xsl:with-param name="break" select="false()" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="m:TPauto">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="m:TPauto/m:TPtag" priority="2.0">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="m:TPauto/m:TPitem" priority="2.0">
  <xsl:text>\kx&#10;</xsl:text>
  <xsl:text>.if (\nx>(\n(.l/2)) .nr x (\n(.l/5)&#10;</xsl:text>
  <xsl:text>'in \n(.iu+\nxu&#10;</xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;'in \n(.iu-\nxu)&#10;</xsl:text>
</xsl:template>


<!-- ****************************************************************** -->
</xsl:stylesheet>
