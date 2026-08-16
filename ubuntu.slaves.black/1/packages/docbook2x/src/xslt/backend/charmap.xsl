<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: charmap.xsl,v 1.4 2004/08/13 01:33:39 stevecheng Exp $
     ********************************************************************

     (C) 2003-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X.  
     
     See ../../COPYING for the copyright status of this software.
     
     This is an pure XSLT 1.0 implementation of XSLT 2.0 character maps.
     (So this is essentially an XSLT version of utf8trans.)

     Note that we are NOT perfectly conformant to XSLT 2.0 character maps
     here:  in particular, we assume the character map is in one piece
     and we do not process any use-character-maps attributes.
     Use an external stylesheet to do this instead.
     
     ******************************************************************** -->

<!-- We absolutely must use keys, so that the time taken to apply
     character maps will not be linear in the size of the character map;
     the performance is bad enough as it is. -->

<xsl:key name="charmap-entry"
         match="xsl:output-character"
         use="@character" />
         
<xsl:template name="apply-character-map">
  <xsl:param name="content" select="''"/>
  <xsl:param name="character-map" select="false()" />

  <xsl:choose>
    <xsl:when test="$content = ''">
    </xsl:when>
  
    <xsl:when test="not($character-map)">
      <xsl:value-of select="$content" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="first-char" select="substring($content, 1, 1)" />
      <xsl:for-each select="$character-map">
        <xsl:variable name="charmap-entry" 
                      select="key('charmap-entry',$first-char)" /> 
        <xsl:choose>
          <xsl:when test="$charmap-entry">
            <xsl:value-of select="$charmap-entry[last()]/@string" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$first-char" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:call-template name="apply-character-map">
        <xsl:with-param name="content" select="substring($content, 2)" />
        <xsl:with-param name="character-map" select="$character-map" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
