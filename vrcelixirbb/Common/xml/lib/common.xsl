<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns:mbp="http://mobipocket.com/mbp"
    xmlns:redirect="http://xml.apache.org/xalan/redirect"
    xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="redirect"
    exclude-result-prefixes="mbp"
    version="2.0"
    >
  <xsl:include href="id-stuff.xsl" />  
  
  <xsl:template match="joeasks">
    <xsl:call-template name="xxxasks">
      <xsl:with-param name="label">
	<xsl:text>Joe asks:</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="image">
	<xsl:text>images/joe.jpg</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="said">
    <xsl:call-template name="xxxasks">
      <xsl:with-param name="label">
	<xsl:value-of select="@by"/>
	<xsl:text> says:</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="image">
        <xsl:text>images/</xsl:text>
        <xsl:call-template name="name-to-headshot-name"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="build-image-list">
    <xsl:result-document href="{'../image_list'}" method="text">
      <xsl:for-each select="//imagedata | //inlineimage">
	<xsl:apply-templates select="."  mode="list-image-names"/>
      </xsl:for-each>
      <xsl:for-each select="//said">
        <xsl:text>images/</xsl:text>
        <xsl:call-template name="name-to-headshot-name"/>
        <xsl:text>@headshot&#10;</xsl:text>
      </xsl:for-each>
      <xsl:for-each select="//adpage">
        <xsl:for-each select="tokenize(@codes, ' ')">
	  <xsl:value-of select="."/>
	  <xsl:text>@cover&#10;</xsl:text>
	</xsl:for-each>
      </xsl:for-each>
      <xsl:call-template name="book-specific-image-list"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="book-specific-image-list" />

  <xsl:template match="imagedata | inlineimage" mode="list-image-names">
    <xsl:call-template name="get-raw-image-name">
      <xsl:with-param name="file">
        <xsl:value-of select="@fileref"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>@</xsl:text>
    <xsl:value-of select="@width"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>


  <!-- we normally map ../PerBook image names into the local version -->
  <xsl:template name="get-image-name">
    <xsl:param name="file">
      <xsl:choose>
        <xsl:when test="starts-with(@fileref, '../PerBook/util/')">
          <xsl:value-of select="substring-after(@fileref, '../PerBook/util/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@fileref"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:call-template name="get-raw-image-name">
      <xsl:with-param name="file">
        <xsl:value-of select="$file"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- except when building the image list -->
  <xsl:template name="get-raw-image-name">
    <xsl:param name="file"/>
    <xsl:variable name="file-name">
      <xsl:choose>
	<xsl:when test="contains($file, '.pdf')">
	  <xsl:value-of select="substring-before($file, '.pdf')"/>
	  <xsl:text>.png</xsl:text>
	</xsl:when>
	<xsl:when test="contains($file, '.svg')">
	  <xsl:value-of select="substring-before($file, '.svg')"/>
	  <xsl:text>.png</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$file"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$force.jpg.images">
	<xsl:choose>
	  <xsl:when test="contains($file-name, '.png')">
	    <xsl:value-of select="substring-before($file-name, '.png')"/>
	    <xsl:text>.jpg</xsl:text>
	  </xsl:when>
	  <xsl:when test="contains($file-name, '.gif')">
	    <xsl:value-of select="substring-before($file-name, '.gif')"/>
	    <xsl:text>.jpg</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$file-name"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>

      <xsl:when test="contains($file, '.tif')">
	<xsl:value-of select="substring-before($file, '.tif')"/>
	<xsl:text>.png</xsl:text>
      </xsl:when> 
      <xsl:otherwise>
	<xsl:value-of select="$file-name"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="just-image">
    <xsl:param name="inline"/>
    <img>
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:choose>
        <xsl:when test="@border = 'yes'">
          <xsl:attribute name="style">border:1px solid gray;</xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>border </xsl:text>
            <xsl:value-of select="$inline"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:value-of select="$inline"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:attribute name="src">
        <xsl:call-template name="get-image-name"/>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="get-image-name"/>
      </xsl:attribute>
      <xsl:if test="@width">
        <xsl:attribute name="style">
          <xsl:text>width: </xsl:text>
          <xsl:value-of select="@width"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <!-- There's a bug in Stanza 1.9 that prevents images in divs being displayed 
       inside tables
  -->
  <xsl:template match="figure//imagedata | p//imagedata | table//imagedata ">
    <xsl:call-template name="internal-imagedata"/>
  </xsl:template>

  <xsl:template match="imagedata">
    <div class="ss" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="internal-imagedata"/>
    </div>
  </xsl:template>

  <xsl:template name="internal-imagedata">
    <xsl:param name="inline"/>
    <xsl:choose>
      <xsl:when test="contains(@fileref, '.svg') and $format='doesn-work-for-math-epub'">
	<object  type="image/svg+xml">
	  <xsl:attribute name="data">
	    <xsl:value-of select="@fileref"/>
	  </xsl:attribute>
          <xsl:call-template name="just-image">
            <xsl:with-param name="inline">
              <xsl:value-of select="$inline"/>
            </xsl:with-param>
          </xsl:call-template>
	</object>	  
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="just-image">
          <xsl:with-param name="inline">
            <xsl:value-of select="$inline"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="printing">
    <xsl:text>Version: </xsl:text>
    <xsl:apply-templates select="printingnumber"/>
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="printingdate"/>
    <xsl:text>)</xsl:text>    
  </xsl:template>

  <xsl:template match="printingnumber | printingdate">
    <xsl:apply-templates />
  </xsl:template>

  <!-- remove select |contribution |sorbet|task-->
  <xsl:template name="extract-toc">
    <xsl:apply-templates select="chapter|appendix|recipe|task" mode="toc"/>
  </xsl:template>

  <xsl:template name="figure-contents">
    <xsl:for-each select="child::*">
      <xsl:variable name="preceding-sibling-not-p">
        <xsl:call-template name="preceding-sibling">
          <xsl:with-param name="count" select="1"/>
          <xsl:with-param name="position" select="count(preceding-sibling::*) + 1"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$preceding-sibling-not-p = 'yes' or not(self::title or self::p)">
        <xsl:apply-templates select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="title" mode="figure">
    <xsl:call-template name="remove-terminal-punctuation">
      <xsl:with-param name="title" select="normalize-space(.)"/> 
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="remove-terminal-punctuation">
    <xsl:param name="title"/>
    <xsl:variable name="title-length">
      <xsl:value-of select="string-length($title)"/>
    </xsl:variable>
    <xsl:variable name="last-char">
      <xsl:value-of select="substring($title,$title-length)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$last-char = ' '">
        <xsl:call-template name="remove-terminal-punctuation">
          <xsl:with-param name="title" select="substring($title,1,$title-length - 1)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$last-char = '.' or $last-char = ':'">
        <xsl:value-of select="substring($title,1,$title-length - 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="preceding-sibling">
    <xsl:param name="count"/>
    <xsl:param name="position"/>
    <xsl:param name="preceding-non-p"/>
    <xsl:choose>
      <xsl:when test="(preceding-sibling::*[$count][name() != 'p' and name() != 'title']) and $position &gt;= $count">
        <xsl:value-of select="'yes'"/>
      </xsl:when>
      <xsl:when test="$position &gt;= $count">
        <xsl:call-template name="preceding-sibling">
          <xsl:with-param name="count" select="$count + 1"/>
          <xsl:with-param name="position" select="$position"/>
          <xsl:with-param name="preceding-non-p" select="'no'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="capper">
    <xsl:param name="string"/>
    <xsl:value-of select="translate($string,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>  
  </xsl:template>

  <xsl:template match="layout">
  </xsl:template>

  <xsl:template match="layout" mode="force">
  </xsl:template>

  <xsl:template match="layout" mode="toc">
  </xsl:template> 
  
  <xsl:template match="page-params"/>

  <xsl:template match="rights"/>
  <xsl:template match="pagebreak"/>
  <xsl:template match="nobreak">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="hz">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="alpha-head"/>
  <xsl:template match="i-entry"/>
  <xsl:template match="i-see"/>
  <xsl:template match="i-see-list"/>
  <xsl:template match="ii-entry"/>
  <xsl:template match="iii-entry"/>
  <xsl:template match="il"/>
  <xsl:template match="index-listing"/>
  <xsl:template match="index"/>
  <xsl:template match="storymap"/>
  <!--  <xsl:template match="extract"/> -->
  


  
</xsl:stylesheet>
