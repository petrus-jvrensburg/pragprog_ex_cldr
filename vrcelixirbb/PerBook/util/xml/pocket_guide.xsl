<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:template match="task">
    <xsl:choose>
      <xsl:when test="parent::book or parent::part">
        <xsl:call-template name="task-page-sequence"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="task"/>   
      </xsl:otherwise>
    </xsl:choose>              
  </xsl:template>
  
  <xsl:template name="task-page-sequence">
    <fo:page-sequence master-reference="task"
                      xsl:use-attribute-sets="guide-task-page-sequence">
      <xsl:call-template name="setup-page-headers"/>
      <xsl:call-template name="setup-page-footers"/>     
      <xsl:call-template name="blank-page-setup"/>
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="task"/>
      </fo:flow>
    </fo:page-sequence>
    
  </xsl:template>
  
  <xsl:template name="task">
    <xsl:choose>
      <xsl:when test="not(//bookinfo[@booktype='pguide'])">
        <fo:block>
          <xsl:text>
            Use the task element only in a Pragmatic Guide.
          </xsl:text>
        </fo:block>
      </xsl:when>

      <xsl:otherwise>
        <fo:block width="4in"
                  keep-together.within-page="always"
                  page-break-before="always"
                  padding-before="17.5pt"
                  padding-before.conditionality="retain"
                  padding-after="6pt">
          <xsl:attribute name="id">
            <xsl:call-template name="get-or-generate-id"/>
          </xsl:attribute>

          <xsl:if test="not(ancestor::chapter)">
            <fo:marker marker-class-name="chapter-name">
              <xsl:choose>
                <xsl:when test="ancestor::chapter">
                  <xsl:apply-templates select="ancestor::chapter/title"
                                       mode="force"/>
                </xsl:when>
                <xsl:when test="ancestor::part">
                  <xsl:apply-templates select="ancestor::part/title"
                                       mode="force"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="title" mode="force"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:marker>
          </xsl:if>

          <fo:marker marker-class-name="section-name">
            <xsl:apply-templates select="title" mode="force"/>
          </fo:marker>

          <fo:block>
            <xsl:attribute name="start-indent">
              <xsl:choose>
                <xsl:when test="ancestor::chapter">
                  <xsl:text>0.25in</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>0in</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>

            <fo:instream-foreign-object keep-with-next="always">
            <svg version="1.1"
                 id="Layer_1"
                 xmlns="http://www.w3.org/2000/svg"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                 x="0px" y="0px"
                 width="500px" height="41.877px"
                 viewBox="0 0 500 41.877"
                 enable-background="new 0 0 500 41.877"
	         xml:space="preserve">
              <path fill="white"
                    stroke="darkgray"
                    stroke-width="2"
                    stroke-miterlimit="10"
                    d="M497.75,26.787
                       c0,7.866-5.969,14.241-13.327,14.241
                       H14.344
                       c-7.362,0-13.329-6.375-13.329-14.241
                       V15.315
                       c0-7.865,5.966-14.239,13.329-14.239
                       h470.164
                       c7.361,0,13.327,6.374,13.327,14.239
                       L497.75,26.787z"/>
              <path  fill="darkgray"
                     stroke="darkgray"
                     stroke-width="2"
                     stroke-miterlimit="10" d="M58.136,26.788c0,7.866-4.152,14.24-9.277,14.24H10.291
	                                                                                          c-5.124,0-9.276-6.374-9.276-14.24V15.314c0-7.864,4.152-14.238,9.276-14.238h38.568c5.125,0,9.277,6.374,9.277,14.238V26.788z"/>
              <text transform="matrix(1 0 0 1 23.7593 27.1792)"
                    fill="white"
                    stroke="white"
                    stroke-miterlimit="10"
                    font-family="{$heading.font.family}"
                    font-size="21"><xsl:number from="mainmatter" level="any" count="task"/></text>
              <text transform="matrix(1 0 0 1 75 27.1792)"
                    fill="black"
                    stroke="black"
                    font-family="{$heading.font.family}"
                    font-size="21"><xsl:apply-templates select="title" mode="force"/></text>
            </svg>
          </fo:instream-foreign-object>
          </fo:block>
        </fo:block>
        <xsl:apply-templates select="why-it-works"/>
        <xsl:apply-templates select="what-to-do"/>
        <xsl:apply-templates select="*[not(self::why-it-works) and not(self::what-to-do)]"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template match="why-it-works">
    <fo:block font-size="9.5pt" >
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="what-to-do">
    <fo:block page-break-before="always" font-size="9.5pt" >
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="step">
    <fo:list-block start-indent="-0.4in"
                   provisional-distance-between-starts="0.4in"
                   provisional-label-separation="0.1in">
      <xsl:call-template name="add-or-generate-id"/>
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()" text-align="end">
          <fo:block font-family="{$symbol.font.family}"> 
            <xsl:attribute name="color">
              <xsl:choose>
                <xsl:when test="$target.for-screen='no'">black</xsl:when>
                <xsl:otherwise>blue</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:text>&#x27A4;</xsl:text>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()" text-align="start">
          <fo:block font-family="{$sans.font.family}" font-size="10.5pt" space-after="6pt">
            <xsl:apply-templates select="title" mode="force"/>
          </fo:block>
          <fo:block>
            <xsl:apply-templates/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="related-tasks">
    <fo:block xsl:use-attribute-sets="format-for-sect1-title">
      <xsl:text>Related Tasks:</xsl:text>
    </fo:block>
    <fo:list-block  start-indent="-0.1in" provisional-distance-between-starts="0.4in"
                    provisional-label-separation="2pt">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="related-tasks/li">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
	<fo:block text-align="right">
	  •
	</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<fo:block>
	  <xsl:apply-templates/>
	</fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

</xsl:stylesheet>
