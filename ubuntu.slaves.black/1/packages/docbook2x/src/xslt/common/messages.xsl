<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
                xmlns:exslt="http://exslt.org/common"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="doc saxon exslt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: messages.xsl,v 1.14 2004/08/18 14:24:27 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X.  Facilitates L10Nized user messages.
                         
     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:param name="message-language" select="'en'" />

<!-- ==================================================================== -->

<xsl:template name="l10n-message-choose-language">
  <xsl:param name="key" />
  <xsl:param name="languages" select="$message-language" />
  <xsl:variable name="first" select="
    translate(substring-before($languages, ':'),
              'ABCDEFGHIJKLMNOPQRSTUVWXYZ_',
              'abcdefghijklmnopqrstuvwxyz-')" />

  <xsl:choose>
    <xsl:when test="$first = ''">
      <xsl:value-of select="$languages" />
    </xsl:when>
  
    <xsl:when test="$l10n-data/l:locale[@lang=$first]/l:message[@key=$key]">
      <xsl:value-of select="$first" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="l10n-message-choose-language">
        <xsl:with-param name="key" select="$key" />
        <xsl:with-param name="languages" 
                        select="substring-after($languages, ':')" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="l:a1" mode="l10n-substitution">
  <xsl:param name="arg-1" />
  <xsl:value-of select="$arg-1" />
</xsl:template>
<xsl:template match="l:a2" mode="l10n-substitution">
  <xsl:param name="arg-2" />
  <xsl:value-of select="$arg-2" />
</xsl:template>
<xsl:template match="l:a3" mode="l10n-substitution">
  <xsl:param name="arg-3" />
  <xsl:value-of select="$arg-3" />
</xsl:template>
<xsl:template match="l:a4" mode="l10n-substitution">
  <xsl:param name="arg-4" />
  <xsl:value-of select="$arg-4" />
