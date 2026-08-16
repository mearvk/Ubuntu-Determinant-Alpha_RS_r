<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: param.xsl,v 1.38 2006/04/15 14:56:45 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<doc:reference xmlns="">
<title>Stylesheet parameters</title>
<partintro>
<para>
Stylesheet parameters influence various aspects of the rendering.  They
can be set from the command line (the exact syntax depends on the XSLT
processor), or in a custom stylesheet.  
</para>

<para>
To set them in a custom stylesheet, simply copy the definition here and
change the <sgmltag class="attribute">select</sgmltag> attribute to
something else.
</para>

<para>
If a parameter for what you want to change does not exist, you can write
templates in the custom stylesheet instead.
</para>
</partintro>
</doc:reference>

<xsl:param name="user-message-prefix" select="'docbook2texi:'" />

<!-- ==================================================================== -->
<xsl:param name="captions-display-as-headings" select="false()" />
<doc:param name="captions-display-as-headings" xmlns="">
<refpurpose>Use heading markup for minor captions?</refpurpose>
<refdescription>
<para>If true, <sgmltag class="element">title</sgmltag>
content in some (formal) objects are rendered with the Texinfo
<markup>@<replaceable>heading</replaceable></markup> commands.
</para>
<para>
If false, captions are rendered as an emphasized paragraph.
</para>
</refdescription>
</doc:param>




<!-- ==================================================================== -->
<xsl:param name="links-use-pxref" select="true()" />

<doc:param name="links-use-pxref" xmlns="">
<refpurpose>Translate <sgmltag class="element">link</sgmltag> using
<markup>@pxref</markup></refpurpose>
<refdescription>
<para>
If true, <sgmltag class="element">link</sgmltag> is translated
with the hypertext followed by the cross reference in parentheses.
</para>
<para>
Otherwise, the hypertext content serves as the cross-reference name
marked up using <markup>@ref</markup>.  Typically info displays this
contruct badly.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="explicit-node-names" select="false()" />

<doc:param name="explicit-node-names" xmlns="">
<refpurpose>Insist on manually constructed Texinfo node
names</refpurpose>
<refdescription>
<para>
Elements in the source document can influence the Texinfo node name
generation specifying either a <sgmltag
class="attribute">xreflabel</sgmltag>, or for the sectioning elements,
a <sgmltag class="element">title</sgmltag> with <sgmltag
class="attribute">role='texinfo-node'</sgmltag> in the 
<sgmltag class="element"><replaceable>*</replaceable>info</sgmltag> container.
</para>

<para>
However, for the majority of source documents, explicit Texinfo node
names are not available, and the stylesheet tries to generate a
reasonable one instead, e.g. from the normal title of an element.  
The generated name may not be optimal.  If this option is set and the
stylesheet needs to generate a name, a warning is emitted and 
<function>generate-id</function> is always used for the name.
</para>

<para>
When the hashtable extension is not available, the stylesheet cannot
check for node name collisions, and in this case, setting this option
and using explicit node names are recommended.  
</para>

<para>
This option is not set (i.e. false) by default.
</para>

<note>
<para>The absolute fallback for generating node names is using the XSLT
function <function>generate-id</function>, and the stylesheet always
emits a warning in this case regardless of the setting of
<parameter>explicit-node-names</parameter>.</para>
</note>

</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="show-comments" select="true()"/>

<doc:param name="show-comments" xmlns="">
<refpurpose>Display <sgmltag>comment</sgmltag> elements?</refpurpose>
<refdescription>
<para>If true, comments will be displayed, otherwise they are suppressed.
Comments here refers to the <sgmltag>comment</sgmltag> element,
which will be renamed <sgmltag>remark</sgmltag> in DocBook V4.0,
not XML comments (&lt;-- like this --&gt;) which are unavailable.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="funcsynopsis-decoration" select="true()" />

<doc:param name="funcsynopsis-decoration" xmlns="">
<refpurpose>Decorate elements of a FuncSynopsis?</refpurpose>
<refdescription>
<para>If true, elements of the FuncSynopsis will be decorated (e.g. bold or
italic).  The decoration is controlled by functions that can be redefined
in a customization layer.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="function-parens" select="false()" />

<doc:param name="function-parens" xmlns="">
<refpurpose>Generate parentheses after a function?</refpurpose>
<refdescription>
<para>If true, the formatting of
a <sgmltag class="starttag">function</sgmltag> element will include
generated parenthesis.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="refentry-display-name" select="true()"/>

