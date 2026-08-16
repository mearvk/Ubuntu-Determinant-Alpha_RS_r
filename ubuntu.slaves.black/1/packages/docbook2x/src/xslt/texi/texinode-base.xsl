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
     $Id: texinode-base.xsl,v 1.25 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Low-level Texinfo node handling</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="make-nodenamemap">
  <nodenamemap>
    <xsl:apply-templates select="/*" mode="nodenamemap" />
  </nodenamemap>
</xsl:template>

<xsl:template match="*" mode="nodenamemap">
  <xsl:variable name="is-node">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>
  <xsl:variable name="is-top-node">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>
  
  <xsl:if test="@id != '' or $is-node = '1' or $is-top-node = '1'">
    <xsl:text>&#10;</xsl:text><!-- Make output easier to read -->
    <nodenamemapentry>
      <xsl:attribute name="id">
        <xsl:call-template name="print-id" />
      </xsl:attribute>

      <xsl:attribute name="file">
        <xsl:call-template name="get-texinfo-file-name" />
      </xsl:attribute>
      
      <nodename>
        <xsl:apply-templates select="." mode="for-texinfo-node-name" />
      </nodename>
    </nodenamemapentry>
  </xsl:if>

  <xsl:apply-templates mode="nodenamemap" />
</xsl:template>

<xsl:template match="text()" mode="nodenamemap">
</xsl:template>



<!-- ==================================================================== -->
<!-- Node statement -->

<doc:template name="make-texinfo-node" xmlns="">
<refpurpose>Output node element</refpurpose>
<refdescription>
<para>
This named template creates a node element in the result tree, 
which corresponds to the Texinfo <literal>@node</literal> command.
</para>
</refdescription>
</doc:template>

<xsl:template name="make-texinfo-node">
  
  <!-- Safeguard code -->
  <xsl:variable name="is-node">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>
  <xsl:if test="$is-node = ''">
    <xsl:call-template name="user-message">
      <xsl:with-param name="key">make-texinfo-node called for non-node</xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:variable name="is-top-node">
    <xsl:apply-templates select="." mode="is-texinfo-top-node" />
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$is-top-node = '1'">
      <xsl:call-template name="make-texinfo-top-node" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="make-texinfo-nontop-node" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="make-texinfo-nontop-node">

  <xsl:variable name="isprevnode">
    <xsl:apply-templates select="preceding-sibling::*[1]"
                         mode="is-texinfo-node" />
  </xsl:variable>
  <xsl:variable name="isnextnode">
    <xsl:apply-templates select="following-sibling::*[1]"
                         mode="is-texinfo-node" />
  </xsl:variable>
  <xsl:variable name="isparenttopnode">
    <xsl:apply-templates select=".."
                         mode="is-texinfo-top-node" />
  </xsl:variable>

  <!-- If this is the first 'subnode' of the parent node, then
       the parent node will end here, so make a menu.
  -->
  <xsl:if test="$isprevnode = ''">
    <xsl:apply-templates select=".." mode="texinfo-menu" />
  </xsl:if>

  <node>
    <xsl:attribute name="id">
      <xsl:call-template name="print-id" />
    </xsl:attribute>

    <xsl:choose>
      <xsl:when test="$isprevnode = '1'">
        <xsl:attribute name="previousid">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select="preceding-sibling::*[1]" />
          </xsl:call-template>
        </xsl:attribute>
      </xsl:when>

      <xsl:when test="$isparenttopnode = '1'">
        <xsl:attribute name="previousid">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select=".." />
          </xsl:call-template>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="$isnextnode = '1'">
      <xsl:attribute name="nextid">
        <xsl:call-template name="print-id">
          <xsl:with-param name="node" select="following-sibling::*[1]" />
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>

    <xsl:attribute name="upid">
      <xsl:call-template name="print-id">
        <xsl:with-param name="node" select=".." />
      </xsl:call-template>
    </xsl:attribute>
  </node>
</xsl:template>


<xsl:template name="make-texinfo-top-node">
  <node>
    <xsl:attribute name="id">
      <xsl:call-template name="print-id" />
    </xsl:attribute>

    <xsl:attribute name="previousid">
    </xsl:attribute>

    <xsl:attribute name="nextid">
      <xsl:call-template name="make-texinfo-top-node-firstchild">
        <xsl:with-param name="node" select="child::*[1]" />
      </xsl:call-template>
    </xsl:attribute>
  </node>
</xsl:template>

<!-- More recursive loops, because XSLT 1.0 cannot use
     templates as functions. -->
<xsl:template name="make-texinfo-top-node-firstchild">
  <xsl:param name="node" />
  <xsl:variable name="is-node">
    <xsl:apply-templates select="$node"
                         mode="is-texinfo-node" />
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not($node)">
    </xsl:when>
    
    <xsl:when test="$is-node = '1'">
      <xsl:call-template name="print-id">
        <xsl:with-param name="node" select="$node" />
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="make-texinfo-top-node-firstchild">
        <xsl:with-param name="node" select="$node/following-sibling::*[1]" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      

</xsl:stylesheet>