</xsl:template>
<xsl:template match="l:a5" mode="l10n-substitution">
  <xsl:param name="arg-5" />
  <xsl:value-of select="$arg-5" />
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="user-message" xmlns="">
  <refpurpose>Emit a user message</refpurpose>
  <refdescription>
    <para>
      This template is used in place of <function>xsl:message</function>.
       It traces the path of the given node to help in debugging and allows
       messages to be localized.
    </para>
  </refdescription>
  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>node</parameter></term>
        <listitem><para>
          The node to get to trace the path to.
          Default is the context node.
        </para></listitem>
      </varlistentry>
      <varlistentry>
        <term><parameter>arg</parameter></term>
        <listitem><para>
          Additional string argument to message, if any.
        </para></listitem>
      </varlistentry>
      <varlistentry>
        <term><parameter>key</parameter></term>
        <listitem><para>
          The standard message text.  If a localization/customization
          exists, it is keyed under this text and displayed instead
          of the standard message text.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="user-message">
  <xsl:param name="node" select="." />
  <xsl:param name="trace-node" select="true()" />
  <xsl:param name="arg-1" />
  <xsl:param name="arg-2" />
  <xsl:param name="arg-3" />
  <xsl:param name="arg-4" />
  <xsl:param name="arg-5" />
  <xsl:param name="key" />
  <xsl:param name="content" />

  <xsl:variable name="lang">
    <xsl:call-template name="l10n-message-choose-language">
      <xsl:with-param name="key" select="$key" />
    </xsl:call-template>
  </xsl:variable>

  <xsl:message>
    <xsl:value-of select="$user-message-prefix" />
  
    <xsl:if test="$trace-node">
      <xsl:choose>
        <xsl:when test="function-available('saxon:system-id')
                          and function-available('saxon:line-number')">
          <xsl:call-template name="print-node-line-number">
            <xsl:with-param name="node" select="$node" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="print-node-xpath">
            <xsl:with-param name="node" select="$node" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>: </xsl:text>
    </xsl:if>

    <xsl:variable 
      name="message"
      select="($l10n-data/l:locale[@lang=$lang]/l:message[@key=$key])[last()]" />

    <xsl:choose>
      <xsl:when test="$message">
        <xsl:apply-templates select="$message/node()" 
                             mode="l10n-substitution">
          <xsl:with-param name="arg-1" select="$arg-1" />
          <xsl:with-param name="arg-2" select="$arg-2" />
          <xsl:with-param name="arg-3" select="$arg-3" />
          <xsl:with-param name="arg-4" select="$arg-4" />
          <xsl:with-param name="arg-5" select="$arg-5" />
        </xsl:apply-templates>
      </xsl:when>

      <xsl:when test="$content != '' and function-available('exslt:node-set')">
        <xsl:apply-templates select="exslt:node-set($content)/node()" 
                             mode="l10n-substitution">
          <xsl:with-param name="arg-1" select="$arg-1" />
          <xsl:with-param name="arg-2" select="$arg-2" />
          <xsl:with-param name="arg-3" select="$arg-3" />
          <xsl:with-param name="arg-4" select="$arg-4" />
          <xsl:with-param name="arg-5" select="$arg-5" />
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$key" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:message>
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="print-node-line-number" xmlns="">
  <refpurpose>Display file name and line number of a node</refpurpose>
  <refdescription>
    <para>
      This template displays the file name and 
      the line number in that file that contains the given node.
      In addition the name of the given node is shown in parentheses
      (usually the element name).
      The output is suitable for diagnostics to the user.
    </para>

    <para>
      (“filename” means the “filename” part of the URI of the 
      containing entity.)  
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>node</parameter></term>
        <listitem><para>
          The node to get to print the information for.
          Default is the context node.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="print-node-line-number">
  <xsl:param name="node" select="." />
  <xsl:for-each select="$node">
    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="contains(saxon:system-id(), '/')">
          <xsl:call-template name="substring-after-last">
            <xsl:with-param name="content" select="saxon:system-id()" />
            <xsl:with-param name="search"  select="'/'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="saxon:system-id()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$filename" />
    <xsl:text>:</xsl:text>

    <xsl:value-of select="saxon:line-number()" />
    <xsl:text>(</xsl:text>
    <xsl:value-of select="name(.)" />
    <xsl:text>)</xsl:text>
  </xsl:for-each>
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="print-node-xpath" xmlns="">
  <refpurpose>Display the path of a node</refpurpose>
  <refdescription>
    <para>
      This template displays the address of the given node in 
      XPath notation, in a compact yet unambiguous form
      suitable for diagnostics to the user.
    </para>

    <para>
      It assumes that ID attributes are named 
      <sgmltag class="attribute">id</sgmltag>, and if an element
      has an ID defined, then the element will be addressed using
      that ID, instead of a long XPath starting from the root.
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>node</parameter></term>
        <listitem><para>
          The node to get to trace the path to.
          Default is the context node.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="print-node-xpath">
  <xsl:param name="node" select="." />
  <xsl:apply-templates select="$node" mode="print-node-xpath" />
</xsl:template>

<xsl:template match="text()" mode="print-node-xpath">
  <xsl:apply-templates select=".." mode="print-node-xpath" />
</xsl:template>

<xsl:template match="@*" mode="print-node-xpath">
  <xsl:apply-templates select=".." mode="print-node-xpath" />
  <xsl:value-of select="concat('/@', name(), &quot;='&quot;, string(.), &quot;'&quot;)" />
</xsl:template>

<xsl:template match="*[@id != '']" mode="print-node-xpath">
  <xsl:value-of select="concat('//', name(), &quot;[@id='&quot;, @id, &quot;']&quot;)" />
</xsl:template>

<xsl:template match="*" mode="print-node-xpath">
  <xsl:apply-templates select=".." mode="print-node-xpath" />
  <xsl:value-of select="concat('/', name())" />
  <xsl:if test="count(../*[name() = name(current())]) &gt; 1">
    <xsl:value-of select="concat('[',
      count(preceding-sibling::*[name() = name(current())])+1,
          ']')" />
  </xsl:if>
</xsl:template>

<xsl:template match="/" mode="print-node-xpath">
</xsl:template>
   
</xsl:stylesheet>

