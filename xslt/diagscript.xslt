<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:diag="http://redgates.com/2012/12/diagnostics"
                xmlns:os="http://redgates.com/2012/12/os"
                version='1.0'>

  <dc:title>Create diagnostics script</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  Create a script that creates a diagnostic archive defined by the
  diagnostic rdf description, based on the current system.

  This should work for any system type understood by the RDF info.
  </dc:description>

  <xsl:param name='operatingSystemName' as="xsd:string">Linux</xsl:param>
  <xsl:param name='operatingSystemReleaseMajor' as="xsd:string">2</xsl:param>
  <xsl:param name='operatingSystemReleaseMinor' as="xsd:string">6</xsl:param>
  <xsl:param name='operatingSystemReleasePatch' as="xsd:string">32</xsl:param>

  <xsl:param name='archiveType' as="xsd:string">CallHome</xsl:param>
  <xsl:param name='archiveName' as="xsd:string">DiagArchive</xsl:param>

  <xsl:key name='component' match='/rdf:RDF/node()' use='@rdf:about' />
  <xsl:key name='os' match='/rdf:RDF/os:Platform' use='rdfs:label' />

  <xsl:variable name='commandInterpreter' as="xsd:string">
      <xsl:choose>
        <xsl:when test='$operatingSystemName = "Windows"'>powershell</xsl:when>
        <xsl:otherwise>bash</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>

  <xsl:variable name='archiveRef' as="xsd:string">
      <xsl:text>http://redgates.com/2012/12/diagnostics/Archive/</xsl:text>
      <xsl:value-of select='$archiveType' />
  </xsl:variable>

  <xsl:variable name='osRef' as="xsd:string">
      <xsl:value-of select='key("os",$operatingSystemName)/@rdf:about' />
  </xsl:variable>

  <xsl:output method="text"/>

  <xsl:template match='text()' />
  <xsl:template match='text()' mode='bash' />
  <xsl:template match='text()' mode='powershell' />

  <dc:description>
  Only process the Archive that matches the archive type requested.
  </dc:description>
  <xsl:template match='/'>
      <xsl:choose>
        <xsl:when test='$commandInterpreter = "powershell"'>
            <xsl:apply-templates mode='powershell' />
        </xsl:when>
        <xsl:when test='$commandInterpreter = "bash"'>
            <xsl:apply-templates mode='bash' />
        </xsl:when>
        <xsl:otherwise>
            <xsl:text># Unsupported platform&#10;</xsl:text>
            <xsl:text>echo "Unsupported platform&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <dc:description>
  Only process the Archive that matches the archive type requested.
  </dc:description>
  <xsl:template match='rdf:RDF' mode='bash'>
      <xsl:text>#!/bin/bash&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text># automatically generated from diagnostics.rdf&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text><![CDATA[
