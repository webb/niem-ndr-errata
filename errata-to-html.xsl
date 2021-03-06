<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   version="2.0"
   xmlns:e="http://example.org/errata"
   xmlns:this="http://example.org/errata-to-html"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" version="1.0" indent="no"/>

  <xsl:template match="/e:errata">
    <html>
      <head>
        <title>Errata for <xsl:value-of select="@subject"/></title>
        <style test="text/css" media="all"
               ><xsl:value-of select="unparsed-text('all.css')"/></style>
      </head>
      <body>
        <h1><xsl:value-of select="@subject"/></h1>
        <p><xsl:value-of select="@date"/></p>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="e:doc">
    <h2>Errata for <a href="{@uri}" target="other"><xsl:value-of select="@name"/>, version <xsl:value-of select="@version"/></a>.</h2>
    <div class="indent">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
        
  <xsl:template match="e:section | e:rule">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="e:revision">
    <xsl:variable name="anchor-context" select="ancestor-or-self::*[@anchor
                                                                    or self::e:rule
                                                                    or self::e:section][1]"/>
    <xsl:variable name="anchor" as="xs:string"
                  select="if ($anchor-context/@anchor)
                          then $anchor-context/@anchor
                          else if ($anchor-context/self::e:rule)
                               then concat('rule_', $anchor-context/@number)
                               else if ($anchor-context/self::e:section)
                                    then concat('section_', $anchor-context/@number)
                                    else ()"/>

    <xsl:variable name="contexts" as="element()*"
                  select="ancestor::*[self::e:rule or self::e:section]"/>

    <xsl:variable name="has-from" as="xs:boolean" select="exists(descendant::e:from)"/>

    <p>
      <xsl:text>In </xsl:text>
      <a href="{ancestor::e:doc[1]/@uri}#{$anchor}" target="other">
        <xsl:value-of select="string-join(for $context in $contexts return this:get-context-string($context), ', in ')"/>
      </a>
      <xsl:choose>
        <xsl:when test="$has-from">
          <xsl:text>, revise:</xsl:text>
        </xsl:when>
        <xsl:otherwise>, revise to:</xsl:otherwise>
      </xsl:choose>
    </p>
    <div class="indent">
      <xsl:if test="$has-from">
        <xsl:apply-templates select="e:from"/>
        <p>to:</p>
      </xsl:if>
      <xsl:apply-templates select="e:to"/>
    </div>
  </xsl:template>

  <xsl:template match="e:from | e:to">
    <div class="quote">
      <xsl:choose>
        <xsl:when test="exists(descendant::*)">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:if test="@pre = 'true'">
              <xsl:attribute name="class">pre</xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xsl:template match="text()" priority="-1"/>

  <xsl:template match="e:p//text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:function name="this:get-context-string" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:value-of>
      <xsl:choose>
        <xsl:when test="$context/self::e:section">
          <xsl:text>section </xsl:text>
        </xsl:when>
        <xsl:when test="$context/self::e:rule">
        <xsl:text>rule </xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$context/@number"/>
      <xsl:text>, &#8220;</xsl:text>
      <xsl:value-of select="$context/@name"/>
      <xsl:text>&#8221;</xsl:text>
    </xsl:value-of>
  </xsl:function>

  <xsl:template match="e:code | e:var | e:li | e:ul | e:p | e:em">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" priority="-1">
    <xsl:message terminate="yes">Unexpected element: <xsl:value-of select="name()"/>.</xsl:message>
  </xsl:template>

</xsl:stylesheet>
<!--
Local Variables:
mode: sgml
indent-tabs-mode: nil
fill-column: 9999
End:
-->
