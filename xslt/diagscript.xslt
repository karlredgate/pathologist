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

  <xsl:param name='kernelName' as="xsd:string">Linux</xsl:param>
  <xsl:param name='distroName' as="xsd:string"></xsl:param>
  <xsl:param name='distroReleaseMajor' as="xsd:string"></xsl:param>
  <xsl:param name='distroReleaseMinor' as="xsd:string"></xsl:param>
  <xsl:param name='distroReleasePatch' as="xsd:string"></xsl:param>

  <xsl:param name='archiveType' as="xsd:string">CallHome</xsl:param>
  <xsl:param name='archiveName' as="xsd:string">DiagArchive</xsl:param>

  <xsl:variable name='archiveRef' as="xsd:string">
      <xsl:text>http://redgates.com/2012/12/diagnostics/Archive/</xsl:text>
      <xsl:value-of select='$archiveType' />
  </xsl:variable>

  <xsl:variable name='fullDistroLabel' as="xsd:string">
      <xsl:value-of select='$distroName' />
      <xsl:value-of select='$distroReleaseMajor' />
  </xsl:variable>

  <xsl:key name='platform' match='/rdf:RDF/diag:Platform' use='rdfs:label' />
  <xsl:key name='component' match='/rdf:RDF/node()' use='@rdf:about' />

  <xsl:variable name='kernelURI' as="xsd:string">
      <xsl:value-of select='key("platform",$kernelName)/@rdf:about' />
  </xsl:variable>

  <xsl:variable name='distroURI' as="xsd:string">
      <xsl:value-of select='key("platform",$distroName)/@rdf:about' />
  </xsl:variable>

  <xsl:variable name='fullDistroURI' as="xsd:string">
      <xsl:value-of select='key("platform",$fullDistroLabel)/@rdf:resource' />
      <xsl:value-of select='$distroReleaseMajor' />
  </xsl:variable>

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  Only process the Archive that matches the archive type requested.
  </dc:description>
  <xsl:template match='/rdf:RDF'>
      <xsl:text>#!/bin/bash&#10;</xsl:text>
      <xsl:text># kernelName:      </xsl:text><xsl:value-of select='$kernelName' /><xsl:text>&#10;</xsl:text>
      <xsl:text># kernelURI:       </xsl:text><xsl:value-of select='$kernelURI' /><xsl:text>&#10;</xsl:text>
      <xsl:text># distroName:      </xsl:text><xsl:value-of select='$distroName' /><xsl:text>&#10;</xsl:text>
      <xsl:text># distroURI:       </xsl:text><xsl:value-of select='$distroURI' /><xsl:text>&#10;</xsl:text>
      <xsl:text># fullDistroLabel: </xsl:text><xsl:value-of select='$fullDistroLabel' /><xsl:text>&#10;</xsl:text>
      <xsl:text># fullDistroURI:   </xsl:text><xsl:value-of select='$fullDistroURI' /><xsl:text>&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text># automatically generated from diagnostics.rdf&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:text><![CDATA[
TMPDIR=/tmp/diag$$
mkdir $TMPDIR
cd $TMPDIR
echo METADATA > MANIFEST
echo MANIFEST >> MANIFEST
echo "ArchiveName: ]]></xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text><![CDATA[" > METADATA
echo "ArchiveType: ]]></xsl:text>
      <xsl:value-of select='$archiveType' />
      <xsl:text><![CDATA[" >> METADATA
date >> METADATA
]]></xsl:text>
      <xsl:apply-templates select='diag:Archive[@rdf:about=$archiveRef]' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>ARCHIVE=</xsl:text>
      <xsl:value-of select='$archiveName' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text><![CDATA[
# tar -c -T MANIFEST -f support.tar.xz 2> /dev/null || : ignore errors
zip $ARCHIVE --quiet --recurse-paths --names-stdin < MANIFEST || : ignore errors
rm -rf $TMPDIR
]]></xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Archive'>
      <xsl:text># Archive: </xsl:text>
      <xsl:value-of select='@rdf:about' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>#&#10;</xsl:text>
      <xsl:apply-templates/>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:component'>
      <xsl:text># Component: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:include'>
      <xsl:text># Include: </xsl:text>
      <xsl:value-of select='@rdf:resource' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='key("component",@rdf:resource)' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Directory'>
      <xsl:apply-templates select='diag:path' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:LogFile'>
      <xsl:apply-templates select='diag:path' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='diag:Query'>
      <xsl:variable name='query' as="xsd:string" select='@rdf:about' />

      <xsl:text>function </xsl:text>
      <xsl:value-of select='rdfs:label' />
      <xsl:text>() {&#10;</xsl:text>

      <xsl:apply-templates select='/rdf:RDF/diag:Execute[ diag:answersQuery/@rdf:resource = $query and
                                                          diag:forPlatform/@rdf:resource = $distroURI ]' />
      <xsl:apply-templates select='/rdf:RDF/diag:Execute[ diag:answersQuery/@rdf:resource = $query and
                                                          diag:forPlatform/@rdf:resource = $kernelURI ]' />

      <xsl:text>   : end of func&#10;</xsl:text>
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
  <xsl:template match='diag:Execute'>
      <xsl:text>: "</xsl:text>
      <xsl:value-of select='diag:forPlatform/@rdf:resource' />
      <xsl:text>" command&#10;</xsl:text>
      <xsl:value-of select='diag:command' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Within an archive component type, add the specific path to the list of
  archive components to put in the archive.
  </dc:description>
  <xsl:template match='diag:path'>
      <xsl:text>for path in </xsl:text><xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>do&#10;</xsl:text>
      <xsl:text>echo $path &gt;&gt; MANIFEST &#10;</xsl:text>
      <xsl:text>done&#10;</xsl:text>
  </xsl:template>


</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4: -->
