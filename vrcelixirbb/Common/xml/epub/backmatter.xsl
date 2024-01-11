<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0">

  <xsl:attribute-set name="adpagetitle">
    <xsl:attribute name="font-family">MyriadCond</xsl:attribute>
    <xsl:attribute name="font-size">34pt</xsl:attribute>
    <xsl:attribute name="border-bottom">4pt solid darkgray</xsl:attribute>
    <xsl:attribute name="padding-bottom">-15.25pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="adtitle">
    <xsl:attribute name="font-family">MyriadCond</xsl:attribute>
    <xsl:attribute name="font-size">24pt</xsl:attribute>
    <xsl:attribute name="border-bottom">2pt solid gray</xsl:attribute>
    <xsl:attribute name="padding-bottom">-10.75pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="adcontent">
    <xsl:attribute name="font-family">Bookman</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="padding-top">4pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="adlink">
    <xsl:attribute name="font-family">Myriad</xsl:attribute>
    <xsl:attribute name="font-size">7pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="backmatter-sect2">
    <xsl:attribute name="font-family">Myriad</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template match="backmatter">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Added backmatter and related elements. -->


  <xsl:template match="ads">
    <xsl:apply-templates/>
  </xsl:template>


  
  <xsl:template match="bookcode | author-list">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pagecount"/>

  <xsl:template match="person">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="name">
    <xsl:apply-templates/>
    <xsl:if test="parent::person/following-sibling::person/name">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="price"/>
 
  <xsl:template match="sect1" mode="backmatter">
    <xsl:apply-templates mode="backmatter"/>
    </xsl:template>
 
  <xsl:template match="sect2" mode="backmatter">
    <xsl:apply-templates mode="backmatter"/>
    </xsl:template>


  <xsl:template match="table" mode="backmatter">
    <xsl:call-template name="table"/>
  </xsl:template>
  

 
  <xsl:template match="li" mode="backmatter">
    <xsl:text> • </xsl:text>
    <xsl:apply-templates mode="backmatter"/>
  </xsl:template>

  <xsl:template match="p" mode="backmatter">
    <xsl:choose>
      <xsl:when test="ancestor::li">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="add-or-generate-id"/>
          <xsl:if test="not(ancestor::ol[@style='compact'] or ancestor::ul[@style='compact'])">
            <xsl:attribute name="space-after">6pt</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="add-id"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="backsheet"/>
  <xsl:template match="permissions"/>
  

</xsl:stylesheet>
