<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            


  <xsl:template name="draw-cover">
    <xsl:if test="$sitb = 'yes' ">
         <fo:page-sequence master-reference="cover" format="i" initial-page-number="1" >
      <fo:flow flow-name="xsl-region-body">
        <fo:block 
		  line-stacking-strategy="max-height"  
		  margin="0pt"
		  padding-top="-3pt"
		  padding-bottom="-5.5pt"
		  text-align="center"
		  ><!--  -->
    <xsl:attribute name="id">
      <xsl:text>cover</xsl:text>
      <xsl:call-template name="get-or-generate-id"/>
    </xsl:attribute>          
	  <xsl:variable name="width">
	    <xsl:value-of select="$page.width.number"/><xsl:text>in</xsl:text>
	  </xsl:variable>
    <xsl:variable name="height">
       <xsl:value-of select="$page.height.number + .01"/><xsl:text>in</xsl:text>
    </xsl:variable>      
         <fo:external-graphic 
				 overflow="hidden"
				 src="url(images/cover.jpg)"
				 scaling="non-uniform"  content-width="{$width}"
				 content-height="{$height}"
				 />  
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
