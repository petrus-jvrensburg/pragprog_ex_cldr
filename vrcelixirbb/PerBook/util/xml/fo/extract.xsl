<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pml="http://pragprog.com/ns/pml"
  xmlns:redirect="http://xml.apache.org/xalan/redirect"
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:rx="http://www.renderx.com/XSL/Extensions"
  extension-element-prefixes="redirect">

  <xsl:output method="xml" indent="no" omit-xml-declaration="yes" encoding="utf-8"/>

  <xsl:template match="frontmatter" mode="extract">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="extracts-cover">
    <fo:page-sequence master-reference="extract-title" force-page-count="no-force">
      <fo:static-content flow-name="imprint-name">
          <xsl:call-template name="imprint-name"/>
      </fo:static-content> 
      <fo:flow flow-name="xsl-region-body">
        <fo:block padding-top="1in" padding-bottom="-1in" font-size="16pt"
          text-align="right" line-height="100%">
          <xsl:text>Extracted from:</xsl:text>
        </fo:block>
        <xsl:call-template name="title.half-title"/>
        <fo:block font-size="9pt"
          text-align="right" 
          line-height="115%" padding-top="1.5in">
        <fo:block padding-top="3pt" padding-bottom="3pt">This PDF file contains pages extracted from 
          <fo:inline font-style="italic"><xsl:value-of select="/book/bookinfo/booktitle"/></fo:inline>, 
          published by the Pragmatic Bookshelf. For more
          information or to purchase a paperback or PDF copy, please
          visit <fo:inline color="rgb(255,0,255)"><fo:basic-link external-destination="url(https://www.pragprog.com)">https://www.pragprog.com</fo:basic-link></fo:inline>.</fo:block>
        <fo:block padding-top="3pt" padding-bottom="3pt">Note: This extract contains some colored text
          (particularly in code listing). This is available only in
          online versions of the books. The printed versions are black
          and white. Pagination might vary between the online and
          printed versions; the content is otherwise
          identical.</fo:block>
        <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%"><xsl:text>Copyright © </xsl:text>
          <xsl:value-of select="//bookinfo/copyright/copyrightdate"/> 
          <xsl:text> The Pragmatic Programmers, LLC.</xsl:text></fo:block>
        <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%">All rights reserved.</fo:block>
        <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%">No part of this publication may be reproduced, stored
          in a retrieval system, or transmitted, in any form, or by any
          means, electronic, mechanical, photocopying, recording, or
          otherwise, without the prior consent of the
        publisher.
      </fo:block>
    </fo:block>
  </fo:flow>
    </fo:page-sequence> 
  </xsl:template>

  <xsl:template match="extract">
    <xsl:if test="not(following-sibling::*[1][name()='title']) and $extracts = 'yes'">
      <fo:block color="white" id="wombat" line-height="0pt">
        <fo:marker>
          <xsl:attribute name="marker-class-name">
            <xsl:choose>
              <xsl:when test="string-length(@id) &gt; 0">
                <xsl:value-of select="concat('start_extract_',@id)"/>
              </xsl:when>
              <xsl:when test="string-length(@idref) &gt; 0">
                <xsl:value-of select="concat('end_extract_',@idref)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="yes">extract missing id or idref</xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:marker>
        <xsl:if test="@title">
          <xsl:value-of select="@title"/>
        </xsl:if>
      </fo:block>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="start_extract">
    <xsl:if test="$extracts = 'yes'">
      <fo:block color="white" line-height="0pt">
        <fo:marker>
          <xsl:attribute name="marker-class-name">
            <xsl:value-of select="concat('start_extract_',@id)"/>
          </xsl:attribute>
        </fo:marker>

        <xsl:if test="@title">
          <xsl:value-of select="@title"/>
        </xsl:if>
      </fo:block>
    </xsl:if>

  </xsl:template>



</xsl:stylesheet>
