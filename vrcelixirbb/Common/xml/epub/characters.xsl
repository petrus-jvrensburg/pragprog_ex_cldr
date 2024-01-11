<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>

  <xsl:template match="text()">
    <xsl:variable name="translate-emdash">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">—</xsl:with-param>
        <xsl:with-param name="from">---</xsl:with-param>
        <xsl:with-param name="string" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-open-quote">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">“</xsl:with-param>
        <xsl:with-param name="from">``</xsl:with-param>
        <xsl:with-param name="string" select="$translate-emdash"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-open-single-quote">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">‘</xsl:with-param>
        <xsl:with-param name="from">`</xsl:with-param>
        <xsl:with-param name="string" select="$translate-open-quote"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-close-quote">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">”</xsl:with-param>
        <xsl:with-param name="from">''</xsl:with-param>
        <xsl:with-param name="string" select="$translate-open-single-quote"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-close-single-quote">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">’</xsl:with-param>
        <xsl:with-param name="from">'</xsl:with-param>
        <xsl:with-param name="string" select="$translate-close-quote"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-open-single-quote-entity">
      <xsl:call-template name="string-replace">
        <!-- backtick -->
        <xsl:with-param name="to">`</xsl:with-param>
        <xsl:with-param name="from">&#9998;</xsl:with-param>
        <xsl:with-param name="string" select="$translate-close-single-quote"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-pencil-entity">
      <xsl:call-template name="string-replace">
        <!-- mapsto -->
        <xsl:with-param name="to">→</xsl:with-param>
        <xsl:with-param name="from">&#9999;</xsl:with-param>
        <xsl:with-param name="string" select="$translate-open-single-quote-entity"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-checkmark">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">
          <span>✓</span>
        </xsl:with-param>
        <xsl:with-param name="from">✓</xsl:with-param>
        <xsl:with-param name="string" select="$translate-pencil-entity"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="extended">
      <xsl:call-template name="extended">
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-checkmark"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>


    <xsl:copy-of select="$extended"/>
  </xsl:template>

  <xsl:template name="extended">
    <xsl:param name="string"/>
   <xsl:analyze-string select="$string" regex="([&#x100;-&#x2FF;]+|[&#x370;-&#x58F;]+|[&#x1D00;-&#x1DBF;]+|[&#x1E00;-&#x1FFF;]+|[&#x20AC;]+|[&#x2100;-&#x243F;]+|[&#x2460;-&#x27BF;]+|[&#x2C60;-&#x2C7F;]+|[&#x2F00;-&#xFE4F;]+|[&#xFF00;-&#xFFEF;]+|[&#xFFF9;-&#xFFFD;]+)">
      <xsl:matching-substring>
        <xsl:choose>
         <xsl:when test="matches(.,'[&#x2E80;-&#xFE4F;]+|[&#xFF00;-&#xFFEF;]+')">
            <span style="font-family:Mincho;"><xsl:value-of select="."/></span>
          </xsl:when>
          <xsl:when test="matches(.,'[&#x100;-&#x2FF;]+|[&#x370;-&#x58F;]+|[&#x1D00;-&#x1DBF;]+|[&#x1E00;-&#x1FFF;]+|[&#x20AC;]+|[&#x2100;-&#x243F;]+|[&#x2460;-&#x27BF;]+|[&#x2C60;-&#x2C7F;]+|[&#xFFF9;-&#xFFFD;]+')">
            <span style="font-family:Quivira;"><xsl:value-of select="."/></span>
          </xsl:when>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="vspace">
    <span class="vspace">&#x2423;</span>
  </xsl:template>


</xsl:stylesheet>