<doc:param name="refentry-display-name" xmlns="">
<refpurpose>Output NAME header before 'RefName'(s)?</refpurpose>
<refdescription>
<para>If true, a "NAME" section title is output before the list
of 'RefName's.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="manvolnum-in-xref" select="true()"/>

<doc:param name="manvolnum-in-xref" xmlns="">
<refpurpose>Output <sgmltag>manvolnum</sgmltag> as part of
<sgmltag>refentry</sgmltag> cross-reference?</refpurpose>
<refdescription>
<para>if true, the <sgmltag>manvolnum</sgmltag> is used when cross-referencing
<sgmltag>refentry</sgmltag>s, either with <sgmltag>xref</sgmltag>
or <sgmltag>citerefentry</sgmltag>.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="prefer-textobjects" select="true()" />

<doc:param name="prefer-textobjects" xmlns="">
<refpurpose>Prefer <sgmltag class="element">textobject</sgmltag>
over <sgmltag class="element">imageobject</sgmltag>?
</refpurpose>
<refdescription>
<para>
If true, the 
<sgmltag class="element">textobject</sgmltag>
in a <sgmltag class="element">mediaobject</sgmltag>
is preferred over any
<sgmltag class="element">imageobject</sgmltag>.
</para>

<para>
(Of course, for output formats other than Texinfo, you usually
want to prefer the <sgmltag class="element">imageobject</sgmltag>,
but Info is a text-only format.)
</para>

<para>
In addition to the values true and false, this parameter
may be set to <literal>2</literal> to indicate that
both the text and the images should be output.
You may want to do this because some Texinfo viewers
can read images.  Note that the Texinfo <markup>@image</markup>
command has its own mechanism for switching between text
and image output — but we do not use this here.
</para>

<para>
The default is true.
</para>

</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="semantic-decorations" select="true()" />

<doc:param name="semantic-decorations" xmlns="">
<refpurpose>Use Texinfo semantic inline markup?</refpurpose>
<refdescription>
<para>
If true, the semantic inline markup of DocBook is translated into
(the closest) Texinfo equivalent.  This is the default.
</para>

<para>
However, because the Info format is limited to plain text,
the semantic inline markup is often distinguished by using 
explicit quotes, which may not look good.  
You can set this option to false to suppress these.
(For finer control over the inline formatting, you can
use your own stylesheet.)
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="custom-localization-file" select="''" />

<doc:param name="custom-localization-file" xmlns="">
<refpurpose>URI of XML document containing custom localization data</refpurpose>
<refdescription>
<para>
This parameter specifies the URI of a XML document
that describes text translations (and other locale-specific information)
that is needed by the stylesheet to process the DocBook document.
</para>
<para>
The text translations pointed to by this parameter always
override the default text translations 
(from the internal parameter <parameter>localization-file</parameter>).
If a particular translation is not present here,
the corresponding default translation 
is used as a fallback.
</para>
<para>
This parameter is primarily for changing certain
punctuation characters used in formatting the source document.
The settings for punctuation characters are often specific
to the source document, but can also be dependent on the locale.
</para>
<para>
To not use custom text translations, leave this parameter 
as the empty string.
</para>
</refdescription>
</doc:param>

<xsl:param name="custom-l10n-data" 
           select="document($custom-localization-file)" />

<doc:param name="custom-l10n-data" xmlns="">
<refpurpose>XML document containing custom localization data</refpurpose>
<refdescription>
<para>
This parameter specifies the XML document
that describes text translations (and other locale-specific information)
that is needed by the stylesheet to process the DocBook document.
</para>

<para>
This parameter is internal to the stylesheet.
To point to an external XML document with a URI or a file name, 
you should use the <parameter>custom-localization-file</parameter>
parameter instead.
</para>

<para>
However, inside a custom stylesheet 
(<emphasis>not on the command-line</emphasis>)
this paramter can be set to the XPath expression
<literal>document('')</literal>,
which will cause the custom translations 
directly embedded inside the custom stylesheet to be read.
</para>
</refdescription>
</doc:param>



<!-- ==================================================================== -->
<xsl:param name="author-othername-in-middle" select="1"/>

