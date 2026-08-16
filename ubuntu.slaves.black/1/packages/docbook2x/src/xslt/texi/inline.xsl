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
     $Id: inline.xsl,v 1.34 2007/02/25 21:18:38 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->
<doc:reference xmlns="">
<title>Inline markup</title>
<partintro>
<para>
These are the templates for character inline-level markup.
</para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="inline-plain">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:copy-of select="$content"/>
</xsl:template>

<!-- ==================================================================== -->
<!-- Font changes -->
<!-- I've deleted the combination font changes since they are
     not visible in info anyways. -->

<xsl:template name="inline-monospace">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <t><xsl:copy-of select="$content"/></t>
</xsl:template>

<xsl:template name="inline-bold">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <b><xsl:copy-of select="$content"/></b>
</xsl:template>

<xsl:template name="inline-italic">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <i><xsl:copy-of select="$content"/></i>
</xsl:template>

<xsl:template name="inline-roman">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <r><xsl:copy-of select="$content"/></r>
</xsl:template>

<xsl:template name="inline-superscript">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <!-- We could use TeX mode to get an actual superscript,
       but it wouldn't display in Info anyway, and
       the formatting will never be correct:

       i) In a formula such as "e^x", both the $e$ and the $x$
          have to be typeset in math mode. (with
          italics for variables)

       ii) sometimes one uses a superscript for
           things like M^me or 3^rd, which obviously
           should not be typeset in math mode. -->
           
  <xsl:text>^</xsl:text><xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline-subscript">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>_</xsl:text><xsl:copy-of select="$content"/>
</xsl:template>


<!-- ==================================================================== -->
<!-- Texinfo semantic inline markup -->

<xsl:template name="inline-markup-emph">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <emph><xsl:copy-of select="$content"/></emph>
</xsl:template>

<xsl:template name="inline-markup-code">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <code><xsl:copy-of select="$content"/></code>
    </xsl:when>
    <xsl:otherwise>
      <t><xsl:copy-of select="$content" /></t>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-samp">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <samp><xsl:copy-of select="$content"/></samp>
    </xsl:when>
    <xsl:otherwise>
      <t><xsl:copy-of select="$content" /></t>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-cite">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <cite><xsl:copy-of select="$content"/></cite>
</xsl:template>

<xsl:template name="inline-markup-email">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <email><xsl:copy-of select="$content"/></email>
    </xsl:when>
    <xsl:otherwise>
      <t><xsl:copy-of select="$content" /></t>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-dfn">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <dfn><xsl:copy-of select="$content"/></dfn>
</xsl:template>

<xsl:template name="inline-markup-env">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <env><xsl:copy-of select="$content"/></env>
</xsl:template>

<xsl:template name="inline-markup-file">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <file><xsl:copy-of select="$content"/></file>
    </xsl:when>
    <xsl:otherwise>
      <t><xsl:copy-of select="$content" /></t>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-sc">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <sc><xsl:copy-of select="$content"/></sc>
</xsl:template>

<xsl:template name="inline-markup-acronym">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <acronym><xsl:copy-of select="$content"/></acronym>
</xsl:template>

<xsl:template name="inline-markup-strong">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <strong><xsl:copy-of select="$content"/></strong>
</xsl:template>

<xsl:template name="inline-markup-key">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <key><xsl:copy-of select="$content"/></key>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-kbd">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <kbd><xsl:copy-of select="$content"/></kbd>
    </xsl:when>
    <xsl:otherwise>
      <t><xsl:copy-of select="$content" /></t>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline-markup-var">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$semantic-decorations">
      <var><xsl:copy-of select="$content"/></var>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:copy-of select="$content" /></i>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ==================================================================== -->
<!-- These contain a person's name, 
     and must be displayed in a special way -->

<xsl:template match="personname">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="author|editor|othercredit|authorinitials">
  <xsl:call-template name="person.name"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="accel">
  <xsl:call-template name="inline-markup-kbd"/>
</xsl:template>

<xsl:template match="action">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="application">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="classname">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="exceptionname">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="interfacename">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="methodname">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="command">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="computeroutput">
  <xsl:call-template name="inline-markup-samp"/>
</xsl:template>

<xsl:template match="constant">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="database">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="errorcode">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="errorname">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="errortype">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="errortext">
  <xsl:call-template name="inline-plain"/>
</xsl:template>


<xsl:template match="envar">
  <xsl:call-template name="inline-markup-env"/>
</xsl:template>

<xsl:template match="filename">
  <xsl:call-template name="inline-markup-file"/>
</xsl:template>

<xsl:template match="refentrytitle/function">
  <xsl:call-template name="inline-plain" />
</xsl:template>

<xsl:template match="function">
  <xsl:choose>
    <xsl:when test="$function-parens
                    or parameter or function or replaceable">
      <xsl:variable name="nodes" select="text()|*"/>
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:apply-templates select="$nodes[1]"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$nodes[position()>1]"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:call-template name="inline-markup-code"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="guibutton|guiicon|guilabel|guimenu|guimenuitem|guisubmenu">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="hardware">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="interface">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="interfacedefinition">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="keycap">
  <xsl:call-template name="inline-markup-key"/>
</xsl:template>

<xsl:template match="keycode">
  <xsl:call-template name="inline-markup-key"/>
</xsl:template>

<xsl:template match="keysym">
  <xsl:call-template name="inline-markup-key"/>
</xsl:template>

<xsl:template match="literal">
  <xsl:call-template name="inline-markup-samp"/>