cd /tmp
echo METADATA > MANIFEST
echo MANIFEST >> MANIFEST
echo "ArchiveName: ]]></xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text><![CDATA[" > METADATA
echo "ArchiveRef: ]]></xsl:text>
      <xsl:value-of select='$archiveRef' />
      <xsl:text><![CDATA[" > METADATA
echo "ArchiveType: ]]></xsl:text>
      <xsl:value-of select='$archiveType' />
      <xsl:text><![CDATA[" >> METADATA
date >> METADATA
]]></xsl:text>
      <xsl:apply-templates select='diag:Archive[@rdf:about=$archiveRef]' mode='bash' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>ARCHIVE=</xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text><![CDATA[
zip $ARCHIVE --quiet --recurse-paths --names-stdin < MANIFEST || : ignore errors
]]></xsl:text>
  </xsl:template>

  <dc:description>
  Only process the Archive that matches the archive type requested.
  </dc:description>
  <xsl:template match='rdf:RDF' mode='powershell'>
      <xsl:text># PowerShell&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text># automatically generated from diagnostics.rdf&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text><![CDATA[
Set-Location c:\tmp
echo METADATA > MANIFEST
echo MANIFEST >> MANIFEST
echo "ArchiveName: ]]></xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text><![CDATA[" > METADATA
echo "ArchiveRef: ]]></xsl:text>
      <xsl:value-of select='$archiveRef' />
      <xsl:text><![CDATA[" > METADATA
echo "ArchiveType: ]]></xsl:text>
      <xsl:value-of select='$archiveType' />
      <xsl:text><![CDATA[" >> METADATA
date >> METADATA
]]></xsl:text>
      <xsl:apply-templates select='diag:Archive[@rdf:about=$archiveRef]' mode='powershell' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>ARCHIVE=</xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text><![CDATA[
zip $ARCHIVE --quiet --recurse-paths --names-stdin < MANIFEST || : ignore errors
]]></xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Archive' mode='bash' >
      <xsl:text># Archive: </xsl:text>
      <xsl:value-of select='@rdf:about' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:apply-templates mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Archive' mode='powershell' >
      <xsl:text># Archive: </xsl:text>
      <xsl:value-of select='@rdf:about' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:apply-templates mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:component' mode='bash' >
      <xsl:text># Component: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:component' mode='powershell' >
      <xsl:text># Component: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:include' mode='bash' >
      <xsl:text># Include: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:include' mode='powershell' >
      <xsl:text># Include: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Directory' mode='bash' >
      <xsl:apply-templates select='diag:path' mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Directory' mode='powershell' >
      <xsl:apply-templates select='diag:path' mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:LogFile' mode='bash' >
      <xsl:apply-templates select='diag:path' mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:LogFile' mode='powershell' >
      <xsl:apply-templates select='diag:path' mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Query' mode='bash'>
    <xsl:variable name='about' as="xsd:string">
        <xsl:value-of select='@rdf:about' />
    </xsl:variable>

      <xsl:text>function </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>() {&#10;</xsl:text>

      <xsl:text>#OS </xsl:text>
      <xsl:value-of select='$osRef' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates
          select='/rdf:RDF/diag:Execute[diag:forPlatform/@rdf:resource=$osRef][diag:answersQuery/@rdf:resource=$about]'
          mode='bash' />

      <xsl:text>}&#10;</xsl:text>
      <xsl:text>echo </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>.log &gt;&gt; MANIFEST &#10;</xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text> &gt; </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>.log&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Query' mode='powershell' >
    <xsl:variable name='about' as="xsd:string">
        <xsl:value-of select='@rdf:about' />
    </xsl:variable>

      <xsl:text>function </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text> {&#10;</xsl:text>

      <xsl:text>#OS </xsl:text>
      <xsl:value-of select='$osRef' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>  Begin {&#10;</xsl:text>
      <xsl:apply-templates
          select='/rdf:RDF/diag:Execute[diag:forPlatform/@rdf:resource=$osRef][diag:answersQuery/@rdf:resource=$about]'
          mode='powershell' />

      <xsl:text>  }&#10;</xsl:text>
      <xsl:text>  End {&#10;</xsl:text>
      <xsl:text>  # Put write-output here?&#10;</xsl:text>
      <xsl:text>  }&#10;</xsl:text>
      <xsl:text>}&#10;</xsl:text>
      <xsl:text>Write-Output "</xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>.log" &gt;&gt; MANIFEST &#10;</xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text> &gt; </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>.log&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Execute' mode='bash' >
      <xsl:apply-templates select='diag:command' mode='bash' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Execute' mode='powershell' >
      <xsl:apply-templates select='diag:command' mode='powershell' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:path'>
      <xsl:text># ERROR - no mode &#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Within an archive component type, add the specific path to the list of
  archive components to put in the archive.
  </dc:description>
  <xsl:template match='diag:path' mode='bash'>
      <xsl:text>for path in </xsl:text><xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>do&#10;</xsl:text>
      <xsl:text>echo $path &gt;&gt; MANIFEST &#10;</xsl:text>
      <xsl:text>done&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Within an archive component type, add the specific path to the list of
  archive components to put in the archive.
  </dc:description>
  <xsl:template match='diag:path' mode='powershell'>
      <xsl:text>For-Each </xsl:text><xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>do&#10;</xsl:text>
      <xsl:text>Write-Output $path &gt;&gt; MANIFEST &#10;</xsl:text>
      <xsl:text>done&#10;</xsl:text>
  </xsl:template>


  <dc:description>
  Within an archive component type, add the specific shell command line to the
  scriptlet that provides the output.
  </dc:description>
  <xsl:template match='diag:command' mode='bash' >
      <xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Within an archive component type, add the specific shell command line to the
  scriptlet that provides the output.
  </dc:description>
  <xsl:template match='diag:command' mode='powershell' >
      <xsl:text>Start-Process -wait -FilePath "</xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>"&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