<doc:param name="author-othername-in-middle" xmlns="">
<refpurpose>Is <sgmltag>othername</sgmltag> in <sgmltag>author</sgmltag> a
middle name?</refpurpose>
<refdescription>
<para>If true, the <sgmltag>othername</sgmltag> of an <sgmltag>author</sgmltag>
appears between the <sgmltag>firstname</sgmltag> and
<sgmltag>surname</sgmltag>.  Otherwise, <sgmltag>othername</sgmltag>
is suppressed.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="output-file" select="''" />
<doc:param name="output-file" xmlns="">
<refpurpose>Name of the Info file</refpurpose>
<refdescription>
<indexterm><primary>Texinfo metadata</primary></indexterm>
<para>This parameter specifies the name of the final Info file,
overriding the setting in the document itself and the automatic
selection in the stylesheet.  If the document is a <sgmltag
class="element">set</sgmltag>, this parameter has no effect. </para>
<important>
<para>
Do <emphasis>not</emphasis> include the <literal>.info</literal>
extension in the name.
</para>
</important>
<para>
(Note that this parameter has nothing to do with the name of
the <emphasis>Texi-XML output</emphasis> by the XSLT processor you 
are running this stylesheet from.)
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="directory-category" select="''" />

<doc:param name="directory-category" xmlns="">
<refpurpose>The categorization of the document in the Info directory</refpurpose>
<refdescription>
<indexterm><primary>Texinfo metadata</primary></indexterm>
<para>
This is set to the category that the document
should go under in the Info directory of installed Info files.
For example, <literal>General Commands</literal>.
</para>

<note>
<para>
Categories may also be set directly in the source document.
But if this parameter is not empty, then it always overrides the 
setting in the source document.
</para>
</note>

</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="directory-description" select="''" />

<doc:param name="directory-description" xmlns="">
<refpurpose>The description of the document in the Info directory</refpurpose>
<refdescription>
<indexterm><primary>Texinfo metadata</primary></indexterm>
<para>
This is a short description of the document that appears in
the Info directory of installed Info files.
For example, <literal>An Interactive Plotting Program.</literal>
</para>

<note>
<para>
Menu descriptions may also be set directly in the source document.
But if this parameter is not empty, then it always overrides the 
setting in the source document.
</para>
</note>

</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="index-category" select="'cp'"/>

<doc:param name="index-category" xmlns="">
<refpurpose>The Texinfo index to use</refpurpose>
<refdescription>
<para>The Texinfo index for <sgmltag class="element">indexterm</sgmltag>
and <sgmltag class="element">index</sgmltag> is specified using the
<sgmltag class="attribute">role</sgmltag> attribute.  If the above
elements do not have a <sgmltag class="attribute">role</sgmltag>, then
the default specified by this parameter is used.
</para>

<para>
The predefined indices are:

<variablelist>
<varlistentry>
<term><literal>c</literal></term>
<term><literal>cp</literal></term>
<listitem><para>Concept index</para></listitem>
</varlistentry>
<varlistentry>
<term><literal>f</literal></term>
<term><literal>fn</literal></term>
<listitem><para>Function index</para></listitem>
</varlistentry>
<varlistentry>
<term><literal>v</literal></term>
<term><literal>vr</literal></term>
<listitem><para>Variable index</para></listitem>
</varlistentry>
<varlistentry>
<term><literal>k</literal></term>
<term><literal>ky</literal></term>
<listitem><para>Keystroke index</para></listitem>
</varlistentry>
<varlistentry>
<term><literal>p</literal></term>
<term><literal>pg</literal></term>
<listitem><para>Program index</para></listitem>
</varlistentry>
<varlistentry>
<term><literal>d</literal></term>
<term><literal>tp</literal></term>
<listitem><para>Data type index</para></listitem>
</varlistentry>
</variablelist>

User-defined indices are not yet supported.
</para>

</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="qanda-defaultlabel">number</xsl:param>

<doc:param name="qanda-defaultlabel" xmlns="">
<refpurpose>Sets the default for defaultlabel on QandASet.</refpurpose>
<refdescription>
<para>If no defaultlabel attribute is specified on a QandASet, this
value is used. It must be one of the legal values for the defaultlabel
attribute.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="qandaset-generate-toc">1</xsl:param>

<doc:param name="qandaset-generate-toc" xmlns="">
<refpurpose>Is a Table of Contents created for QandASets?</refpurpose>
<refdescription>
<para>If true, a ToC is constructed for QandASets.
</para>
</refdescription>
</doc:param>

</xsl:stylesheet>

