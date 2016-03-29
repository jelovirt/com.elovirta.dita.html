<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                xpath-default-namespace="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs xhtml">

  <!-- Topic -->

  <xsl:template match="html">
    <xsl:choose>
      <xsl:when test="count(body/article) gt 1">
        <dita>
          <xsl:attribute name="ditaarch:DITAArchVersion">1.3</xsl:attribute>
          <xsl:apply-templates select="@* | node()"/>
        </dita>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="body"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="head"/>

  <xsl:template match="body">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="article">
    <xsl:variable name="name" select="if (@data-hd-class) then @data-hd-class else 'topic'"/>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="." mode="topic"/>      
      <xsl:attribute name="ditaarch:DITAArchVersion">1.3</xsl:attribute>
      <xsl:apply-templates select="ancestor::*/@xml:lang"/>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="h1"/>
      <xsl:variable name="contents" select="* except h1"/>
      <xsl:variable name="shortdesc" select="$contents[1]/self::p"/>
      <xsl:if test="$shortdesc">
        <shortdesc class="- topic/shortdesc ">
          <xsl:apply-templates select="$shortdesc/node()"/>
        </shortdesc>
      </xsl:if>
      <body class="- topic/body ">
        <xsl:apply-templates select="$contents except $shortdesc"/>
      </body>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="article" mode="class">
    <xsl:attribute name="class">
      <xsl:text>- topic/topic </xsl:text> 
      <xsl:if test="@data-hd-class">
        <xsl:value-of select="concat(@data-hd-class, '/', @data-hd-class)"/>
      </xsl:if>
      <xsl:text> </xsl:text>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="article[@data-hd-class = 'concept']" mode="class">
    <xsl:attribute name="class">- topic/topic concept/concept </xsl:attribute>
  </xsl:template>
  <xsl:template match="article[@data-hd-class = 'task']" mode="class">
    <xsl:attribute name="class">- topic/topic task/task </xsl:attribute>
  </xsl:template>
  <xsl:template match="article[@data-hd-class = 'reference']" mode="class">
    <xsl:attribute name="class">- topic/topic reference/reference </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="article" mode="topic">
    <xsl:attribute name="domains">(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)</xsl:attribute>
  </xsl:template>  
  <xsl:template match="article[@data-hd-class = 'concept']" mode="topic">
    <xsl:attribute name="domains">(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)</xsl:attribute>
  </xsl:template>
  <xsl:template match="article[@data-hd-class = 'task']" mode="topic">
    <xsl:attribute name="domains">(topic concept) (topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)</xsl:attribute>
  </xsl:template>
  <xsl:template match="article[@data-hd-class = 'reference']" mode="topic">
    <xsl:attribute name="domains">(topic reference) (topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)</xsl:attribute>
  </xsl:template>
  

  <xsl:template match="section" mode="class">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@data-hd-class = 'topic/example'">
          <xsl:text>- topic/example </xsl:text> 
        </xsl:when>
       <xsl:when test="contains(@data-hd-class, '/')">
         <xsl:text>- topic/section </xsl:text> 
         <xsl:value-of select="concat(@data-hd-class, '/', @data-hd-class)"/>
         <xsl:text> </xsl:text>
       </xsl:when>
        <xsl:otherwise>
          <xsl:text>- topic/section </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="h1 | h2">
    <title>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </title>
  </xsl:template>  
  <xsl:template match="h1 | h2" mode="class">
    <xsl:attribute name="class">- topic/title </xsl:attribute>
  </xsl:template>

  <xsl:template match="dl">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each-group select="*" group-starting-with="dt[empty(preceding-sibling::*[1]/self::dt)]">
        <dlentry class="- topic/dlentry ">
          <xsl:apply-templates select="current-group()"/>
        </dlentry>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:attribute name="lang" select="."/>
  </xsl:template>

  <xsl:template match="figure">
    <fig>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="figcaption"/>
      <xsl:apply-templates select="node() except figcaption"/>
    </fig>
  </xsl:template>
  <xsl:template match="figure" mode="class">
    <xsl:attribute name="class">- topic/fig </xsl:attribute>
  </xsl:template>

  <xsl:template match="img">
    <image>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </image>
  </xsl:template>
  <xsl:template match="img" mode="class">
    <xsl:attribute name="class">- topic/image </xsl:attribute>
  </xsl:template>
  <xsl:template match="img/@src">
    <xsl:attribute name="href" select="."/>
  </xsl:template>

  <xsl:template match="table">
    <xsl:variable name="cols" as="xs:integer" select="max(descendant::tr/count(*))"/>
    <table>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | caption"/>
      <tgroup class="- topic/tgroup "  cols="{$cols}">
        <xsl:choose>
          <xsl:when test="tr[1][th and empty(td)]">
            <thead class="- topic/thead ">
              <xsl:apply-templates select="tr[1]"/>
            </thead>
            <tbody class="- topic/tbody ">
              <xsl:apply-templates select="tr[position() ne 1]"/>
            </tbody>
          </xsl:when>
          <xsl:when test="tr">
            <tbody class="- topic/tbody ">
              <xsl:apply-templates select="tr"/>
            </tbody>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="thead | tbody"/>
          </xsl:otherwise>
        </xsl:choose>
      </tgroup>
    </table>
  </xsl:template>
  <xsl:template match="table/caption | figcaption">
    <title>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </title>
  </xsl:template>
  <xsl:template match="table/caption | figcaption" mode="class">
    <xsl:attribute name="class">- topic/title </xsl:attribute>
  </xsl:template>
  <xsl:template match="tr">
    <row>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </row>
  </xsl:template>
  <xsl:template match="tr" mode="class">
    <xsl:attribute name="class">- topic/row </xsl:attribute>
  </xsl:template>
  <xsl:template match="td | th">
    <entry>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </entry>
  </xsl:template>
  <xsl:template match="td | th" mode="class">
    <xsl:attribute name="class">- topic/entry </xsl:attribute>
  </xsl:template>
  <xsl:template match="@rowspan">
    <xsl:attribute name="morerows" select="xs:integer(.) - 1"/>
  </xsl:template>

  <xsl:template match="*[@data-hd-class = 'topic/example']" mode="class">
    <xsl:attribute name="class">- topic/example </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="b | strong" mode="class">
    <xsl:attribute name="class">+ topic/ph hi-d/b </xsl:attribute>
  </xsl:template>
  <xsl:template match="i | em" mode="class">
    <xsl:attribute name="class">+ topic/ph hi-d/i </xsl:attribute>
  </xsl:template>
  <xsl:template match="u" mode="class">
    <xsl:attribute name="class">+ topic/ph hi-d/u </xsl:attribute>
  </xsl:template>
  <xsl:template match="span">
    <ph>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </ph>
  </xsl:template>
  <xsl:template match="span" mode="class">
    <xsl:attribute name="class">- topic/ph </xsl:attribute>
  </xsl:template>
  <xsl:template match="strong">
    <b>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </b>
  </xsl:template>
  <xsl:template match="em">
    <i>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </i>
  </xsl:template>
  <xsl:template match="a">
    <xref>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </xref>
  </xsl:template>
  <xsl:template match="a" mode="class">
    <xsl:attribute name="class">- topic/xref </xsl:attribute>
  </xsl:template>
  <xsl:template match="a/@type">
    <xsl:attribute name="format" select="."/>
  </xsl:template>
  
  <!-- Map -->
  
  <xsl:template match="nav">
    <map>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="." mode="topic"/>      
      <xsl:attribute name="ditaarch:DITAArchVersion">1.3</xsl:attribute>
      <xsl:apply-templates select="ancestor::*/@xml:lang"/>
      <xsl:apply-templates select="@* | node()"/>
    </map>
  </xsl:template>
  <xsl:template match="nav" mode="class">
    <xsl:attribute name="class">- map/map </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="nav/h1">
    <topicmeta class="- map/topicmeta ">
      <navtitle class="- map/navtitle ">
        <xsl:apply-templates select="@* | node()"/>
      </navtitle>
    </topicmeta>
  </xsl:template>
  
  <xsl:template match="nav//ul | nav//ol">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="nav//li">
    <topicref class="- map/topicref ">
      <topicmeta class="- map/topicmeta ">
        <navtitle class="- map/navtitle ">
          <xsl:apply-templates select="node() except (ol | ul)"/>
        </navtitle>
      </topicmeta>
      <xsl:apply-templates select="ol | ul"/>
    </topicref>
  </xsl:template>
  
  <!-- Common -->
  
  <xsl:template match="@class">
    <xsl:attribute name="outputclass" select="."/>
  </xsl:template>  
  
  <xsl:template match="*[@data-hd-class]" mode="class" priority="-5">
    <xsl:attribute name="class">
      <xsl:text>- </xsl:text>
      <xsl:value-of select="@data-hd-class"/>
      <xsl:text> </xsl:text>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*" mode="class" priority="-10">
    <xsl:attribute name="class">
      <xsl:text>- topic/</xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:text> </xsl:text>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@* | node()" mode="class" priority="-15"/>

  <xsl:template match="*" priority="-10">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@* | node()" priority="-15">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@data-hd-class" priority="10"/>

</xsl:stylesheet>
