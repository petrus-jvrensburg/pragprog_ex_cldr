<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:param name="heading.font.family">Myriad</xsl:param>
  <xsl:param name="page.header.font.family">Myriad</xsl:param>

 <xsl:param name="body.font.family">
    <xsl:choose>
      <xsl:when test="$booktype='pguide'">Palatino</xsl:when>
      <xsl:when test="$booktype='airport'">Palatino</xsl:when>
      <xsl:otherwise>Bookman</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="body.font.master">
    <xsl:choose>
      <xsl:when test="$booktype='airport'">8.7</xsl:when>
      <xsl:otherwise>9.7</xsl:otherwise>
  </xsl:choose>
  </xsl:param>

  <xsl:param name="body.font.size">
    <xsl:value-of select="$body.font.master"/><xsl:text>pt</xsl:text>
  </xsl:param>

  <xsl:param name="sans.font.family">Myriad</xsl:param>
  <xsl:param name="mono.font.family">Deja Vu Mono</xsl:param>
  <xsl:param name="cond.font.family">MyriadCond</xsl:param>
  <xsl:param name="bullet.font.family">Corbel</xsl:param>
  <xsl:param name="symbol.font.family">ZapfDingbatsStd</xsl:param>  <!-- this is our embeddable version -->

  <xsl:param name="inline.code.font.family">Deja Vu Sans</xsl:param>

  <xsl:param name="body.fontset">
    <xsl:value-of select="$body.font.family"/>
    <xsl:if test="$body.font.family != ''
      and $symbol.font.family  != ''">,</xsl:if>
    <xsl:value-of select="$symbol.font.family"/>
  </xsl:param>
</xsl:stylesheet>
