<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:gt="http://docbook2x.sourceforge.net/xsl/gentext-title"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc gt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: inline.xsl,v 1.19 2007/02/25 21:18:58 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->
<doc:reference xmlns="">
<title>Inline markup</title>

<para>
These are the templates for character inline-level markup.
</para>

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
  <tt><xsl:copy-of select="$content"/></tt>
</xsl:template>

<xsl:template name="inline-bold-monospace">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <tt><b><xsl:copy-of select="$content"/></b></tt>
</xsl:template>

<xsl:template name="inline-italic-monospace">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <tt><i><xsl:copy-of select="$content"/></i></tt>
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
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline-superscript">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>^</xsl:text>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline-subscript">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>_</xsl:text>
  <xsl:copy-of select="$content"/>
</xsl:template>



<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="author">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="editor">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="othercredit">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="authorinitials">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="accel">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="action">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="application">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="classname">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="exceptionname">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="interfacename">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="methodname">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="code">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="command">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="computeroutput">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="constant">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="database">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="errorcode">
  <xsl:call-template name="inline-plain"/>
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
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="filename">
  <xsl:call-template name="inline-italic-monospace" />
</xsl:template>

<xsl:template match="refentrytitle/function">
  <xsl:call-template name="inline-bold-monospace" />
</xsl:template>

<xsl:template match="function">
  <xsl:choose>
    <xsl:when test="$function-parens
                    or parameter or function or replaceable">
      <xsl:variable name="nodes" select="text()|*"/>
      <xsl:call-template name="inline-bold-monospace">
        <xsl:with-param name="content">
          <xsl:apply-templates select="$nodes[1]"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$nodes[position()>1]"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline-bold-monospace"/>
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
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="keycode">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="keysym">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template name="inline-quoted">
  <xsl:param name="unconditional" select="false()" />
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:if test="$unconditional or $quotes-on-literals">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'literal-quote-start'" />
    </xsl:call-template>
  </xsl:if>
  
  <xsl:copy-of select="$content" />

  <xsl:if test="$unconditional or $quotes-on-literals">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'literal-quote-end'" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="inline-quoted-monospace">
  <xsl:param name="unconditional" select="false()" />
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:if test="$unconditional or $quotes-on-literals">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'literal-quote-start'" />
    </xsl:call-template>
  </xsl:if>
  
  <tt><xsl:copy-of select="$content" /></tt>
  
  <xsl:if test="$unconditional or $quotes-on-literals">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'literal-quote-end'" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="literal">
  <xsl:call-template name="inline-quoted-monospace" />
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
  <!-- Make this bold and monospace, except
       for embedded replacebles which should be italic and in
       proportional fonts. -->
  <xsl:for-each select="node()">
    <xsl:choose>
      <xsl:when test="self::replaceable">
        <xsl:call-template name="inline-italic" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="inline-bold-monospace">
          <xsl:with-param name="content">
            <xsl:apply-templates select="." />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="parameter">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="property">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="prompt">
  <xsl:call-template name="inline-bold" />
</xsl:template>

<xsl:template match="replaceable">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="returnvalue">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="structfield">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="structname">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="symbol">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="systemitem">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="token">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="type">
  <xsl:call-template name="inline-monospace"/>
</xsl:template>

<xsl:template match="userinput">
  <xsl:call-template name="inline-bold-monospace"/>
</xsl:template>

<xsl:template match="abbrev">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="acronym">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="citetitle">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="emphasis[@role='strong' or @role='bold' or parent::emphasis]">
  <xsl:call-template name="inline-bold"/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:call-template name="inline-italic" />
</xsl:template>

<xsl:template match="foreignphrase">
  <xsl:call-template name="inline-italic"/>
</xsl:template>

<xsl:template match="markup">
  <xsl:call-template name="inline-quoted-monospace" />
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
  <xsl:call-template name="inline-monospace"/>
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
  <xsl:call-template name="inline-italic"/>
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
      <xsl:call-template name="inline-monospace"/>
    </xsl:when>
    <xsl:when test="$class='attvalue'">
      <xsl:call-template name="inline-monospace"/>
    </xsl:when>
    <xsl:when test="$class='element'">
      <xsl:call-template name="inline-monospace"/>
    </xsl:when>
    <xsl:when test="$class='endtag'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&lt;/</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='genentity'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&amp;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='numcharref'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&amp;#</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='paramentity'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>%</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='pi'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&lt;?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='xmlpi'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&lt;?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='starttag'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&lt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='emptytag'">
      <xsl:call-template name="inline-monospace">
        <xsl:with-param name="content">
          <xsl:text>&lt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>/&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='sgmlcomment'">
      <xsl:call-template name="inline-monospace">
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
  <!-- Perhaps use &#x2039; / &#x203a;
               or  &#x3008; / &#x3009; instead ?
       They look better in printed output, but are 
       not cut-and-pastable into e-mail programs. -->
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="inline-monospace" />
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="keycombo">
  <xsl:for-each select="./*">
    <xsl:if test="position()>1">
      <!-- CHECKME: Is this the best way to allow customization ? -->
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="concat('keycombo.joinchar.',@action)" />
      </xsl:call-template>
    </xsl:if>

    <xsl:apply-templates/>
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
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'arg-choice-opt-start'" />
  </xsl:call-template>
  
  <xsl:call-template name="inline-plain"/>

  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'arg-choice-opt-end'" />
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

