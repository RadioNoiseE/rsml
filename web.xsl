<xsl:stylesheet version="1.0"
                xmlns:rsml="file://fake.path/2025/Markup/RsML"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="rsml mml">

  <!--

    Copyright Jing Huang 2024, 2025.

    Use and distribution of this code are permitted under the terms of the
    MIT License, compatible with Apache 2, GNU Generic Public License, etc.

    2024-2025        RsML1 for WEB

  -->

  <xsl:output method="xml" encoding="utf-8" indent="no"
              omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:if test="rsml:rsml/@version>1.0">
      <xsl:message terminate="yes">This sytlesheet supports only RsML 1.0, terminating...</xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="virgin"/>
  </xsl:template>

  <xsl:template name="verbatim">
    <xsl:param name="previous"/>
    <xsl:param name="current"/>
    <xsl:if test="string-length($current)>0">
      <xsl:variable name="line" select="substring-before($current,'&#10;')"/>
      <xsl:variable name="rest" select="substring-after($current,'&#10;')"/>
      <xsl:if test="string-length(normalize-space($line))>0 or
                    string-length(normalize-space($rest))>0 and
                    string-length(normalize-space($previous))>0">
        <span class="line"><span class="ln">
          <xsl:text>  </xsl:text>
          <span class="nsep">|</span>
          <span class="ld"><code>
            <xsl:value-of select="$line"/>
          </code></span>
        </span></span>
        <xsl:if test="string-length(normalize-space($rest))>0">
          <xsl:text>&#10;</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="verbatim">
        <xsl:with-param name="previous" select="$line"/>
        <xsl:with-param name="current" select="$rest"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="math" match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="math"/>
    </xsl:element>
  </xsl:template>

  <xsl:template mode="virgin" match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="virgin"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="virgin" match="rsml:rsml">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <xsl:if test="@language">
        <xsl:attribute name="lang">
          <xsl:value-of select="string(@language)"/>
        </xsl:attribute>
      </xsl:if>
      <head><xsl:apply-templates mode="preface" select="rsml:meta"/></head>
      <body>
        <xsl:apply-templates mode="initial"/>
        <footer><xsl:apply-templates mode="appendix" select="/rsml:rsml"/></footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template mode="preface" match="rsml:meta">
    <meta charset="utf-8"/>
    <meta name="creator" content="RsML1"/>
    <xsl:if test="rsml:author">
      <xsl:element name="meta">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="rsml:author"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
    <xsl:if test="rsml:date">
      <xsl:element name="meta">
        <xsl:attribute name="name">pubdate</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="descendant::rsml:year"/>
          <xsl:if test="descendant::rsml:day">
            <xsl:value-of select="substring-after(descendant::rsml:month,'-')"/>
            <xsl:value-of select="substring-after(descendant::rsml:day,'--')"/>
          </xsl:if>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
    <title>
      <xsl:value-of select="rsml:title"/>
      <xsl:if test="rsml:subtitle">
        <xsl:text> -- </xsl:text>
        <xsl:value-of select="rsml:subtitle"/>
      </xsl:if>
    </title>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:meta">
    <div class="header">
      <h1><xsl:apply-templates mode="horizontal" select="rsml:title"/></h1>
      <xsl:if test="rsml:subtitle">
        <h2><xsl:apply-templates mode="horizontal" select="rsml:subtitle"/></h2>
      </xsl:if>
      <xsl:if test="rsml:author or rsml:date">
        <div class="status"><p>
          <xsl:text>Published</xsl:text>
          <xsl:if test="rsml:date">
            <xsl:text> on </xsl:text>
            <xsl:if test="descendant::rsml:day">
              <xsl:value-of select="translate(descendant::rsml:day,'-','')"/>
              <xsl:text> </xsl:text>
              <xsl:variable name="month" select="translate(descendant::rsml:month,'-','')"/>
              <xsl:choose>
                <xsl:when test="$month='01'">January</xsl:when>
                <xsl:when test="$month='02'">February</xsl:when>
                <xsl:when test="$month='03'">March</xsl:when>
                <xsl:when test="$month='04'">April</xsl:when>
                <xsl:when test="$month='05'">May</xsl:when>
                <xsl:when test="$month='06'">June</xsl:when>
                <xsl:when test="$month='07'">July</xsl:when>
                <xsl:when test="$month='08'">August</xsl:when>
                <xsl:when test="$month='09'">September</xsl:when>
                <xsl:when test="$month='10'">October</xsl:when>
                <xsl:when test="$month='11'">November</xsl:when>
                <xsl:when test="$month='12'">December</xsl:when>
              </xsl:choose>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="descendant::rsml:year"/>
          </xsl:if>
          <xsl:if test="rsml:author">
            <xsl:text> by </xsl:text>
            <xsl:value-of select="rsml:author"/>
            <xsl:if test="rsml:affiliate">
              <xsl:text> </xsl:text>
              <xsl:value-of select="concat('(',rsml:affiliate,')')"/>
            </xsl:if>
          </xsl:if>
          <xsl:text>.</xsl:text>
        </p></div>
      </xsl:if>
      <xsl:if test="rsml:abstract">
        <div class="abstract"><p>
          <xsl:apply-templates mode="horizontal" select="rsml:abstract"/>
        </p></div>
      </xsl:if>
      <nav id="contents">
        <h2>Table of Contents</h2>
        <div class="toc"><ul class="toc">
          <xsl:for-each select="//rsml:unit[@role='chapter']"><li>
            <xsl:variable name="chapter">
              <xsl:number count="rsml:unit[@role='chapter']" format="1"/>
            </xsl:variable>
            <a href="#c{$chapter}">
              <span class="unit"><xsl:value-of select="$chapter"/></span>
              <span class="content"><xsl:value-of select="rsml:heading"/></span>
            </a>
            <xsl:if test="rsml:unit[@role='section']">
              <ul class="toc"><xsl:for-each select="rsml:unit[@role='section']">
                <xsl:variable name="section">
                  <xsl:number level="multiple" count="rsml:unit[@role='chapter' or @role='section']" format="1.1"/>
                </xsl:variable>
                <li><a href="#s{translate($section,'.','-')}">
                  <span class="unit"><xsl:value-of select="$section"/></span>
                  <span class="content"><xsl:value-of select="rsml:heading"/></span>
                </a></li>
              </xsl:for-each></ul>
            </xsl:if>
          </li></xsl:for-each>
        </ul></div>
      </nav>
    </div>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:unit">
    <xsl:apply-templates mode="vertical" select="node()"/>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:bibliography">
    <h2>Bibliography</h2>
    <xsl:for-each select="rsml:entry">
      <p class="bibentry">
        <cite class="title"><xsl:apply-templates mode="horizontal" select="rsml:title"/></cite>
        <xsl:text>. </xsl:text>
        <cite class="author"><xsl:value-of select="rsml:author"/></cite>
        <xsl:text>. </xsl:text>
        <cite class="year"><xsl:value-of select="rsml:year"/></cite>
        <xsl:text>.</xsl:text>
      </p>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="appendix" match="rsml:rsml">
    <div class="footnote">
      <xsl:for-each select="//rsml:footnote">
        <xsl:variable name="symbol" select="@symbol"/>
        <xsl:choose>
          <xsl:when test="$symbol">
            <sup><a id="f{generate-id($symbol)}">
              <xsl:value-of select="$symbol"/>
            </a></sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates mode="horizontal"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="label">
              <xsl:number count="//rsml:footnote" format="1"/>
            </xsl:variable>
            <sup><a id="f{$label}">
              <xsl:value-of select="$label"/>
            </a></sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates mode="horizontal"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:quote">
    <xsl:text>&quot;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:apostrophe">
    <xsl:text>&apos;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:ampersand">
    <xsl:text>&amp;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:langle">
    <xsl:text>&lt;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:rangle">
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:space">
    <xsl:text>&#160;</xsl:text>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:emphasize">
    <em><xsl:apply-templates mode="horizontal"/></em>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:highlight">
    <mark><xsl:apply-templates mode="horizontal"/></mark>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:math">
    <math display="inline"><xsl:apply-templates mode="math" select="node()"/></math>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:verbatim">
    <code><xsl:apply-templates mode="horizontal"/></code>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:term">
    <span class="term"><xsl:apply-templates mode="horizontal"/></span>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:abbreviation">
    <abbr><xsl:apply-templates mode="horizontal"/></abbr>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:keyword">
    <span class="keyword"><xsl:apply-templates mode="horizontal"/></span>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:link">
    <a href="{text()}"><xsl:choose>
      <xsl:when test="@literal"><xsl:value-of select="string(@literal)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
    </xsl:choose></a>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:label">
    <a href="l{generate-id()}"/>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:refer">
    <xsl:variable name="type" select="@type"/>
    <xsl:variable name="label" select="@label"/>
    <xsl:choose>
      <xsl:when test="$type='chapter'">
        <a href="#c{$label}">
          <xsl:text>Chapter </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='section'">
        <a href="#s{translate($label,'.','-')}">
          <xsl:text>Section </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='subsection'">
        <a href="#z{translate($label,'.','-')}">
          <xsl:text>Subsection </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='label'">
        <xsl:variable name="xref">
          <xsl:value-of select="generate-id($label)"/>
        </xsl:variable>
        <a href="#l{$xref}">
          <xsl:text>Label </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='figure'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:figure[@label=$label]"/>
        </xsl:variable>
        <a href="#f{translate($xref,'.','-')}">
          <xsl:text>Figure </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='table'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:table[@label=$label]"/>
        </xsl:variable>
        <a href="#t{translate($xref,'.','-')}">
          <xsl:text>Table </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='math'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:math[@label=$label]"/>
        </xsl:variable>
        <a href="#m{translate($xref,'.','-')}">
          <xsl:text>Equation </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='verbatim'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:verb[@label=$label]"/>
        </xsl:variable>
        <a href="#v{translate($xref,'.','-')}">
          <xsl:text>Verbatim </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:footnote">
    <xsl:variable name="symbol" select="@symbol"/>
    <xsl:choose>
      <xsl:when test="$symbol">
        <sup><a href="#f{generate-id($symbol)}">
          <xsl:value-of select="$symbol"/>
        </a></sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="label">
          <xsl:number count="//rsml:footnote" format="1"/>
        </xsl:variable>
        <sup><a href="#f{$label}">
          <xsl:value-of select="$label"/>
        </a></sup>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:heading">
    <xsl:variable name="level" select="parent::rsml:unit/@role"/>
    <xsl:choose>
      <xsl:when test="$level='chapter'">
        <xsl:variable name="chapter">
          <xsl:number count="rsml:unit[@role='chapter']" format="1"/>
        </xsl:variable>
        <h2 id="c{$chapter}"><xsl:apply-templates mode="horizontal"/></h2>
      </xsl:when>
      <xsl:when test="$level='section'">
        <xsl:variable name="section">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter' or @role='section']" format="1-1"/>
        </xsl:variable>
        <h3 id="s{$section}"><xsl:apply-templates mode="horizontal"/></h3>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="subsection">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter' or @role='section' or @role='subsection']" format="1-1-1"/>
        </xsl:variable>
        <h4 id="z{$subsection}"><xsl:apply-templates mode="horizontal"/></h4>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:paragraph">
    <p><xsl:apply-templates mode="horizontal"/></p>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:list">
    <xsl:variable name="type" select="@type"/>
    <xsl:choose>
      <xsl:when test="$type='enumerate'">
        <ol><xsl:apply-templates mode="inner" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></ol>
      </xsl:when>
      <xsl:when test="$type='itemize'">
        <ul><xsl:apply-templates mode="inner" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></ul>
      </xsl:when>
      <xsl:otherwise>
        <dl><xsl:apply-templates mode="inner" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></dl>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="inner" match="rsml:list">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type='description'">
        <xsl:for-each select="rsml:item">
          <dt><xsl:value-of select="@name"/></dt>
          <dd><xsl:apply-templates mode="horizontal"/></dd>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="rsml:item">
          <li><xsl:apply-templates mode="horizontal"/></li>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:figure">
    <figure>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:figure" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('f',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <img src="{rsml:image}" alt="{rsml:image}">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
            <xsl:otherwise>center</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="@size">
          <xsl:attribute name="width">
            <xsl:value-of select="concat(substring-after(@size,'r'),'%')"/>
          </xsl:attribute>
        </xsl:if>
      </img>
      <xsl:if test="rsml:caption">
        <figcaption><xsl:apply-templates mode="horizontal" select="rsml:caption"/></figcaption>
      </xsl:if>
    </figure>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:figure">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:figure" format="1.1"/>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:table">
    <table>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:table" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('t',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
          <xsl:otherwise>center</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="rsml:caption">
        <caption><xsl:apply-templates mode="horizontal" select="rsml:caption"/></caption>
      </xsl:if>
      <xsl:if test="rsml:head">
        <thead><xsl:apply-templates mode="inner" select=".">
          <xsl:with-param name="type" select="rsml:head"/>
        </xsl:apply-templates></thead>
      </xsl:if>
      <tbody><xsl:apply-templates mode="inner" select=".">
        <xsl:with-param name="type" select="rsml:body"/>
      </xsl:apply-templates></tbody>
      <xsl:if test="rsml:foot">
        <tfoot><xsl:apply-templates mode="inner" select=".">
          <xsl:with-param name="type" select="rsml:foot"/>
        </xsl:apply-templates></tfoot>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template mode="inner" match="rsml:table">
    <xsl:param name="type"/>
    <xsl:for-each select="$type/rsml:column">
      <tr>
        <xsl:for-each select="rsml:cell">
          <th>
            <xsl:if test="@rowspan">
              <xsl:attribute name="rowspan">
                <xsl:value-of select="@rowspan"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@colspan">
              <xsl:attribute name="colspan">
                <xsl:value-of select="@colspan"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="horizontal"/>
          </th>
        </xsl:for-each>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:table">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:table" format="1.1"/>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:math">
    <math display="block">
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:math" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('m',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="math" select="node()"/>
    </math>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:math">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:math" format="1.1"/>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:verbatim">
    <pre>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:verbatim" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('v',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="verbatim">
        <xsl:with-param name="current" select="text()"/>
      </xsl:call-template>
    </pre>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:verbatim">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:verbatim" format="1.1"/>
  </xsl:template>

</xsl:stylesheet>
