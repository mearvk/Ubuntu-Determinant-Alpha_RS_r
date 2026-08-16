<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:exslt="http://exslt.org/common"
                xmlns:t="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc exslt"
                extension-element-prefixes="exslt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: db2x_texixml.xsl,v 1.3 2004/10/22 23:04:11 stevecheng Exp $
     ********************************************************************

     (C) 2003-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X, DocBook to man page conversion.
     This stylesheet is a pure-XSLT implementation of db2x_manxml.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<xsl:import href="string.xsl" />
<xsl:import href="charmap2.xsl" />

<!-- ****************************************************************** -->

<xsl:param name="character-map" 
           select="document('../../charmaps/texi-small.charmap.xml')" />
<xsl:param name="encoding" select="'us-ascii'" />

<!-- ****************************************************************** -->

<xsl:template match="t:texinfoset">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:output method="text" encoding="'us-ascii'" />

<!-- ****************************************************************** -->

<xsl:template match="t:para">
  <xsl:text>&#10;&#10;</xsl:text>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="t:quotation|t:cartouche|t:flushleft|t:flushright">
  <xsl:text>&#10;@</xsl:text>
  <xsl:value-of select="local-name(.)" />
  <xsl:text>&#10;</xsl:text>
  
  <xsl:apply-templates />

  <xsl:text>&#10;@end </xsl:text>
  <xsl:value-of select="local-name(.)" />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="text()">
  <!-- We want to normalize the space of text but
       without stripping the space which separates
       the rest of the text and an element.
       
       e.g. "Refer to <b>iconv</b>(1) for details..."
       must be rendered as "Refer to \fBiconv\fR(1) for details..."
  -->

  <!-- Test if the string begins with a space
       and the last thing is an element. -->
  <xsl:if test="preceding-sibling::*[position() = 1 and name() != '']
                and string-length(normalize-space(concat('X', .)))
                  = string-length(normalize-space(.))+2">
    <xsl:text> </xsl:text>
  </xsl:if>
  
  <xsl:call-template name="text-output-ns" />

  <!-- Test if the string ends with a space
       and the next thing is an element. -->
  <xsl:if test="following-sibling::*[position() = 1 and name() != '']
                and string-length(normalize-space(concat(., 'X')))
                  = string-length(normalize-space(.))+2">
    <xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template name="escape-node-name">
  <xsl:param name="content" />
  <xsl:value-of select="normalize-space(
                        translate($content, '().,:&#9;&#10;', '[]_;;  '))" />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="text()" mode="comment">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="t:comment">
  <xsl:call-template name="output-comment">
    <xsl:with-param name="lines">
      <xsl:apply-templates mode="comment" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="output-comment">
  <xsl:param name="lines" />
      
  <xsl:text>&#10;@c </xsl:text>
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
        <xsl:with-param name="replace" select="'@'" />
        <xsl:with-param name="with" select="'\@'" />
      </xsl:call-template>
      </xsl:with-param>
        <xsl:with-param name="replace" select="'{'" />
        <xsl:with-param name="with" select="'@{'" />
      </xsl:call-template>
      </xsl:with-param>
        <xsl:with-param name="replace" select="'}'" />
        <xsl:with-param name="with" select="'@}'" />
      </xsl:call-template>

    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template name="output-arg">
  <xsl:param name="content" select="." />
  
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content" select="$content" />
    <xsl:with-param name="replace" select="','" />
    <xsl:with-param name="with" select="'@comma{}'" />
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:xref|t:ref|t:pxref">
  <xsl:value-of select="concat('@', local-name(.))" />
  <xsl:text>{</xsl:text>

  <xsl:variable name="node">
    <xsl:call-template name="escape-node-name">
      <xsl:with-param name="content">
        <xsl:call-template name="text-output-ns">
          <xsl:with-param name="content" select="@node" />
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = $node"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-arg">
          <xsl:with-param name="content">
            <xsl:call-template name="text-output-ns" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="info-label">
    <xsl:choose>
      <xsl:when test="normalize-space(@infolabel) = $node"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-arg">
          <xsl:with-param name="content">
            <xsl:call-template name="text-output-ns" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="print-manual">
    <xsl:call-template name="output-arg">
      <xsl:with-param name="content">
        <xsl:call-template name="text-output-ns" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:value-of select="$node" />
    
  <xsl:choose>
    <xsl:when test="@file and @file != ancestor::texinfo/@file">
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$info-label" />
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$label" />
      <xsl:text>,</xsl:text>
      
      <xsl:call-template name="output-arg">
        <xsl:with-param name="content">
          <xsl:call-template name="text-output">
            <xsl:with-param name="content" select="@file" />
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:text>,</xsl:text>
      <xsl:value-of select="$print-manual" />
    </xsl:when>

    <xsl:when test="$label = '' and $info-label = ''"></xsl:when>
    <xsl:when test="$label = ''">
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$info-label" />
    </xsl:when>
    
    <xsl:otherwise>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$info-label" />
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$label" />
    </xsl:otherwise>
  </xsl:choose>
      
  <xsl:text>}</xsl:text>
</xsl:template>    

<!-- ****************************************************************** -->

