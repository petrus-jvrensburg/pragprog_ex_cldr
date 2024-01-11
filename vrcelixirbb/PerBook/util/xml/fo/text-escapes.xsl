<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:str="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  version="2.0">


  <xsl:template match="text()">
    <xsl:call-template name="text-escapes">
      <xsl:with-param name="text">
        <xsl:copy-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="text-escapes">
    <xsl:param name="text"/>
    <xsl:variable name="translate-phi">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3c6;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3c6;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:value-of select="$text"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-Phi">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3d5;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3d5;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-phi"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
     <xsl:variable name="translate-lowercase-omega">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3c9;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3c9;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-Phi"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-aleph">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x2135;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2135;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-lowercase-omega"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-alpha">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3b1;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3b1;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-aleph"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-beta">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3b2;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3b2;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-alpha"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-gamma">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3b3;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3b3;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-beta"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-delta">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3b4;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3b4;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-gamma"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-epsilon">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3b5;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3b5;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-delta"/>
        </xsl:with-param>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="translate-tau">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x3c4;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x3c4;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-epsilon"/>
        </xsl:with-param>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="translate-and">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="Asana-Math">&#x2227;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2227;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-tau"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-cap">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="Asana-Math">&#x2229;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2229;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-and"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-cup">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="Asana-Math">&#x222a;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x222a;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-cap"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-or">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="Asana-Math">&#x2228;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2228;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-cup"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-emdash">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to">&#x200b;—&#x200b;</xsl:with-param>
        <xsl:with-param name="from">---</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-or"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
   <xsl:variable name="translate-underscore">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">&#x200b;_&#x200b;</xsl:with-param>
      <xsl:with-param name="from">_</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-emdash"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-double-slash">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">/<fo:inline padding-left="{$slash-kern}">/</fo:inline></xsl:with-param>
      <xsl:with-param name="from">//</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-underscore"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-endash">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">–</xsl:with-param>
      <xsl:with-param name="from">--</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-double-slash"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-open-quote">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">“</xsl:with-param>
      <xsl:with-param name="from">``</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-endash"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-open-single-quote">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">‘</xsl:with-param>
      <xsl:with-param name="from">`</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-open-quote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-close-quote">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">”</xsl:with-param>
      <xsl:with-param name="from">''</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-open-single-quote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-close-single-quote">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">’</xsl:with-param>
      <xsl:with-param name="from">'</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-close-quote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-open-single-quote-entity">
    <xsl:call-template name="string-replace">  <!-- backtick -->
      <xsl:with-param name="to">`</xsl:with-param>
      <xsl:with-param name="from">&#9998;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-close-single-quote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-pencil-entity">
    <xsl:call-template name="string-replace">  <!-- mapsto -->
      <xsl:with-param name="to">→</xsl:with-param>
      <xsl:with-param name="from">&#9999;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-open-single-quote-entity"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-checkmark">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">✓</fo:inline></xsl:with-param>
      <xsl:with-param name="from">✓</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-pencil-entity"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-mapsto">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="Arial">&#x2192;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#x2192;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-checkmark"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-left-arrow">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="Arial">&#2190;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#2190;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-mapsto"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-lambda">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="{$sans.font.family}">&#x3bb;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#x3bb;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-left-arrow"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-right-double-stem-arrow">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x21d2;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#x21d2;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-lambda"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-double-headed-double-stem-arrow">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x21d4;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#x21d4;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-right-double-stem-arrow"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="translate-isin">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x2208;</fo:inline></xsl:with-param>
      <xsl:with-param name="from">&#x2208;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:copy-of select="$translate-double-headed-double-stem-arrow"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

    <xsl:variable name="translate-empty">

      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x2205;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2205;</xsl:with-param>
        <xsl:with-param name="string" >
          <xsl:copy-of select="$translate-isin"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-exists">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x2203;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2203;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-empty"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="translate-forall">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to"><fo:inline font-family="{$inline.code.font.family}">&#x2200;</fo:inline></xsl:with-param>
        <xsl:with-param name="from">&#x2200;</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-exists"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="extended">
      <xsl:call-template name="extended">
        <xsl:with-param name="string">
          <xsl:copy-of select="$translate-forall"/>
        </xsl:with-param>
      </xsl:call-template>
      </xsl:variable>

    <xsl:copy-of select="$extended"/>
  </xsl:template>

  <xsl:template name="extended">
    <xsl:param name="string"/>
    <xsl:analyze-string select="$string" regex="([&#x100;-&#x160;]+|[&#x162;-&#x2FF;]+|[&#x370;-&#x58F;]+|[&#x1D00;-&#x1DBF;]+|[&#x1E00;-&#x1FFF;]+|[&#x20AC;]+|[&#x2100;-&#x243F;]+|[&#x2460;-&#x27BF;]+|[&#x27e8;-&#x27e9;]+|[&#x2C60;-&#x2C7F;]+|[&#x2F00;-&#xFE4F;]+|[&#xFF00;-&#xFFEF;]+|[&#xFFF9;-&#xFFFD;]+)">
      <xsl:matching-substring>
        <xsl:choose>
          <xsl:when test="matches(.,'[&#x2E80;-&#xFE4F;]+|[&#xFF00;-&#xFFEF;]+')">
            <fo:inline font-family="CJK"><xsl:value-of select="."/></fo:inline>
          </xsl:when>
          <xsl:when test="matches(.,'[&#x100;-&#x2FF;]+|[&#x370;-&#x58F;]+|[&#x1D00;-&#x1DBF;]+|[&#x1E00;-&#x1FFF;]+|[&#x20AC;]+|[&#x2100;-&#x243F;]+|[&#x2460;-&#x27BF;]+|[&#x27e8;-&#x27e9;]+|[&#x2C60;-&#x2C7F;]+|[&#xFFF9;-&#xFFFD;]+')">
            <fo:inline font-family="Unicode"><xsl:value-of select="."/></fo:inline>
          </xsl:when>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="text()" mode="code">
    <xsl:variable name="backtick">
    <xsl:call-template name="string-replace">
      <!-- backtick -->
      <xsl:with-param name="to">`</xsl:with-param>
      <xsl:with-param name="from">&#9998;</xsl:with-param>
      <xsl:with-param name="string" >
        <xsl:copy-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="extended">
       <xsl:call-template name="extended">
        <xsl:with-param name="string">
          <xsl:copy-of select="$backtick"/>
        </xsl:with-param>
       </xsl:call-template>
    </xsl:variable>


      <xsl:copy-of select="$extended"/>
  </xsl:template>

  <xsl:template name="string-replace">
    <xsl:param name="string"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>

<!-- SAXON change
    <xsl:for-each select="exsl:node-set($string)/node()">
-->
   <xsl:for-each select="$string/node()">

           <xsl:choose>
            <xsl:when test="self::text()">
              <xsl:choose>
                <xsl:when test="contains(., $from)">

                  <xsl:call-template name="iterate-text">
                    <xsl:with-param name="string" select="."/>
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to"/>
                  </xsl:call-template>

                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

  </xsl:template>

  <xsl:template name="iterate-text">
    <xsl:param name="string"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>

    <xsl:analyze-string select="$string" regex="{$from}">
      <xsl:matching-substring>
         <xsl:copy-of select="$to"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
         <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>

  </xsl:template>

  <!--
  <xsl:template name="string-replace">
    <xsl:param name="string"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>

    <xsl:value-of select="str:replace($string, $from, $to)"/>
  </xsl:template>
-->

</xsl:stylesheet>
