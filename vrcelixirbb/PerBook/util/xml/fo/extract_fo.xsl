<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pml="http://pragprog.com/ns/pml"
  xmlns:redirect="http://xml.apache.org/xalan/redirect" xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:rx="http://www.renderx.com/XSL/Extensions" extension-element-prefixes="redirect">

  <xsl:param name="in.dir"/>

  <xsl:template name="extracts-cover">
    <fo:page-sequence master-reference="extract-title" force-page-count="no-force">
    <!--   <fo:static-content flow-name="imprint-name"> -->
    <!--       <xsl:call-template name="imprint-name"/> -->
    <!--   </fo:static-content>  -->
  <fo:flow flow-name="xsl-region-body">
      <fo:block 
      line-stacking-strategy="max-height"  
      margin="0pt"
      font-size="80%"
      >
      <fo:external-graphic 
      overflow="hidden"
      src="url(images/cover.jpg)"
      width="100%"
      content-width="scale-to-fit"
      scaling="uniform"  
      content-height="100%"
      border="0.5pt solid rgb-icc(220, 220, 220, #Grayscale, 0.83)"
      />
      <fo:block padding-top="0.25in" margin-right="0.6in">
        This extract shows the online version of this title, and may contain features (such as hyperlinks
        and colors) that are not available in the print version.
      </fo:block>
      <fo:block padding-top="8pt" margin-right="0.6in">
        For more information, or to purchase a paperback or ebook copy, please
        visit <fo:inline color="rgb(150,66,189)">
          <fo:basic-link external-destination="url(https://www.pragprog.com)">https://www.pragprog.com</fo:basic-link></fo:inline>.
        </fo:block>
        <fo:block padding-top="13pt" font-size="70%">
          <xsl:text>Copyright © The Pragmatic Programmers, LLC.</xsl:text>
        </fo:block>
    </fo:block>
    <!--     <fo:block padding-top="1in" padding-bottom="-1in" font-size="16pt" -->
    <!--       text-align="right" line-height="100%"> -->
    <!--       <xsl:text>Extracted from:</xsl:text> -->
    <!--     </fo:block> -->
    <!--     <xsl:call-template name="title.half-title"/> -->
    <!--     <fo:block font-size="9pt" -->
    <!--       text-align="right"  -->
    <!--       line-height="115%" padding-top="1.5in"> -->
    <!--     <fo:block padding-top="3pt" padding-bottom="3pt">This  pages extracted from  -->
    <!--       <fo:inline font-style="italic"><xsl:value-of select="/book/bookinfo/booktitle"/></fo:inline>,  -->
    <!--       published by the Pragmatic Bookshelf. For more -->
    <!--       information or to purchase a paperback or PDF copy, please -->
    <!--       visit <fo:inline color="rgb(255,0,255)"><fo:basic-link external-destination="url(https://www.pragprog.com)">https://www.pragprog.com</fo:basic-link></fo:inline>.</fo:block> -->
    <!--     <fo:block padding-top="3pt" padding-bottom="3pt">Note: This extract contains some colored text -->
    <!--       (particularly in code listing). This is available only in -->
    <!--       online versions of the books. The printed versions are black -->
    <!--       and white. Pagination might vary between the online and -->
    <!--       printed versions; the content is otherwise -->
    <!--       identical.</fo:block> -->
    <!--     <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%"><xsl:text>Copyright © </xsl:text> -->
    <!--       <xsl:value-of select="//bookinfo/copyright/copyrightdate"/>  -->
    <!--       <xsl:text> The Pragmatic Programmers, LLC.</xsl:text></fo:block> -->
    <!--     <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%">All rights reserved.</fo:block> -->
    <!--     <fo:block padding-top="3pt" padding-bottom="3pt" font-size="90%">No part of this publication may be reproduced, stored -->
    <!--       in a retrieval system, or transmitted, in any form, or by any -->
    <!--       means, electronic, mechanical, photocopying, recording, or -->
    <!--       otherwise, without the prior consent of the -->
    <!--     publisher. -->
    <!--   </fo:block> -->
    <!-- </fo:block> -->
  </fo:flow>
    </fo:page-sequence> 
  </xsl:template>



  <xsl:template match="/">
    <xsl:apply-templates select="fo:root"/>
  </xsl:template>

  <xsl:template match="fo:root">

    <xsl:for-each select="//fo:marker[contains(@marker-class-name,'start_extract')]">
      
      <xsl:variable name="extract_id">
        <xsl:value-of select="substring-after(@marker-class-name,'start_extract_')"/>
      </xsl:variable>

      <xsl:variable name="extract_title">
        <xsl:call-template name="safe-file-name">
          <xsl:with-param name="name">
            <xsl:value-of select="normalize-space(parent::fo:block)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:result-document href="{concat('extract-', $extract_title, '.fo')}">
        <xsl:element name="fo:root">
          <xsl:for-each select="/fo:root/@*">
            <xsl:attribute name="{name()}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:for-each>

          <xsl:copy-of select="//rx:meta-info"/>
          <xsl:copy-of select="//fo:layout-master-set"/>
          <!-- <xsl:copy-of select="//fo:page-sequence[@master-reference='extract-title']"/> -->
          <xsl:call-template name="extracts-cover"/>
          <!-- <xsl:copy-of select="//fo:page-sequence[@master-reference='cover']"/> -->
          <!-- <xsl:copy-of select="//fo:page-sequence[@master-reference='title']"/> -->


          <!-- If the extract is a chapter, copy the page-sequence in brackets rather than rebuilding the page-sequence. -->
          <xsl:choose>
            <xsl:when test="not(ancestor::fo:page-sequence)">
              <xsl:for-each
                select="following::fo:page-sequence[@master-reference='long-intro'][following::fo:marker[@marker-class-name = concat('end_extract_',$extract_id)]]
                      | following::fo:page-sequence[@master-reference='part'][following::fo:marker[@marker-class-name = concat('end_extract_',$extract_id)]]
                      | following::fo:page-sequence[@master-reference='chapter'][following::fo:marker[@marker-class-name = concat('end_extract_',$extract_id)]]
                      | following::fo:page-sequence[@master-reference='task'][following::fo:marker[@marker-class-name = concat('end_extract_',$extract_id)]]">
                 <xsl:copy-of select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::fo:page-sequence[@master-reference='long-intro'] | ancestor::fo:page-sequence[@master-reference='part'] | ancestor::fo:page-sequence[@master-reference='chapter'] | ancestor::fo:page-sequence[@master-reference='task']">
                <xsl:element name="fo:page-sequence">
                  <xsl:for-each select="@*">
                    <xsl:attribute name="{local-name()}">
                      <xsl:value-of select="."/>
                    </xsl:attribute>
                  </xsl:for-each>
                  <xsl:copy-of select="child::fo:static-content"/>
                  <xsl:element name="fo:flow">
                    <xsl:for-each select="fo:flow/@*">
                      <xsl:attribute name="{local-name()}">
                        <xsl:value-of select="."/>
                      </xsl:attribute>
                    </xsl:for-each>
                    <xsl:apply-templates select="fo:flow">
                      <xsl:with-param name="extract_id" select="$extract_id"/>
                    </xsl:apply-templates>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:result-document>
      <!-- </redirect:write> -->
    </xsl:for-each>
    
   <!-- Now do an extract with the complete TOC --> 
      <xsl:variable name="extract_id">
        <xsl:value-of select="'TOC'"/>
      </xsl:variable>

      <xsl:variable name="extract_title">
        <xsl:text>TOC</xsl:text>
      </xsl:variable>
   
      <xsl:result-document href="{concat('extract-', $extract_title, '.fo')}">
         <xsl:element name="fo:root">
          <xsl:for-each select="/fo:root/@*">
            <xsl:attribute name="{name()}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:for-each>

          <xsl:copy-of select="//rx:meta-info"/>
          <xsl:copy-of select="//fo:layout-master-set"/>
          <xsl:call-template name="extracts-cover"/>
          <!-- <xsl:copy-of select="//fo:page-sequence[@master-reference='extract-title']"/> -->
          <!-- <xsl:copy select="//fo:page-sequence[@master-reference='cover']"/> -->
          <!-- <xsl:copy-of select="//fo:page-sequence[@master-reference='title']"/> -->
          <!-- Now copy the page-sequence for the TOC -->
          <xsl:copy-of select="//fo:page-sequence[@master-reference='contents']"/>  
         </xsl:element>
      </xsl:result-document>
    <!--  </redirect:write> --> 
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:param name="extract_id"/>

    <xsl:variable name="start-marker">
      <xsl:value-of select="concat('start_extract_',$extract_id)"/>
    </xsl:variable>
    <xsl:variable name="end-marker">
      <xsl:value-of select="concat('end_extract_',$extract_id)"/>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="preceding::fo:block/fo:marker[@marker-class-name=$start-marker]">
        <xsl:choose>
          <xsl:when test="following::fo:block/fo:marker[@marker-class-name=$end-marker]">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="extract_id" select="$extract_id"/>
              </xsl:apply-templates>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="descendant::fo:block/fo:marker[@marker-class-name=$end-marker]">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="extract_id" select="$extract_id"/>
              </xsl:apply-templates>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates>
              <xsl:with-param name="extract_id" select="$extract_id"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates>
          <xsl:with-param name="extract_id" select="$extract_id"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:variable name="valid-name-chars">
    <xsl:text>abcdefghijklmnopqrstuvwxyz0123456789-</xsl:text>
  </xsl:variable>

  <xsl:variable name="filler-char">
    <xsl:text>-----------------------------------------------------------------------------------------</xsl:text>
  </xsl:variable>

  <xsl:template name="safe-file-name">
    <xsl:param name="name"/>
    <xsl:variable name="lc-name">
      <xsl:value-of select="translate($name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:variable>
    <xsl:variable name="invalid-chars">
      <xsl:value-of select="translate($lc-name, $valid-name-chars, '')"/>
    </xsl:variable>
    <xsl:value-of select="translate($lc-name, $invalid-chars, $filler-char)"/>
  </xsl:template>

</xsl:stylesheet>
