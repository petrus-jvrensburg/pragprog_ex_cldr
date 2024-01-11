<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>

  <xsl:param name="bullets">
    <xsl:text>&#x2460;</xsl:text>
    <xsl:text>&#x2461;</xsl:text>
    <xsl:text>&#x2462;</xsl:text>
    <xsl:text>&#x2463;</xsl:text>
    <xsl:text>&#x2464;</xsl:text>
    <xsl:text>&#x2465;</xsl:text>
    <xsl:text>&#x2466;</xsl:text>
    <xsl:text>&#x2467;</xsl:text>
    <xsl:text>&#x2468;</xsl:text>
    <xsl:text>&#x2469;</xsl:text>
    <xsl:text>&#x246A;</xsl:text>
    <xsl:text>&#x246B;</xsl:text>
    <xsl:text>&#x246C;</xsl:text>
    <xsl:text>&#x246D;</xsl:text>
    <xsl:text>&#x246E;</xsl:text>
    <xsl:text>&#x246F;</xsl:text>
    <xsl:text>&#x2470;</xsl:text>
    <xsl:text>&#x2471;</xsl:text>
    <xsl:text>&#x2472;</xsl:text>
    <xsl:text>&#x2473;</xsl:text>
  </xsl:param>
  
  <xsl:template match="ul">
    <ul>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="dl">
    <dl>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="ol">
    <ol>
      <!-- <xsl:if test="@start != 1"> -->
      <!--   <xsl:attribute name="start"> -->
      <!--     <xsl:value-of select="@start"/> -->
      <!--   </xsl:attribute> -->
      <!-- </xsl:if> -->
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match="li">
    <li>
      <xsl:call-template name="add-id"/>
      <xsl:choose>
        <xsl:when test="../@style = 'compact'">
          <xsl:for-each select="*">
            <xsl:choose>
              <xsl:when test="local-name() = 'p' and position() = 1">
                <xsl:apply-templates select="node()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="dt">
    <dt>
      <xsl:call-template name="add-id"/>
      <xsl:choose>
	<xsl:when test="@newline = 'yes'">
	  <xsl:attribute name="class">force-newline</xsl:attribute>
	</xsl:when>
      </xsl:choose> 
      <xsl:choose>
           <xsl:when test="parent::dl/@style = 'bold'">
	           <xsl:attribute name="style">font-weight:bold;</xsl:attribute>
           </xsl:when>
           <xsl:when test="parent::dl/@style = 'plain'"/>
           <xsl:when test="parent::dl/@style = 'italic'">
	           <xsl:attribute name="style">font-style:italic;</xsl:attribute>
           </xsl:when>
           <xsl:otherwise>
	           <xsl:attribute name="style">font-style:italic;</xsl:attribute>
           </xsl:otherwise>
         </xsl:choose>
     <!--    <xsl:choose>
           <xsl:when test="parent::dl/@style = 'bold'">
	          <strong><xsl:apply-templates/></strong>
           </xsl:when>
           <xsl:when test="parent::dl/@style = 'plain'"><xsl:apply-templates/></xsl:when>
           <xsl:when test="parent::dl/@style = 'italic'">
             <em><xsl:apply-templates/></em>
           </xsl:when>
           <xsl:otherwise>
             <em><xsl:apply-templates/></em>
           </xsl:otherwise>
         </xsl:choose> --> 
    <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <xsl:template match="dd">
    <dd>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>


  <xsl:template match="calloutlist">
    <dl class="calloutlist">
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="callout[not(ancestor::codeline)]">
    <dt>
      <xsl:call-template name="coref"/>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template name="coref">
    <xsl:variable name="target" select="id(@linkend)"/>
    <xsl:variable name="index"  select="$target/@calloutno"/>
    <xsl:call-template name="callout-number">
      <xsl:with-param name="number">       
        <xsl:value-of select="count($target/ancestor-or-self::codeline/preceding-sibling::codeline/@calloutno) 
          + count($target/ancestor-or-self::codeline/preceding-sibling::codeline/callout) + 1"/>
     </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="callout-number"><xsl:param name="number"/>&#x200b;<span class="callout-number" style="font-family:Quivira;"><xsl:value-of select="substring($bullets, number($number), 1)"/></span>&#x200b;</xsl:template>
  

</xsl:stylesheet>
