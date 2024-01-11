<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"
    encoding="UTF-8"/>

  <xsl:param name="pdf-dir"/>
  <xsl:param name="common-dir"/>
  <xsl:param name="screen-xsl"/>
  <xsl:param name="paper-xsl"/>
  <xsl:param name="mobi-xsl"/>
  <xsl:param name="epub-xsl"/>

  <xsl:template match="/">
    <xsl:element name="root">
      <xsl:call-template name="output-type">
        <xsl:with-param name="type" select="'screen'"/>
      </xsl:call-template>
      <xsl:call-template name="output-type">
        <xsl:with-param name="type" select="'paper'"/>
      </xsl:call-template>
      <xsl:call-template name="output-type">
        <xsl:with-param name="type" select="'mobi'"/>
      </xsl:call-template>
      <xsl:call-template name="output-type">
        <xsl:with-param name="type" select="'epub'"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template name="output-type">
    <xsl:param name="type"/>
    <xsl:element name="output-type">
      <xsl:attribute name="name">
        <xsl:value-of select="$type"/>
      </xsl:attribute>
      <xsl:call-template name="crawl-xsl">
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template name="crawl-xsl">
    <xsl:param name="type"/>

    <xsl:variable name="file-path">
      <xsl:choose>
        <xsl:when test="$type = 'screen'">
          <xsl:value-of select="concat('file:///',$pdf-dir,$screen-xsl)"
          />
        </xsl:when>
        <xsl:when test="$type = 'paper'">
          <xsl:value-of select="concat('file:///',$pdf-dir,$paper-xsl)"
          />
        </xsl:when>
        <xsl:when test="$type = 'mobi'">
          <xsl:value-of
            select="concat('file:///',$common-dir,$mobi-xsl)"/>
        </xsl:when>
        <xsl:when test="$type = 'epub'">
          <xsl:value-of
            select="concat('file:///',$common-dir,$epub-xsl)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dir-path">
      <xsl:choose>
        <xsl:when test="$type = 'screen'">
          <xsl:value-of select="concat('file:///',$pdf-dir)"/>
        </xsl:when>
        <xsl:when test="$type = 'paper'">
          <xsl:value-of select="concat('file:///',$pdf-dir)"/>
        </xsl:when>
        <xsl:when test="$type = 'mobi'">
          <xsl:value-of select="concat('file:///',$common-dir)"/>
        </xsl:when>
        <xsl:when test="$type = 'epub'">
          <xsl:value-of select="concat('file:///',$common-dir)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:apply-templates select="document($file-path)/*">
      <xsl:with-param name="path" select="$dir-path"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="xsl:include">
    <xsl:param name="path"/>

    <xsl:variable name="path-without-filename">
      <xsl:if test="contains(translate(@href,'\','/'),'/')">
        <xsl:call-template name="remove-filename-from-path">
          <xsl:with-param name="path" select="translate(@href,'\','/')"
          />
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:apply-templates select="document(concat($path,'/',@href))/*">
      <xsl:with-param name="path"
        select="concat($path,'/',$path-without-filename)"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template name="remove-filename-from-path">
    <xsl:param name="path"/>
    <xsl:param name="newpath"/>

    <xsl:choose>
      <xsl:when test="contains($path,'/')">
        <xsl:call-template name="remove-filename-from-path">
          <xsl:with-param name="newpath"
            select="concat($newpath,substring-before($path,'/'),'/')"/>
          <xsl:with-param name="path"
            select="substring-after($path,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$newpath"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="used-in">
    <xsl:param name="selector"/>
    <xsl:param name="value"/>
    <xsl:element name="used-in">
      <xsl:attribute name="type">
        <xsl:value-of select="$selector"/>
      </xsl:attribute>
      <xsl:value-of select="$value"/>
    </xsl:element>

  </xsl:template>

  <xsl:template match="xsl:template">
    <xsl:param name="path"/>

    <xsl:choose>
      <xsl:when test="contains(@match,'|')">
        <xsl:call-template name="process-pipe">
          <xsl:with-param name="string" select="@match"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains(@match,'/')">
        <xsl:call-template name="process-path">
          <xsl:with-param name="string" select="@match"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-element">
          <xsl:with-param name="element" select="@match"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="*">
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsl:for-each">
    <xsl:param name="path"/>

    <xsl:choose>
      <xsl:when test="contains(@select,'|')">
        <xsl:call-template name="process-pipe">
          <xsl:with-param name="string" select="@match"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains(@select,'/')">
        <xsl:call-template name="process-path">
          <xsl:with-param name="string" select="@select"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-element">
          <xsl:with-param name="element" select="@select"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>



    <xsl:apply-templates select="*">
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsl:value-of">
    <xsl:param name="path"/>

    <xsl:choose>
      <xsl:when test="contains(@select,'/')">
        <xsl:call-template name="process-path">
          <xsl:with-param name="string" select="@select"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-element">
          <xsl:with-param name="element" select="@select"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="*">
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsl:copy-of">
    <xsl:param name="path"/>

    <xsl:choose>
      <xsl:when test="contains(@select,'/')">
        <xsl:call-template name="process-path">
          <xsl:with-param name="string" select="@select"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-element">
          <xsl:with-param name="element" select="@select"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="*">
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="path"/>

    <xsl:apply-templates select="*">
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template name="process-pipe">
    <xsl:param name="string"/>


    <xsl:choose>
      <xsl:when test="contains($string,'|')">
        <xsl:variable name="before-pipe">
          <xsl:value-of select="substring-before($string,'|')"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="contains($before-pipe,'/')">
            <xsl:call-template name="process-path">
              <xsl:with-param name="string" select="$before-pipe"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="output-element">
              <xsl:with-param name="element" select="$before-pipe"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="process-pipe">
          <xsl:with-param name="string"
            select="substring-after($string,'|')"/>
        </xsl:call-template>

      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($string,'/')">
            <xsl:call-template name="process-path">
              <xsl:with-param name="string" select="$string"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="output-element">
              <xsl:with-param name="element" select="$string"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="process-path">
    <xsl:param name="string"/>
    <xsl:choose>
      <xsl:when test="contains($string,'/')">
        <xsl:call-template name="output-element">
          <xsl:with-param name="element"
            select="substring-before($string,'/')"/>
        </xsl:call-template>
        <xsl:call-template name="process-path">
          <xsl:with-param name="string"
            select="substring-after($string,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output-element">
          <xsl:with-param name="element" select="$string"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="output-element">
    <xsl:param name="element"/>
    <xsl:if
      test="not(contains($element,'*'))
        and not(contains($element,'$'))
        and not(contains($element,'.'))
        and not(contains($element,'@'))
        and not(contains($element,'('))
        and string-length($element) &gt; 0
        ">
      <xsl:element name="element">
        <xsl:choose>
          <xsl:when test="contains($element,'[')">
            <xsl:value-of select="substring-before($element,'[')"/>
          </xsl:when>
          <xsl:when test="contains($element,'::')">
            <xsl:value-of select="substring-after($element,'::')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($element)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:if>


  </xsl:template>

</xsl:stylesheet>
