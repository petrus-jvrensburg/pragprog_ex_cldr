<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version="2.0">            
<xsl:output indent="no"/>

   <xsl:template match="i" xml:space="default">
    <xsl:choose>
      <xsl:when test="@start-range">&#x200b;<fo:inline keep-with-previous="always"><rx:begin-index-range>
	  <xsl:attribute name="id">
	    <xsl:value-of select="@start-range"/>
	  </xsl:attribute>
	  <xsl:attribute name="rx:key">
	    <xsl:value-of select="@key"/>
	  </xsl:attribute>
	</rx:begin-index-range></fo:inline>&#x200b;</xsl:when>
      <xsl:when test="@end-range">&#x200b;<fo:inline keep-with-previous="always"><rx:end-index-range>
	  <xsl:attribute name="ref-id">
	    <xsl:value-of select="@end-range"/>
	  </xsl:attribute>
	</rx:end-index-range></fo:inline>&#x200b;</xsl:when>

      <xsl:otherwise>&#x200b;<fo:inline keep-with-previous="always">
	  <xsl:attribute name="rx:key">
	    <xsl:value-of select="@key"/>
	  </xsl:attribute>
	</fo:inline>&#x200b;</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- format the actual index listing -->

  <xsl:template match="index | ii-entry | iii-entry | i-see-list | i-see"/>

  <xsl:template match="index" mode="force">
    <fo:page-sequence
		      master-reference="index">
      <xsl:if test="$target.recto-verso-headings='no'">
        <xsl:attribute name="initial-page-number">auto-odd</xsl:attribute>
      </xsl:if>

      <xsl:call-template name="setup-page-headers"/>
      <xsl:call-template name="setup-page-footers"/>
      <xsl:call-template name="blank-page-setup"/>

      <fo:flow flow-name="xsl-region-body">

        <xsl:call-template name="chapter-heading">
          <xsl:with-param name="type"/>
          <xsl:with-param name="number"/>
          <xsl:with-param name="name">Index</xsl:with-param>
        </xsl:call-template>

	<rx:flow-section column-count="3">
	  <xsl:apply-templates/>
	</rx:flow-section>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <xsl:template match="index-listing">
    <fo:block-container
        font-size="80%"
        padding-left="0pt"
        padding-right="0pt"
        line-height="120%"
        text-align="left"
        start-indent="0pt"
        end-indent="0pt"
        >
      <xsl:call-template name="add-or-generate-id"/>

      <xsl:apply-templates />

    </fo:block-container>
  </xsl:template>



  <xsl:template match="alpha-head">
    <fo:block
        space-after="3pt"
        border-bottom="1.5pt solid silver"
        padding-bottom="-2.5pt"
        font-size="140%"
        color="{$color.index-alpha-heading}"
        keep-with-next="always">
      <xsl:choose>
	<xsl:when test="not(preceding-sibling::alpha-head)">
	  <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
	  <xsl:attribute name="space-before">6pt</xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="space-before">8pt</xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:value-of select="@heading"/>
    </fo:block>
    
    <xsl:apply-templates />
    
  </xsl:template>

  <xsl:template match="i-entry">
    <fo:block space-before="2pt" 
	      space-after="2pt" 
	      start-indent="1em"
	      text-indent="-1em"
	      >  
        <xsl:if test="following-sibling::i-entry and not(preceding-sibling::i-entry) and not(descendant::ii-entry)">
          <xsl:attribute name="keep-with-next">always</xsl:attribute>
        </xsl:if>   
 
        <xsl:if test="not(count(descendant::ii-entry) &gt; 2)">
          <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        </xsl:if>
      <xsl:if test="not(following-sibling::i-entry )and not(descendant::ii-entry)">
          <xsl:attribute name="keep-with-previous">always</xsl:attribute>
        </xsl:if>
       
      
        <fo:block keep-together.within-column="always">
          <xsl:apply-templates/>

        <!--   apparently see vs. see also depends not just on this entry but all child entries too -->

      <xsl:variable name="see-text">
	<xsl:choose>
	  <xsl:when test="@key-ref or ./ii-entry">
	    <xsl:text>see also</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>see</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="@key-ref">
          <xsl:text>, </xsl:text>
          <rx:page-index>
            <rx:index-item>
              <xsl:attribute name="ref-key">
                <xsl:value-of select="@key-ref"/>
              </xsl:attribute>
              <xsl:if test="$target.for-screen  = 'yes'">
                <xsl:attribute name="color">rgb(10, 10, 150)</xsl:attribute>
                <xsl:attribute name="link-back">true</xsl:attribute>
              </xsl:if>
            </rx:index-item>
          </rx:page-index>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="./i-see-list">
  <xsl:text>, </xsl:text>
	<fo:inline font-style="italic">
		  <xsl:value-of select="$see-text"/>
	  <xsl:text>&#160;</xsl:text>
	</fo:inline>
	<xsl:apply-templates select="i-see-list" mode="force"/>
      </xsl:if>
         </fo:block>
      <xsl:apply-templates select="./ii-entry" mode="force"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="ii-entry" mode="force">
    <fo:block margin-left="2em" keep-together.within-column="always">        
        <xsl:if test="not(following-sibling::ii-entry) or not(preceding-sibling::ii-entry)">
          <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
        </xsl:if>
       <xsl:apply-templates />
      <xsl:text>, </xsl:text>
        <rx:page-index>
        <rx:index-item>
          <xsl:attribute name="ref-key">
            <xsl:value-of select="@key-ref"/>
          </xsl:attribute>
             <xsl:if test="$target.for-screen  = 'yes'">
                <xsl:attribute name="color">rgb(10, 10, 150)</xsl:attribute>
                <xsl:attribute name="link-back">true</xsl:attribute>
              </xsl:if>
        </rx:index-item>
        </rx:page-index>
    </fo:block>
  </xsl:template>

  <xsl:template match="i-see-list" mode="force">
    <xsl:for-each select="./i-see">
      <xsl:if test="position() > 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:choose>
	<xsl:when test="@see">
	  <xsl:for-each select="id(@see)">
	    <xsl:apply-templates/>
	  </xsl:for-each>
	</xsl:when>
	<xsl:when test="@see-text">
	  <xsl:value-of select="@see-text"/>
	</xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
