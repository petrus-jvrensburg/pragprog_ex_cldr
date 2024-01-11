<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>


  <!-- footnotes -->
  <xsl:template match="footnote">
    <xsl:variable name="fn-count">
      <xsl:number format="1" count="footnote" 
		  from="book" level="any"/>
    </xsl:variable>
    <sup>
    <a class="footnote">
      <xsl:attribute name="id">
	<xsl:text>FNPTR-</xsl:text>
	<xsl:value-of select="$fn-count"/>
      </xsl:attribute>
      <xsl:attribute name="href">
	<xsl:text>#FOOTNOTE-</xsl:text>
	<xsl:value-of select="$fn-count"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$fn-count"/>
      <xsl:text>]</xsl:text>
    </a>
    </sup>
  </xsl:template>

  <xsl:template name="dump-footnotes">
    <xsl:if test=".//footnote">
      <xsl:text>&#10;</xsl:text>
      <div class="footnotes">
	<xsl:text>&#10;</xsl:text>
	<h4>Footnotes</h4>
	<xsl:text>&#10;</xsl:text>
        <dl>
          <xsl:for-each select=".//footnote">
	    <xsl:text>&#10;</xsl:text>
	    <xsl:call-template name="output-footnote"/>
          </xsl:for-each>
        </dl>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="output-footnote">
    <xsl:variable name="fn-count">
      <xsl:number format="1" count="footnote" 
		  from="book" level="any"/>
    </xsl:variable>
    <dt class="footnote-number">
      <a>
	<xsl:attribute name="id">
	  <xsl:text>FOOTNOTE-</xsl:text>
	  <xsl:value-of select="$fn-count"/>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:text>#FNPTR-</xsl:text>
	  <xsl:value-of select="$fn-count"/>
	</xsl:attribute>
	<xsl:text>[</xsl:text>
	<xsl:value-of select="$fn-count"/>
	<xsl:text>]</xsl:text>
      </a>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>


</xsl:stylesheet>
