<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"
    encoding="UTF-8"/>

  <xsl:param name="dtd"/>
  <xsl:param name="pdf-dir"/>
  <xsl:param name="common-dir"/>
  <xsl:param name="screen-xsl"/>
  <xsl:param name="paper-xsl"/>
  <xsl:param name="mobi-xsl"/>
  <xsl:param name="epub-xsl"/>

  <xsl:variable name="name-characters"
    select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_'"/>

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
    <xsl:element name="ouput-type">
      <xsl:attribute name="name">
        <xsl:value-of select="$type"/>
      </xsl:attribute>
      <xsl:element name="elements">
        <xsl:call-template name="get-element">
          <xsl:with-param name="string" select="normalize-space($dtd)"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>

  </xsl:template>

  <xsl:template name="get-element">
    <xsl:param name="string"/>
    <xsl:param name="type"/>

    <xsl:if test="contains($string,'!ELEMENT')">
      <xsl:variable name="after-element">
        <xsl:value-of select="substring-after($string,'!ELEMENT ')"/>
      </xsl:variable>
      <xsl:variable name="this-element">
        <xsl:value-of select="substring-before($after-element,' ')"/>
      </xsl:variable>


      <xsl:element name="element">
        <xsl:attribute name="name">
          <xsl:value-of select="$this-element"/>
        </xsl:attribute>
        <xsl:call-template name="crawl-xsl">
          <xsl:with-param name="this-element" select="$this-element"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
      </xsl:element>

      <xsl:call-template name="get-element">
        <xsl:with-param name="string" select="$after-element"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="crawl-xsl">
    <xsl:param name="this-element"/>
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
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="$dir-path"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="xsl:include">
    <xsl:param name="this-element"/>
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
      <xsl:with-param name="this-element" select="$this-element"/>
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

  <xsl:template name="qualify-match">
    <xsl:param name="string"/>
    <xsl:param name="element"/>

    <xsl:if test="contains($string,$element)">
      
      <xsl:variable name="before">
        <xsl:value-of select="substring-before($string,$element)"/>
      </xsl:variable>
      
      <xsl:variable name="after">
        <xsl:value-of select="substring-after($string,$element)"/>
      </xsl:variable>
      
      <xsl:choose>
        <xsl:when
          test="string-length($before) &gt; 0 and contains($name-characters,substring($before,string-length($before),1))">
          <xsl:call-template name="qualify-match">
            <xsl:with-param name="element" select="$element"/>
            <xsl:with-param name="string" select="$after"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
         <!--<xsl:message>element is <xsl:value-of select="$element"/> AND AFTER: length: <xsl:value-of select="string-length($after)"/> AND first character: <xsl:value-of select="substring($after,1)"/></xsl:message>  --> 
          <xsl:choose>
            <xsl:when test="string-length($after) &gt; 0 and contains($name-characters,substring($after,1,1))">
              <xsl:call-template name="qualify-match">
                <xsl:with-param name="element" select="$element"/>
                <xsl:with-param name="string" select="$after"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>yes</xsl:otherwise>
          </xsl:choose>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:if> 

  </xsl:template>

  <xsl:template name="used-in">
    <xsl:param name="selector"/>
    <xsl:param name="value"></xsl:param>
    <xsl:element name="used-in">
      <xsl:attribute name="type">
        <xsl:value-of select="$selector"/>
      </xsl:attribute>
      <xsl:value-of select="$value"/>
    </xsl:element>
    
  </xsl:template>

  <xsl:template match="xsl:template">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>

     <xsl:if test="contains(@match,$this-element)">
       <xsl:variable name="qualified">
        <xsl:call-template name="qualify-match">
          <xsl:with-param name="string" select="@match"/>
          <xsl:with-param name="element" select="$this-element"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:if test="$qualified = 'yes'">
        <xsl:call-template name="used-in">
          <xsl:with-param name="selector" select="'template-match'"/>
          <xsl:with-param name="value" select="@match"/>
        </xsl:call-template> 
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsl:for-each">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>

    <xsl:if test="contains(@select,$this-element)">
      <xsl:variable name="qualified">
        <xsl:call-template name="qualify-match">
          <xsl:with-param name="string" select="@select"/>
          <xsl:with-param name="element" select="$this-element"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$qualified = 'yes'">
        <xsl:call-template name="used-in">
          <xsl:with-param name="selector" select="'for-each'"/>
          <xsl:with-param name="value" select="@select"/>
        </xsl:call-template> 
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsl:value-of">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>

    <xsl:if test="contains(@select,$this-element)">
      <xsl:variable name="qualified">
        <xsl:call-template name="qualify-match">
          <xsl:with-param name="string" select="@select"/>
          <xsl:with-param name="element" select="$this-element"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$qualified = 'yes'">
        <xsl:call-template name="used-in">
          <xsl:with-param name="selector" select="'value-of'"/>
          <xsl:with-param name="value" select="@select"/>
        </xsl:call-template> 
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>
   
  <xsl:template match="xsl:apply-templates">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>
    
    <xsl:if test="contains(@select,$this-element)">
      <xsl:variable name="qualified">
        <xsl:call-template name="qualify-match">
          <xsl:with-param name="string" select="@select"/>
          <xsl:with-param name="element" select="$this-element"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$qualified = 'yes'">
        <xsl:call-template name="used-in">
          <xsl:with-param name="selector" select="'value-of'"/>
          <xsl:with-param name="value" select="@select"/>
        </xsl:call-template> 
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="xsl:copy-of">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>
   
    <xsl:if test="contains(@select,$this-element)">
      <xsl:variable name="qualified">
        <xsl:call-template name="qualify-match">
          <xsl:with-param name="string" select="@select"/>
          <xsl:with-param name="element" select="$this-element"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$qualified = 'yes'">
        <xsl:call-template name="used-in">
          <xsl:with-param name="selector" select="'value-of'"/>
          <xsl:with-param name="value" select="@select"/>
        </xsl:call-template> 
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="this-element"/>
    <xsl:param name="path"/>

    <xsl:apply-templates select="*">
      <xsl:with-param name="this-element" select="$this-element"/>
      <xsl:with-param name="path" select="concat($path,@href)"/>
    </xsl:apply-templates>

  </xsl:template>

</xsl:stylesheet>