</xsl:template>

<xsl:template match="medialabel">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="shortcut">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="mousebutton">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="option">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="parameter">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="property">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="prompt">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="replaceable">
  <xsl:call-template name="inline-markup-var"/>
</xsl:template>

<xsl:template match="returnvalue">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="structfield">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="structname">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="symbol">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="systemitem">
  <xsl:call-template name="inline-markup-samp"/>
</xsl:template>

<xsl:template match="token">
  <xsl:call-template name="inline-markup-samp"/>
</xsl:template>

<xsl:template match="type">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="userinput">
  <xsl:call-template name="inline-markup-samp"/>
</xsl:template>

<xsl:template match="abbrev">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="acronym">
  <xsl:call-template name="inline-markup-acronym"/>
</xsl:template>

<xsl:template match="citerefentry">
  <!-- Don't want any decorations on cite text -->
  <xsl:apply-templates mode="no-inline-markup" />
</xsl:template>

<xsl:template match="citetitle">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="code">
  <xsl:call-template name="inline-markup-code" />
</xsl:template>

<xsl:template match="emphasis[@role='strong' or @role='bold' or parent::emphasis]">
  <xsl:call-template name="inline-markup-strong"/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:call-template name="inline-markup-emph"/>
</xsl:template>

<xsl:template match="foreignphrase">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="markup">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="phrase">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="quote">
  <xsl:variable name="depth" select="ancestor::quote" />

  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'quote-start'" />
      </xsl:call-template>
      <xsl:call-template name="inline-plain"/>
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'quote-end'" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'nested-quote-start'" />
      </xsl:call-template>
      <xsl:call-template name="inline-plain"/>
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'nested-quote-end'" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="varname">
  <xsl:call-template name="inline-markup-code"/>
</xsl:template>

<xsl:template match="wordasword">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="lineannotation">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="superscript">
  <xsl:call-template name="inline-superscript"/>
</xsl:template>

<xsl:template match="subscript">
  <xsl:call-template name="inline-subscript"/>
</xsl:template>

<xsl:template match="trademark">
  <xsl:call-template name="inline-plain"/>
  <xsl:text>&#x2122;</xsl:text><!-- trademark character -->
</xsl:template>

<xsl:template match="firstterm">
  <xsl:call-template name="inline-markup-dfn" />
</xsl:template>

<xsl:template match="glossterm">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="sgmltag">
  <xsl:call-template name="format-sgmltag"/>
</xsl:template>

<xsl:template name="format-sgmltag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$class='attribute'">
      <xsl:call-template name="inline-markup-code"/>
    </xsl:when>
    <xsl:when test="$class='attvalue'">
      <xsl:call-template name="inline-markup-code"/>
    </xsl:when>
    <xsl:when test="$class='element'">
      <xsl:call-template name="inline-markup-code"/>
    </xsl:when>
    <xsl:when test="$class='endtag'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;/</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='genentity'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&amp;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='numcharref'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&amp;#</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='paramentity'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>%</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='pi'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='xmlpi'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='starttag'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='emptytag'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>/&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='sgmlcomment'">
      <xsl:call-template name="inline-markup-code">
        <xsl:with-param name="content">
          <xsl:text>&lt;!--</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>--&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline-plain"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="email">
  <xsl:call-template name="inline-markup-email" />
</xsl:template>

<xsl:template match="keycombo">
  <xsl:for-each select="./*">

    <!-- FIXME: A hack -->
    <xsl:if test="position()>1 and ../@action='simul'">
      <xsl:text> + </xsl:text>
    </xsl:if>
    <xsl:if test="position()>1 and ../@action='seq'">
      <xsl:text>, </xsl:text>
    </xsl:if>

    <xsl:apply-templates select="." />
  </xsl:for-each>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="menuchoice">
  <xsl:variable name="shortcut" select="./shortcut"/>
  <xsl:call-template name="format-menuchoice"/>
  <xsl:if test="$shortcut">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="$shortcut"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="format-menuchoice">
  <xsl:param name="nodelist" select="guibutton|guiicon|guilabel|guimenu|guimenuitem|guisubmenu|interface"/><!-- not(shortcut) -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($nodelist)"></xsl:when>
    <xsl:when test="$count=1">
      <xsl:apply-templates select="$nodelist[$count=position()]"/>
      <xsl:call-template name="format-menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node" select="$nodelist[$count=position()]"/>
      <xsl:choose>
        <xsl:when test="$node/self::guimenuitem or $node/self::guisubmenu">
          <xsl:text>-&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>+</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$node"/>
      <xsl:call-template name="format-menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="optional">

  <xsl:call-template name="gentext-title">
    <xsl:with-param name="key" select="optional" />
    <xsl:with-param name="content">
      <xsl:call-template name="inline-plain" />
    </xsl:with-param>
  </xsl:call-template>
      
</xsl:template>

<xsl:template match="citation">
  <!-- todo: biblio-citation-check -->
  <xsl:text>[</xsl:text>
  <xsl:call-template name="inline-plain"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="comment|remark">
  <xsl:if test="$show-comments">
    <i>
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'remark'" />
        <xsl:with-param name="content">
          <xsl:apply-templates />
        </xsl:with-param>
      </xsl:call-template>
    </i>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="productname|productnumber">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="pob|street|city|state|postcode|country|phone|fax|otheraddr">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="firstname|surname|lineage|othername|honorific">
  <xsl:call-template name="inline-plain" />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