<xsl:template match="t:uref">
  <xsl:variable name="url">
  </xsl:variable>
  
  <xsl:text>@url{</xsl:text>
  <xsl:call-template name="output-arg">
    <xsl:with-param name="content">
      <xsl:call-template name="text-output">
        <xsl:with-param name="content" select="@url" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:if test="string(.) != ''">
    <xsl:text>,</xsl:text>
  <!-- FIXME comma of nested commands is incorrectly escaped!!! -->
    <xsl:call-template name="output-arg">
      <xsl:with-param name="content">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:node">
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:menu">
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:sp">
</xsl:template>

<xsl:template match="t:page">
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:anchor">
  <xsl:text>@anchor{</xsl:text>
  <xsl:call-template name="escape-node-name">
    <xsl:with-param name="content">
      <xsl:call-template name="text-output-ns">
        <xsl:with-param name="content" select="@node" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:image">
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:indexterm">

  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class = 'c'"><xsl:text>cp</xsl:text></xsl:when>
      <xsl:when test="@class = 'f'"><xsl:text>fn</xsl:text></xsl:when>
      <xsl:when test="@class = 'v'"><xsl:text>vr</xsl:text></xsl:when>
      <xsl:when test="@class = 'k'"><xsl:text>ky</xsl:text></xsl:when>
      <xsl:when test="@class = 'p'"><xsl:text>pg</xsl:text></xsl:when>
      <xsl:when test="@class = 't'"><xsl:text>tp</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="@class" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>&#10;@</xsl:text>
  <xsl:value-of select="$class" />
  <xsl:text>index </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:printindex">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class = 'cp'"><xsl:text>c</xsl:text></xsl:when>
      <xsl:when test="@class = 'fn'"><xsl:text>f</xsl:text></xsl:when>
      <xsl:when test="@class = 'vr'"><xsl:text>v</xsl:text></xsl:when>
      <xsl:when test="@class = 'ky'"><xsl:text>k</xsl:text></xsl:when>
      <xsl:when test="@class = 'pg'"><xsl:text>p</xsl:text></xsl:when>
      <xsl:when test="@class = 'tp'"><xsl:text>t</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="@class" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>&#10;@printindex </xsl:text>
  <xsl:value-of select="$class" />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:b|t:i|t:r|t:t|t:code|t:samp|t:cite|t:email|t:dfn|t:file|t:sc|t:acronym|t:emph|t:strong|t:key|t:kbd|t:var|t:env|t:command|t:option|t:footnote">
  <xsl:value-of select="concat('@', local-name(.))" />
  <xsl:text>{</xsl:text>
  <xsl:apply-templates />
  <xsl:text>}</xsl:text>
</xsl:template>
  
<!-- ****************************************************************** -->

<xsl:template 
  match="t:chapter|t:section|t:subsection|t:subsubsection|
         majorheading|chapheading|heading|subheading|subsubheading|
         top|unnumbered|unnumberedsec|unnumberedsubsec|unnumberedsubsubsec|
         appendix|appendixsec|appendixsubsec|appendixsubsubsec">
  <xsl:value-of select="concat('@', local-name(.))" />
  <xsl:text> </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="text()" mode="no-markup">
  <xsl:call-template name="text-output-ns" />
</xsl:template>

<xsl:template match="t:*" mode="no-markup">
  <xsl:apply-templates mode="no-markup" />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:enumerate">
  <xsl:text>&#10;@enumerate </xsl:text>
  <xsl:value-of select="@begin" />
  <xsl:text>&#10;</xsl:text>

  <xsl:apply-templates />

  <xsl:text>&#10;@end enumerate&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:itemize">
  <xsl:choose>
    <xsl:when test="@markchar">
      <xsl:text>&#10;@itemize </xsl:text>
      <xsl:call-template name="text-output">
        <xsl:with-param name="content" select="@markchar" />
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;@itemize @w&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates />

  <xsl:text>&#10;@end itemize&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:varlist">
  <xsl:text>&#10;@table \@asis&#10;</xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;@end table&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:varlistentry">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="t:term[position() = 1]">
  <xsl:text>&#10;@item </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:term">
  <xsl:text>&#10;@itemx </xsl:text>
  <xsl:apply-templates />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="t:listitem">
  <xsl:text>&#10;@item&#10;</xsl:text>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="t:varlistentry/t:listitem">
  <xsl:apply-templates />
</xsl:template>

<!-- ****************************************************************** -->

<xsl:template match="t:example|t:display|t:format">
  <xsl:text>&#10;@</xsl:text>
  <xsl:value-of select="local-name(.)" />
  <xsl:text>&#10;</xsl:text>
  
  <xsl:apply-templates mode="verbatim" />

  <xsl:text>&#10;@end </xsl:text>
  <xsl:value-of select="local-name(.)" />
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="verbatim">
  <xsl:call-template name="text-output" />
</xsl:template>

<!-- ****************************************************************** -->
<!-- ****************************************************************** -->

<xsl:template name="texinfo-chunk">
  <xsl:param name="filename" />
  <xsl:param name="content" />

  <xsl:choose>
    <xsl:when test="element-available('exslt:document')">
      <exslt:document method="text" 
                      encoding="{$encoding}" 
                      href="{$filename}">
        <xsl:copy-of select="$content" />
      </exslt:document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template match="t:texinfo">

  <xsl:variable name="basename">
    <xsl:choose>
      <xsl:when test="@file">
        <xsl:value-of select="@file" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>untitled</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.texi</xsl:text>
  </xsl:variable>

  <xsl:call-template name="texinfo-chunk">
    <xsl:with-param name="filename">
      <xsl:value-of select="$basename" /><xsl:text>.texi</xsl:text>
    </xsl:with-param>

    <xsl:with-param name="content">
      <xsl:text>\input texinfo&#10;</xsl:text>
      <xsl:text>@setfilename </xsl:text>
      <xsl:value-of select="$basename" /><xsl:text>.info&#10;</xsl:text>
      <xsl:text>@documentencoding </xsl:text>
      <xsl:value-of select="$encoding" />
    
      <xsl:apply-templates />

      <xsl:text>&#10;</xsl:text>
    </xsl:with-param>
      
  </xsl:call-template>
</xsl:template>

<!-- ****************************************************************** -->

</xsl:stylesheet>
