<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            

  <xsl:attribute-set name="page-header-font">
    <xsl:attribute name="font-family"><xsl:value-of select="$page.header.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template name="setup-page-headers">
    <fo:static-content flow-name="even-header">
   <fo:block text-align-last="left"	xsl:use-attribute-sets="page-header-font">
       <xsl:if test="ancestor-or-self::chapter 
         or ancestor-or-self::appendix 
         or ancestor-or-self::recipe 
         or ancestor-or-self::bibsection 
         or self::part 
         ">
           <xsl:attribute name="start-indent">
             <xsl:value-of select="$flow-indent"/>
           </xsl:attribute>
       </xsl:if> 
      <fo:inline font-style="normal" font-variant="small-caps">
	      <fo:retrieve-marker>
	        <xsl:attribute name="retrieve-class-name">
	          <xsl:choose>
	            <xsl:when test="ancestor-or-self::chapter 
			  or ancestor-or-self::appendix 
			  or ancestor-or-self::recipe 
         or ancestor-or-self::bibsection">chapter-name</xsl:when>
	            <xsl:when test="self::part">part-name</xsl:when>
	            <xsl:otherwise>chapter-name</xsl:otherwise>
	          </xsl:choose>
	        </xsl:attribute>
	      </fo:retrieve-marker>
	    </fo:inline>
	    <fo:inline font-size="12pt"> • </fo:inline>
	    <fo:inline><fo:page-number/></fo:inline>
    </fo:block>  
    </fo:static-content>
    
    <fo:static-content flow-name="odd-header">
     <fo:block text-align-last="right"	xsl:use-attribute-sets="page-header-font">
       <xsl:if test="ancestor-or-self::chapter 
         or ancestor-or-self::appendix 
         or ancestor-or-self::recipe 
         or ancestor-or-self::bibsection 
         or self::part 
         ">
           <xsl:attribute name="end-indent">
             <xsl:value-of select="$flow-indent"/>
           </xsl:attribute>
       </xsl:if> 
 	    <fo:inline font-style="normal" font-variant="small-caps">
	<fo:retrieve-marker retrieve-class-name="section-name"/>
	</fo:inline>
	<fo:inline font-size="12pt"> • </fo:inline>
	<fo:inline><fo:page-number/></fo:inline>
      </fo:block>
    </fo:static-content>
    
    
    <fo:static-content flow-name="xsl-footnote-separator">
     <fo:block>
       <xsl:attribute name="color">
         <xsl:choose>
           <xsl:when test="$color = 'yes'"><xsl:value-of select="$color.heading-underline"></xsl:value-of></xsl:when>
           <xsl:otherwise>black</xsl:otherwise>
         </xsl:choose>
       </xsl:attribute>
        <xsl:attribute name="start-indent">
          <xsl:choose>
            <xsl:when test="ancestor-or-self::task">0pt</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$flow-indent"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
	<fo:leader leader-pattern="rule"
		   leader-length="15%"
		   rule-style="solid"
		   rule-thickness="0.25pt"/>
      </fo:block>
    </fo:static-content>
  </xsl:template>

  <!-- empty for paper -->
  <xsl:template name="setup-page-footers"/>
  <xsl:template name="blank-page-setup" />

  <xsl:template name="copyright-masthead">
    <xsl:choose>
      <xsl:when test="$color = 'yes'"><fo:external-graphic content-width="4in" 
       src="url(../PerBook/util/images/Bookshelf_4in.png)"/>
      </xsl:when>
      <xsl:when test="$booktype='airport'">
        <fo:external-graphic  content-width="2in"
       src="url(../PerBook/util/images/Bookshelf_BW_2in.png)"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:external-graphic  content-width="4in"
       src="url(../PerBook/util/images/Bookshelf_BW_4in.png)"/>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="cover-image">
      <xsl:text>_bw/images/</xsl:text>
		  <xsl:value-of select="bookcode"/>
		  <xsl:text>_72dpi.jpg</xsl:text>
  </xsl:template>

</xsl:stylesheet>
