<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>


  <xsl:template match="bibliography">
    <xsl:if test="$bib/*">
    <dl class="bibliography">
      <xsl:for-each select="$bib/*">
	<dt id="{generate-id()}">
	  <xsl:text>[</xsl:text>
	  <xsl:value-of select="@label"/>
	  <xsl:text>]</xsl:text>
	</dt>
	<dd>
	   <xsl:apply-templates select="bib-line"/>
	</dd>
      </xsl:for-each>
    </dl>
    </xsl:if>
  </xsl:template>

   <xsl:template match="bib-line">
    <xsl:apply-templates/>
  </xsl:template>




  <xsl:template match="articlename | bookname">
    <xsl:choose>
      <!-- if a citation is present... -->
      <xsl:when test="@cite">
	<xsl:variable name="cite" select="@cite"/>
	<xsl:choose>
	  <!-- make sure it's in the bibliography -->
	  <xsl:when test="not(//bibliography)">   
	    <xsl:message>
	      Missing bibliography entry for <xsl:value-of select="@cite"/>
	    </xsl:message>
	    <xsl:call-template name="bib-ref-content">
	      <xsl:with-param name="cite" select="$cite"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:when test="$bib/*[@tag=$cite]">
       <a href="#{generate-id($bib/*[@tag=$cite][1])}">
	    <xsl:call-template name="bib-ref-content">
	      <xsl:with-param name="cite" select="$cite"/>
	    </xsl:call-template>
       </a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      Missing bibliography entry for <xsl:value-of select="@cite"/>
	    </xsl:message>
	    <em class="highlight">
	      Missing bibliography entry for <xsl:value-of select="@cite"/>
	    </em>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<em><xsl:apply-templates/></em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="bib-ref-content">
    <xsl:param name="cite"/>
    	    <!-- if the bookname tag has no content, supply from bibliography -->

            <em>
	      <xsl:choose>
		<xsl:when test="text()">
		  <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:for-each select="$bib/*[@tag=$cite]//title">
		    <xsl:apply-templates>
		    </xsl:apply-templates>
		  </xsl:for-each>
		</xsl:otherwise>
	      </xsl:choose>
	    </em>

	    <!-- generate the cross reference -->
	    <xsl:text>&#160;[</xsl:text>
	    <xsl:value-of select="$bib/*[@tag=$cite]/@label"/>
	    <xsl:text>]</xsl:text>

  </xsl:template>


</xsl:stylesheet>