<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>
  <xsl:template name="highlight">
    <div class="highlight">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="sidebar">
    <div class="sidebar">
      <xsl:call-template name="add-id"/>
      <div class="sidebar-title">
	<xsl:value-of select="title"/>
      </div>
      <div class="sidebar-content">
	<xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="dialog">
    <dl>
      <xsl:apply-templates />
    </dl>
  </xsl:template>

  <xsl:template match="said-by">
    <dt>
      <xsl:value-of select="@name"/>:
    </dt>
    <dd>
      <xsl:apply-templates />
    </dd>
  </xsl:template>

  <xsl:template match="blockquote">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>

  <xsl:template match="example">
    <div class="example">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="story">
    <div  class="story">
      <xsl:call-template name="add-id"/>
      <div class="title">
	<xsl:value-of select="./title"/>
      </div>
      <xsl:if test="./person">
        <div class="author">
          by <xsl:value-of select="./person/name"/>
	  <xsl:if test="./person/jobtitle">
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="./person/jobtitle"/>
	  </xsl:if>
	  <xsl:if test="./person/affiliation">
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="./person/affiliation"/>
	  </xsl:if>
        </div>
      </xsl:if>
      <div class="story-body">
        <xsl:apply-templates/>
      </div>
    </div>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- <xsl:template match="joeasks">
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
<xsl:text>images/headshot_</xsl:text>
<xsl:value-of select="@by"/>
<xsl:text>.png</xsl:text>
</xsl:with-param>
</xsl:call-template>
</xsl:template> -->

  <xsl:template match="figure">
    <div>
      <xsl:if test="child::title">
        <xsl:attribute name="class">figure</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="add-id"/>
      <div>
        <!-- <xsl:apply-templates select="*[not(self::title)]"/> -->
        <xsl:call-template name="figure-contents"/>
      </div>
      <xsl:if test="child::title and child::*[not(name() = 'title') and not(name() = 'table')]">   
        <div class="figurecaption">
          <hr/>
          <xsl:text>Figure </xsl:text>
          <xsl:number format="1" count="figure[child::title][child::*[not(name() = 'title') and not(name() = 'table')]]" from="book" level="any"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates select="title" mode="force"/>
          <xsl:if test="p">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="p[1][not(preceding-sibling::*[not(self::title)])]/node()"/> 
            <xsl:apply-templates select="p[count(preceding-sibling::p) &gt;= 1][not(preceding-sibling::*[not(self::p or self::title)])]"/> 
          </xsl:if>
        </div>
      </xsl:if>
    </div>
    <xsl:call-template name="post-figure-hook"/>
  </xsl:template>
  
  <xsl:template name="xxxasks">
    <xsl:param name="label"/>
    <xsl:param name="image"/>
    <div class="xxxsays">
      <xsl:call-template name="add-id"/>
      <div class="heading">
	<div class="persons-picture">
	  <img>
	    <xsl:attribute name="src">
	      <xsl:value-of select="$image"/>
	    </xsl:attribute>
	    <xsl:attribute name="alt">
	      <xsl:value-of select="$label"/>
	    </xsl:attribute>
	  </img>
	</div>
	<div class="label">
	  <xsl:value-of select="$label"/>
	</div>
	<div class="title">
	  <xsl:apply-templates select="./title" mode="force"/>
	</div>
      </div>

      <div class="body">
	<xsl:apply-templates/>
	<!--  <xsl:for-each select=".//footnote | .//footnoteref">
          <blockquote class="footnote">
	    <xsl:apply-templates/>
          </blockquote>
        </xsl:for-each>-->
      </div>
    </div>
  </xsl:template>

  <xsl:template match="p">
    <xsl:for-each select="missing">
      <xsl:call-template name="missing"/>
    </xsl:for-each>
    <xsl:for-each select="highlight">
      <xsl:call-template name="highlight"/>
    </xsl:for-each>
  <!-- remover
    <xsl:for-each select="flagmaterial">
      <xsl:call-template name="flagmaterial"/>
    </xsl:for-each>-->
    <xsl:text>&#10;</xsl:text>
    <p>
      <xsl:call-template name="add-id"/>
      <xsl:call-template name="add-or-generate-id"></xsl:call-template>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="p/highlight"/>

  <xsl:template match="highlight"/>

  <xsl:template match="p/missing"/>

  <xsl:template name="post-figure-hook">  <!-- overridden in mobi -->
  </xsl:template>
  
  <xsl:template match="marginnote"/>
  
  <xsl:template match="webresources">
    <div class="webresources">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="webresource">
    <div class="title">
      <xsl:apply-templates select="resname"/>
    </div>
    <div class="url">
      <xsl:apply-templates select="resurl"/>
    </div>
    <div class="desc">
      <xsl:apply-templates select="resdesc"/>
    </div>
  </xsl:template>

  <xsl:template match="resurl">
    <a>
      <xsl:attribute name="href">
	<xsl:apply-templates/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="resname">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="resdesc">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
