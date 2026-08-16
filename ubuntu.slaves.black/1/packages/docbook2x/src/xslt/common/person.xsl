<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                version='1.0'
		xml:lang="en">

<!-- ********************************************************************
     $Id: person.xsl,v 1.2 2004/07/16 02:50:37 stevecheng Exp $
     ********************************************************************

     &copy; 2000-2001 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X.  person.name template.
     
     ******************************************************************** -->

<!-- ====================================================================== -->

<xsl:template name="person.name">
  <!-- Return a formatted string representation of the contents of
       the specified node (by default, the current element).
       Handles Honorific, FirstName, SurName, and Lineage.
       If %author-othername-in-middle% is #t, also OtherName
       Handles *only* the first of each.
       Format is "Honorific. FirstName [OtherName] SurName, Lineage"
  -->
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <!-- handle corpauthor as a special case...-->
    <xsl:when test="name($node)='corpauthor'">
      <xsl:apply-templates select="$node"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="h_nl" select="$node//honorific[1]"/>
      <xsl:variable name="f_nl" select="$node//firstname[1]"/>
      <xsl:variable name="o_nl" select="$node//othername[1]"/>
      <xsl:variable name="s_nl" select="$node//surname[1]"/>
      <xsl:variable name="l_nl" select="$node//lineage[1]"/>

      <xsl:variable name="has_h" select="$h_nl"/>
      <xsl:variable name="has_f" select="$f_nl"/>
      <xsl:variable name="has_o"
                    select="$o_nl and ($author-othername-in-middle != 0)"/>
      <xsl:variable name="has_s" select="$s_nl"/>
      <xsl:variable name="has_l" select="$l_nl"/>

      <xsl:if test="$has_h">
        <xsl:value-of select="$h_nl"/>.
      </xsl:if>

      <xsl:if test="$has_f">
        <xsl:if test="$has_h"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="$f_nl"/>
      </xsl:if>

      <xsl:if test="$has_o">
        <xsl:if test="$has_h or $has_f"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="$o_nl"/>
      </xsl:if>

      <xsl:if test="$has_s">
        <xsl:if test="$has_h or $has_f or $has_o">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$s_nl"/>
      </xsl:if>

      <xsl:if test="$has_l">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$l_nl"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template> <!-- person.name -->

<xsl:template name="person.name.list">
  <!-- Return a formatted string representation of the contents of
       the current element. The current element must contain one or
       more AUTHORs, CORPAUTHORs, OTHERCREDITs, and/or EDITORs.

       John Doe
     or
       John Doe and Jane Doe
     or
       John Doe, Jane Doe, and A. Nonymous
  -->
  <xsl:param name="person.list" select="./author|./corpauthor|./othercredit|./editor"/>
  <xsl:param name="person.count" select="count($person.list)"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>$person.count"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="person.name">
        <xsl:with-param name="node" select="$person.list[position()=$count]"/>
      </xsl:call-template>
      <xsl:if test="$count&lt;$person.count">
        <xsl:if test="$person.count>2">,</xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="$count+1=$person.count">and </xsl:if>
      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="$person.list"/>
        <xsl:with-param name="person.count" select="$person.count"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- person.name.list -->

</xsl:stylesheet>

