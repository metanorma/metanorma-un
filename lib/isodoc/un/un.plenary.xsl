<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:un="https://www.metanorma.org/ns/un" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:redirect="http://xml.apache.org/xalan/redirect" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java redirect" extension-element-prefixes="redirect" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name'])) and not(ancestor::*[local-name() = 'bibdata'] and ancestor::*[local-name() = 'abstract'])]" use="@reference"/>

	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="contents_">
		<contents>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>

			<xsl:apply-templates select="/un:un-standard/un:sections/*" mode="contents"/>
			<xsl:apply-templates select="/un:un-standard/un:annex" mode="contents"/>
			<xsl:apply-templates select="/un:un-standard/un:bibliography/un:references" mode="contents"/>

			<xsl:call-template name="processTablesFigures_Contents"/>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:variable name="title" select="/un:un-standard/un:bibdata/un:title[@language = 'en' and @type = 'main']"/>

	<xsl:variable name="id" select="/un:un-standard/un:bibdata/un:ext/un:session/un:id"/>

	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="17.5mm" margin-bottom="10mm" margin-left="20mm" margin-right="20mm"/>
					<fo:region-before extent="17.5mm"/>
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="20mm"/>
					<fo:region-end extent="20mm"/>
				</fo:simple-page-master>

				<!-- Document odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="26mm"/>
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="26mm"/>
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- Document even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="26mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="26mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container border-bottom="0.5pt solid black" margin-bottom="6pt">
						<fo:block text-align-last="justify">
							<fo:inline padding-right="22mm"> </fo:inline>
							<fo:inline font-size="14pt" baseline-shift="15%"><xsl:value-of select="/un:un-standard/un:bibdata/un:contributor/un:organization/un:name"/></fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<fo:inline font-size="20pt"><xsl:value-of select="substring-before($id, '/')"/></fo:inline>
								<fo:inline font-size="10pt">/<xsl:value-of select="substring-after($id, '/')"/></fo:inline>
							</fo:inline>
						</fo:block>
					</fo:block-container>
					<fo:block-container height="48mm">
						<fo:block>
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="22mm"/>
								<fo:table-column column-width="98mm"/>
								<fo:table-column column-width="50mm"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell padding-left="0.5mm">
											<fo:block>
												<!-- <fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="28mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/> -->
												<fo:instream-foreign-object content-width="19.5mm" fox:alt-text="Image Logo UN">
													<xsl:copy-of select="$Image-Logo-SVG"/>
												</fo:instream-foreign-object>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block font-size="20pt" font-weight="bold">Economic and Social Council</fo:block>
										</fo:table-cell>
										<fo:table-cell font-size="10pt">
											<fo:block margin-top="8pt">
												<xsl:text>Distr.: </xsl:text><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:distribution"/>
											</fo:block>
											<fo:block margin-bottom="12pt">
												<xsl:call-template name="convertDate">
													<xsl:with-param name="date" select="/un:un-standard/un:bibdata/un:version/un:revision-date"/>
													<xsl:with-param name="format">ddMMyyyy</xsl:with-param>
												</xsl:call-template>
											</fo:block>
											<fo:block>
												<xsl:text>Original: </xsl:text>
												<xsl:call-template name="getLanguage">
													<xsl:with-param name="lang" select="/un:un-standard/un:bibdata/un:language"/>
												</xsl:call-template>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block-container>
					<!-- <fo:block margin-bottom="24pt">&#xA0;</fo:block> -->
					<fo:block-container font-weight="bold" border-top="1.5pt solid black">
						<fo:block font-size="14pt" padding-top="0.5mm" margin-top="6pt" margin-bottom="6pt">Economic Commission for Europe</fo:block>
						<fo:block font-size="12pt" margin-bottom="6pt">UNECE Executive Committee</fo:block>
						<fo:block font-size="12pt" margin-bottom="6pt"><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:editorialgroup/un:committee"/></fo:block>
						<fo:block font-size="10pt">
							<fo:block font-weight="bold">
								<!-- Example: 24 -> Twenty-fourth session -->
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="/un:un-standard/un:bibdata/un:ext/un:session/un:number"/>
									<xsl:with-param name="first" select="'true'"/>
								</xsl:call-template>
								<xsl:text>session</xsl:text>
							</fo:block>
							<fo:block font-weight="normal">
								<xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:session/un:date"/>
							</fo:block>
							<fo:block font-weight="normal">
								<xsl:text>Item 1 of the </xsl:text><xsl:value-of select="java:toLowerCase(java:java.lang.String.new(/un:un-standard/un:sections/un:clause[1]/un:title))"/>
							</fo:block>
							<fo:block>
								<xsl:value-of select="translate(/un:un-standard/un:sections/un:clause[1]/un:ol[1]/un:li[1]/un:p[1], '.', '')"/>
							</fo:block>
							<fo:block role="H1"><xsl:value-of select="$title"/></fo:block>
						</fo:block>
					</fo:block-container>

					<!-- <xsl:apply-templates select="/un:un-standard/un:preface/un:foreword"/> -->

					<fo:block-container font-weight="bold" margin-left="20mm" margin-top="10pt">
						<fo:block margin-left="-20mm">
							<fo:block font-size="17pt" margin-bottom="16pt">
								<xsl:value-of select="$title"/>

								<xsl:for-each select="/un:un-standard/un:bibdata/un:note[@type = 'title-footnote']">
									<xsl:variable name="number" select="position()"/>
									<fo:inline font-size="14pt" baseline-shift="15%" font-weight="normal">
										<xsl:if test="$number = 1">
											<xsl:text> </xsl:text>
										</xsl:if>
										<fo:basic-link internal-destination="title-footnote_{$number}" fox:alt-text="title footnote">
											<xsl:call-template name="repeat">
												<xsl:with-param name="char" select="'*'"/>
												<xsl:with-param name="count" select="$number"/>
											</xsl:call-template>
										</fo:basic-link>
										<xsl:if test="position() != last()"><fo:inline baseline-shift="20%">,</fo:inline></xsl:if>
									</fo:inline>
								</xsl:for-each>

								<xsl:for-each select="/un:un-standard/un:bibdata/un:note[@type = 'title-footnote']">
									<xsl:variable name="number" select="position()"/>
									<fo:block id="title-footnote_{$number}" font-size="14pt" font-weight="normal">
										<xsl:if test="$number = 1">
											<xsl:attribute name="margin-top">12pt</xsl:attribute>
										</xsl:if>
										<xsl:call-template name="repeat">
											<xsl:with-param name="char" select="'*'"/>
											<xsl:with-param name="count" select="$number"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:apply-templates/>
									</fo:block>
								</xsl:for-each>

							</fo:block>

							<fo:block font-size="14pt" margin-bottom="16pt">
								<xsl:value-of select="/un:un-standard/un:bibdata/un:title[@language = 'en' and @type = 'subtitle']"/>
							</fo:block>
							<xsl:if test="/un:un-standard/un:bibdata/un:ext/un:session/un:collaborator">
								<fo:block font-size="14pt" margin-bottom="22pt">
									<xsl:text>Developed in Collaboration with the </xsl:text><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:session/un:collaborator"/>
								</fo:block>
							</xsl:if>
						</fo:block>
					</fo:block-container>

					<xsl:apply-templates select="/un:un-standard/un:preface/un:abstract"/>

					<xsl:variable name="charsToRemove" select="concat($upper, $lower, '.()~!@#$%^*-+:')"/>
					<xsl:variable name="code" select="translate(/un:un-standard/un:bibdata/un:docidentifier, $charsToRemove,'')"/>

					<fo:block-container absolute-position="fixed" left="20mm" top="258mm" width="30mm" text-align="center" id="__internal_layout__barcode_{generate-id()}">
						<fo:block font-size="10pt" text-align="left">
							<xsl:value-of select="/un:un-standard/un:bibdata/un:docidentifier"/>
						</fo:block>

						<fo:block padding-top="1mm">
							<xsl:if test="normalize-space($code) != ''">
								<fo:instream-foreign-object fox:alt-text="Barcode">
									<barcode:barcode message="{$code}">
										<barcode:code39>
											<barcode:height>8.5mm</barcode:height>
											<barcode:module-width>0.24mm</barcode:module-width>
											<barcode:human-readable>
												<barcode:placement>none</barcode:placement>
												<!--<barcode:pattern>* _ _ _ _ _ _ _ _ _ *</barcode:pattern>
												<barcode:font-name>Arial</barcode:font-name>
												<barcode:font-size>9.7pt</barcode:font-size> -->
											</barcode:human-readable>
										</barcode:code39>
									</barcode:barcode>
								</fo:instream-foreign-object>
							</xsl:if>
						</fo:block>
						<fo:block padding-top="-0.8mm" text-align="left" font-family="Arial" font-size="8pt" letter-spacing="1.8mm">
							<xsl:value-of select="concat('*', $code, '*')"/>
						</fo:block>
					</fo:block-container>

					<fo:block-container absolute-position="fixed" left="143mm" top="262mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Recycle))}" width="26mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Recycle"/>
						</fo:block>
					</fo:block-container>
					<fo:block-container absolute-position="fixed" left="170mm" top="253mm">
						<fo:block>
							<xsl:if test="normalize-space(/un:un-standard/un:bibdata/un:ext/un:session/un:id) != ''">
								<fo:instream-foreign-object fox:alt-text="Barcode">
									<barcode:barcode message="{concat('http://undocs.org/', /un:un-standard/un:bibdata/un:ext/un:session/un:id)}">
										<barcode:qr>
											<barcode:module-width>0.55mm</barcode:module-width>
											<barcode:ec-level>M</barcode:ec-level>
										</barcode:qr>
									</barcode:barcode>
								</fo:instream-foreign-object>
							</xsl:if>
						</fo:block>
					</fo:block-container>

				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->

			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
				<!-- <xsl:copy-of select="."/> -->
			</xsl:variable>

			<xsl:for-each select="xalan:nodeset($updated_xml)/*">

				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsUN_items"/>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->

					<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">

						<!-- Document Pages -->
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force" line-height="115%">

							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>

							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">2</xsl:attribute>
							</xsl:if>

							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block-container margin-left="-8mm">
									<fo:block margin-left="8mm">
										<fo:leader leader-pattern="rule" leader-length="20%"/>
									</fo:block>
								</fo:block-container>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">

								<!-- <xsl:if test="$debug = 'true'">
									<redirect:write file="contents_{java:getTime(java:java.util.Date.new())}.xml">
										<xsl:copy-of select="$contents"/>
									</redirect:write>
								</xsl:if> -->

								<!-- Preface Pages (except Abstract, that showed in Summary on cover page`) -->
								<!-- <xsl:if test="/un:un-standard/un:preface/*[not(local-name() = 'abstract' or local-name() = 'note' or local-name() = 'admonition' or (local-name() = 'clause' and @type = 'toc'))]">
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition' and
									not(local-name() = 'clause' and @type = 'toc')]" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" />
									<fo:block break-after="page"/>
								</xsl:if>
								
								<fo:block>
									<xsl:apply-templates select="/un:un-standard/un:sections/*"/>
									<xsl:apply-templates select="/un:un-standard/un:annex"/>
									<xsl:apply-templates select="/un:un-standard/un:bibliography/un:references"/>
								</fo:block> -->

								<xsl:apply-templates/>

								<fo:block/> <!-- prevent empty fo:flow -->

								<xsl:if test="position() = last()">
									<fo:block-container margin-left="50mm" width="30mm" border-bottom="0.5pt solid black" margin-top="12pt" keep-with-previous="always">
										<fo:block> </fo:block>
									</fo:block-container>
								</xsl:if>
							</fo:flow>
						</fo:page-sequence>
						<!-- End Document Pages -->
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>

		</fo:root>
	</xsl:template>

	<xsl:template name="processPrefaceAndMainSectionsUN_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">

			<xsl:element name="{$root_element}" namespace="{$namespace_full}">

				<xsl:call-template name="copyCommonElements"/>

				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->

						<!-- Preface Pages (except Abstract, that showed in Summary on cover page`) -->
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition' and       not(local-name() = 'clause' and @type = 'toc')]" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="update_xml_step_move_pagebreak"/>

					</xsl:element> <!-- preface -->
				</xsl:element>

				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>

			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsUN_items -->

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[un:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="un:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="$level &gt; $toc_level">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::un:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::un:term">true</xsl:when>
				<xsl:when test="@inline-header = 'true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>

			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>

			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
		</xsl:if>

	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->

	<!-- ============================= -->
	<!-- PARAGRAPHS                                    -->
	<!-- ============================= -->

	<xsl:template match="un:preface/un:abstract" priority="3">
		<fo:block>
			<fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
				<fo:table-column column-width="19mm"/>
				<fo:table-column column-width="134mm"/>
				<fo:table-column column-width="17mm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell padding-left="6mm" padding-top="2.5mm" number-columns-spanned="3">
							<fo:block font-size="12pt" font-style="italic" margin-bottom="6pt" role="H2">
								<xsl:apply-templates select="un:title/node()"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
							<fo:block> </fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="justify" padding-bottom="12pt" padding-right="3mm">
							<fo:block font-size="10pt" line-height="120%"><xsl:apply-templates select="node()[not(self::un:title)]"/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block> </fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:abstract//un:p" priority="3">
		<fo:block margin-bottom="6pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:preface//un:p" priority="2">
		<fo:block margin-bottom="12pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:clause[@inline-header = 'true']" priority="3">
		<fo:block-container margin-left="1mm">
			<fo:block-container margin-left="0mm">
				<fo:list-block provisional-distance-between-starts="9mm">
					<xsl:call-template name="setId"/>
					<xsl:attribute name="text-align">
						<xsl:choose>
							<xsl:when test="child::*/@align"><xsl:value-of select="child::*/@align"/></xsl:when>
							<xsl:otherwise>justify</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="un:title" mode="inline-header"/>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body text-indent="body-start()">
							<fo:block>
								<xsl:apply-templates/>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="un:title" mode="inline-header">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="un:p[ancestor::un:table]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:p" name="paragraph">
		<xsl:param name="split_keep-within-line"/>
		<fo:block margin-bottom="6pt" line-height="122%">
			<xsl:if test="following-sibling::*">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:fn/un:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:ul | un:ol" mode="list" priority="2">
		<fo:block-container margin-left="8mm" text-indent="0mm">
			<xsl:call-template name="list"/>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="un:li//un:p">
		<fo:block margin-bottom="6pt" line-height="122%" text-align="justify">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:link" priority="2">
		<fo:inline>
			<xsl:if test="ancestor::un:fn and string-length(@target) &gt; 110">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="link"/>
		</fo:inline>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->

	<xsl:template match="un:preface//un:title" priority="3">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">14pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}" font-weight="bold" margin-top="3pt" margin-bottom="16pt" keep-with-next="always" role="H{$level}">
			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:annex//un:title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2">10pt</xsl:when>
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$level = 1">
				<fo:block font-size="{$font-size}" font-weight="bold" space-before="3pt" keep-with-next="always" role="H{$level}">
					<fo:block margin-bottom="12pt">
						<xsl:apply-templates/>
						<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
					</fo:block>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="{$font-size}" font-weight="bold" margin-left="1mm" space-before="3pt" margin-bottom="6pt" keep-with-next="always" role="H{$level}">
					<xsl:apply-templates/>
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="un:title[parent::un:clause[@inline-header = 'true']]" priority="3"/>

	<xsl:template match="un:title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">14pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::un:sections and $level = 1">
				<fo:block-container margin-left="-16mm">
					<fo:block font-size="{$font-size}" font-weight="bold" margin-left="16mm" space-before="16pt" margin-bottom="13pt" keep-with-next="always" role="H{$level}">
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="16mm"/>
							<fo:table-column column-width="130mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<xsl:variable name="section">
											<xsl:for-each select="..">
												<xsl:call-template name="getSection"/>
											</xsl:for-each>
										</xsl:variable>
										<fo:block text-align="center">
											<xsl:value-of select="$section"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:call-template name="extractTitle"/>
											<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="ancestor::un:sections">
				<fo:block font-size="{$font-size}" font-weight="bold" space-before="16pt" margin-bottom="13pt" text-indent="-8mm" keep-with-next="always" role="H{$level}">
					<xsl:if test="$level = 2">
						<xsl:attribute name="margin-left">1mm</xsl:attribute>
						<xsl:attribute name="space-before">12pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$level = 3">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
						<xsl:attribute name="margin-left">1mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="insertTitleAsListItem">
						<xsl:with-param name="provisional-distance-between-starts" select="'8mm'"/>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="{$font-size}" font-weight="bold" text-align="left" keep-with-next="always" role="H{$level}">
					<xsl:apply-templates/>
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ============================ -->
	<!-- for further use -->
	<!-- ============================ -->

	<xsl:template match="un:figure" priority="2">
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<fo:block>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
			</fo:block>
			<xsl:apply-templates select="un:name"/>
			<!-- <xsl:call-template name="fn_display_figure"/> -->
			<xsl:for-each select="un:note">
				<xsl:call-template name="note"/>
			</xsl:for-each>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="un:dl" priority="3">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm">

				<fo:block line-height="122%" margin-bottom="6pt" text-indent="0mm" text-align="justify">
					<xsl:apply-templates/>
				</fo:block>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="un:dt" priority="2">
		<fo:block margin-bottom="6pt">
			<xsl:apply-templates/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="following-sibling::un:dd[1]" mode="dd"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="un:dd"/>
	<xsl:template match="un:dd" mode="dd">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="un:dd//un:p" priority="3">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ============================ -->
	<!-- ============================ -->

	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="25mm" display-align="after" border-bottom="0.5pt solid black" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" text-align="right" margin-left="21mm" margin-right="21mm" padding-bottom="0.5mm">
					<xsl:value-of select="$id"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container height="40mm" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" text-align="right" margin-left="21mm" margin-right="21mm" padding-top="12mm"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="25mm" display-align="after" border-bottom="0.5pt solid black" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" margin-left="21mm" margin-right="21mm" padding-bottom="0.5mm">
					<xsl:value-of select="$id"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container height="40mm" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" margin-left="21mm" margin-right="21mm" padding-top="12mm"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<!--<xsl:variable name="Image-Logo">
		<xsl:text>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/GMzLdsAADsgaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzAxNCA3OS4xNTY3OTcsIDIwMTQvMDgvMjAtMDk6NTM6MDIgICAgICAgICI+CiAgIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgICAgICAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE0IChXaW5kb3dzKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAyMC0wMy0yNVQyMTowNTo0MSswMzowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAyMC0wMy0yNVQyMTowNzo0MyswMzowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHBob3Rvc2hvcDpJQ0NQcm9maWxlPnNSR0IgSUVDNjE5NjYtMi4xPC9waG90b3Nob3A6SUNDUHJvZmlsZT4KICAgICAgICAgPHhtcE1NOkluc3RhbmNlSUQ+eG1wLmlpZDpjMTQ1NzAyOS1iYTI0LWIwNDYtYmU5NC0wOTY5ZDRkOGRkNTE8L3htcE1NOkluc3RhbmNlSUQ+CiAgICAgICAgIDx4bXBNTTpEb2N1bWVudElEPmFkb2JlOmRvY2lkOnBob3Rvc2hvcDo4NWRmOTdiMi02ZWMzLTExZWEtOGRjNC1kOTAxZWM0NGU2YWM8L3htcE1NOkRvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDo3NTMzOTU5ZS1hYzZjLTQwNGYtOWZlNi0wZDg0ZGNkOGRkZGQ8L3htcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jcmVhdGVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6NzUzMzk1OWUtYWM2Yy00MDRmLTlmZTYtMGQ4NGRjZDhkZGRkPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA1OjQxKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jb252ZXJ0ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnBhcmFtZXRlcnM+ZnJvbSBhcHBsaWNhdGlvbi92bmQuYWRvYmUucGhvdG9zaG9wIHRvIGltYWdlL3BuZzwvc3RFdnQ6cGFyYW1ldGVycz4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0iUmVzb3VyY2UiPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6YWN0aW9uPnNhdmVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6YzE0NTcwMjktYmEyNC1iMDQ2LWJlOTQtMDk2OWQ0ZDhkZDUxPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpjaGFuZ2VkPi88L3N0RXZ0OmNoYW5nZWQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICA8L3JkZjpTZXE+CiAgICAgICAgIDwveG1wTU06SGlzdG9yeT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpYUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6WVJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj4yMjU8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+MTgwPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz4xznjNAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAFWJSURBVHja7F1nWBVHFz50sCCxghUFFOzG2EuIBTti7OKnRI01xhrFEmOMRmOP3aixE1vsGmOvKMaCqNhQUBBBUBAREYTz/di5uHd2Zsu9l2LCeZ55Ermzs7Ozc3ZmznnPe8wg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</xsl:text>
	</xsl:variable>-->

	<xsl:variable name="Image-Logo-SVG">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="Layer_1" data-name="Layer 1" viewBox="0 0 56.25 46.5" width="56.25" height="46.5">
			<defs>
				<style>
					.cls-1, .cls-2, .cls-3 {
						stroke-width: 0px;
					}

					.cls-1, .cls-3 {
						fill-rule: evenodd;
					}

					.cls-2 {
						fill: none;
					}

					.cls-3 {
						fill: #fff;
					}

					.cls-4 {
						clip-path: url(#clippath);
					}
				</style>
				<clipPath id="clippath">
					<rect class="cls-2" width="56.25" height="46.5"/>
				</clipPath>
			</defs>
			<g class="cls-4">
				<polygon class="cls-1" points="22.27 45.34 22.6 44.98 22.93 44.61 23.27 44.24 23.62 43.89 23.96 43.55 24.32 43.22 24.67 42.9 25.06 42.58 25.41 42.28 25.82 42 26.2 41.73 26.6 41.47 26.99 41.24 27.42 41.01 27.82 40.78 28.25 40.6 28.63 40.76 28.99 40.97 29.37 41.15 29.75 41.34 30.09 41.57 30.42 41.82 30.78 42.07 31.11 42.3 31.42 42.58 31.78 42.86 32.09 43.13 32.4 43.46 32.71 43.75 33.07 44.05 33.38 44.35 33.68 44.7 33.85 44.86 33.99 45.02 34.14 45.16 34.33 45.3 35.43 44.35 35.07 44.03 34.71 43.69 34.38 43.39 33.99 43.11 33.64 42.83 33.28 42.56 32.92 42.28 32.54 42.03 32.18 41.82 31.8 41.57 31.42 41.34 31.04 41.13 30.63 40.9 30.23 40.71 29.82 40.48 29.39 40.3 29.68 40.23 29.99 40.18 30.28 40.16 30.61 40.16 30.9 40.18 31.18 40.23 31.49 40.3 31.78 40.41 31.9 40.48 32.04 40.55 32.14 40.62 32.28 40.69 32.4 40.76 32.54 40.85 32.66 40.9 32.78 40.99 33.21 41.29 33.64 41.59 34.09 41.89 34.57 42.16 35.09 42.44 35.62 42.69 36.14 42.93 36.71 43.11 37.26 43.27 37.86 43.41 38.43 43.5 39.05 43.55 39.65 43.52 40.24 43.48 40.84 43.36 41.43 43.18 41.93 42.97 42.41 42.79 42.84 42.56 43.27 42.35 43.67 42.07 44.08 41.8 44.44 41.45 44.82 41.11 44.86 41.01 44.91 40.97 44.96 40.9 44.98 40.85 44.36 41.24 43.7 41.54 43.05 41.73 42.36 41.87 41.65 41.93 40.96 41.89 40.24 41.82 39.53 41.7 38.79 41.54 38.07 41.34 37.36 41.11 36.67 40.85 35.95 40.6 35.26 40.32 34.61 40.05 33.95 39.79 33.81 39.77 33.66 39.72 33.5 39.68 33.35 39.65 33.21 39.63 33.07 39.61 32.92 39.58 32.78 39.54 32.21 39.49 31.63 39.47 31.06 39.47 30.49 39.47 29.92 39.52 29.37 39.63 28.8 39.75 28.25 39.91 27.89 39.79 27.51 39.72 27.13 39.63 26.77 39.58 26.39 39.54 25.98 39.52 25.63 39.49 25.25 39.49 24.67 39.52 24.1 39.58 23.53 39.65 22.98 39.77 22.41 39.91 21.88 40.09 21.34 40.28 20.81 40.48 20.34 40.71 19.83 40.97 19.33 41.15 18.81 41.38 18.26 41.54 17.74 41.7 17.19 41.87 16.64 41.98 16.07 42.07 15.52 42.1 14.95 42.1 14.4 42.07 13.87 41.98 13.33 41.84 12.8 41.66 12.3 41.4 12.09 41.31 11.92 41.24 11.75 41.15 11.59 41.04 11.68 41.2 11.8 41.38 11.94 41.52 12.11 41.68 12.3 41.82 12.49 41.96 12.63 42.07 12.8 42.16 13.02 42.3 13.21 42.44 13.4 42.58 13.61 42.69 14.02 42.93 14.45 43.11 14.83 43.25 15.3 43.39 15.76 43.5 16.21 43.59 16.66 43.64 17.12 43.66 17.59 43.66 18.07 43.64 18.52 43.59 18.98 43.5 19.45 43.41 19.88 43.27 20.31 43.11 20.74 42.93 21.12 42.76 21.53 42.56 21.91 42.35 22.27 42.1 22.62 41.84 22.98 41.57 23.36 41.31 23.7 41.06 24.08 40.83 24.48 40.62 24.89 40.44 25.27 40.3 25.75 40.18 26.2 40.16 26.68 40.16 27.2 40.23 27.2 40.28 27.2 40.3 26.77 40.48 26.37 40.69 25.96 40.87 25.56 41.11 25.2 41.31 24.82 41.54 24.46 41.8 24.1 42.03 23.74 42.28 23.36 42.53 22.98 42.81 22.62 43.11 22.24 43.41 21.88 43.75 21.5 44.08 21.12 44.45 21.24 44.56 21.38 44.65 21.53 44.79 21.67 44.91 21.81 45.02 21.96 45.14 22.12 45.25 22.27 45.34"/>
				<polygon class="cls-1" points="14.11 40.9 14.49 40.9 14.88 40.87 15.23 40.87 15.61 40.85 15.97 40.78 16.35 40.76 16.74 40.71 17.09 40.64 17.4 40.58 17.74 40.51 18.05 40.44 18.33 40.34 18.64 40.28 18.95 40.18 19.26 40.09 19.55 40.02 19.88 39.93 20.19 39.88 20.48 39.79 20.79 39.75 21.07 39.68 21.38 39.63 21.67 39.58 21.98 39.54 22.03 39.54 21.98 39.52 21.38 39.45 20.81 39.31 20.26 39.1 19.76 38.92 19.26 38.66 18.79 38.39 18.33 38.09 17.9 37.74 17.45 37.4 17.05 37.03 16.62 36.68 16.19 36.29 15.78 35.9 15.35 35.51 14.92 35.11 14.47 34.75 14.23 34.54 14.04 34.35 13.8 34.19 13.61 34.01 13.37 33.85 13.18 33.69 12.94 33.55 12.73 33.41 13.04 33.85 13.33 34.33 13.59 34.79 13.83 35.3 14.09 35.78 14.35 36.29 14.61 36.77 14.9 37.23 15.09 37.46 15.33 37.72 15.54 37.95 15.81 38.13 16.07 38.34 16.33 38.52 16.59 38.66 16.83 38.8 17.05 38.89 17.24 38.96 17.47 39.05 17.69 39.1 17.9 39.17 18.12 39.22 18.36 39.31 18.55 39.35 18.55 39.38 18.59 39.38 18.59 39.4 18.31 39.38 18.02 39.35 17.74 39.33 17.45 39.26 17.12 39.24 16.83 39.19 16.54 39.17 16.26 39.1 15.97 39.08 15.69 39.03 15.4 38.99 15.11 38.94 14.8 38.92 14.52 38.89 14.23 38.89 13.95 38.85 13.49 38.85 13.04 38.82 12.54 38.8 12.09 38.75 11.61 38.69 11.16 38.64 10.66 38.55 10.23 38.43 9.77 38.29 9.35 38.16 8.92 37.97 8.51 37.79 8.11 37.53 7.75 37.28 7.39 36.98 7.08 36.64 7.39 37.19 7.77 37.7 8.2 38.2 8.68 38.66 9.23 39.08 9.77 39.47 10.32 39.81 10.87 40.09 11.23 40.28 11.63 40.41 12.04 40.55 12.47 40.62 12.87 40.74 13.3 40.78 13.73 40.85 14.11 40.9"/>
				<polygon class="cls-1" points="41.43 40.74 41.96 40.74 42.43 40.71 42.93 40.64 43.41 40.58 43.91 40.48 44.36 40.34 44.84 40.21 45.27 40.05 45.7 39.86 46.13 39.63 46.53 39.38 46.94 39.12 47.35 38.82 47.68 38.52 48.01 38.23 48.37 37.86 48.51 37.67 48.68 37.51 48.8 37.3 48.94 37.14 49.06 36.96 49.16 36.75 49.28 36.57 49.39 36.34 49.01 36.73 48.63 37.05 48.2 37.37 47.77 37.6 47.27 37.83 46.8 38.02 46.25 38.2 45.68 38.34 45.2 38.41 44.7 38.48 44.22 38.52 43.77 38.57 43.27 38.64 42.79 38.66 42.29 38.71 41.81 38.78 41.34 38.82 40.84 38.89 40.36 38.94 39.91 38.99 39.41 39.05 38.93 39.12 38.43 39.22 37.95 39.31 37.93 39.26 37.93 39.24 38.48 39.08 39 38.92 39.53 38.69 40 38.48 40.43 38.16 40.86 37.86 41.24 37.46 41.58 37.03 41.77 36.75 41.93 36.45 42.1 36.15 42.27 35.85 42.43 35.48 42.62 35.11 42.79 34.79 42.96 34.42 43.13 34.1 43.34 33.78 43.53 33.46 43.77 33.16 43.44 33.36 43.13 33.55 42.82 33.8 42.53 34.01 42.22 34.29 41.93 34.54 41.62 34.81 41.34 35.07 40.96 35.44 40.58 35.81 40.22 36.17 39.84 36.54 39.48 36.87 39.1 37.19 38.69 37.53 38.33 37.83 37.9 38.13 37.47 38.39 37.05 38.64 36.57 38.85 36.09 39.05 35.62 39.19 35.07 39.33 34.52 39.4 34.52 39.45 34.52 39.47 34.76 39.49 35 39.52 35.23 39.54 35.5 39.58 35.71 39.63 35.95 39.65 36.21 39.72 36.43 39.77 36.76 39.86 37.07 39.91 37.38 40 37.69 40.07 38 40.16 38.33 40.23 38.64 40.3 38.95 40.37 39.26 40.44 39.57 40.51 39.91 40.58 40.19 40.62 40.5 40.64 40.81 40.69 41.12 40.71 41.43 40.74"/>
				<polygon class="cls-1" points="14.97 38.36 15.02 38.36 15.04 38.36 14.76 38.11 14.49 37.86 14.23 37.58 13.97 37.28 13.76 37 13.54 36.7 13.35 36.4 13.21 36.06 12.75 34.93 12.32 33.8 11.87 32.72 11.4 31.64 10.89 30.62 10.32 29.63 9.65 28.73 8.89 27.9 9.3 29.12 9.61 30.37 9.87 31.64 10.11 32.88 10.49 34.1 11.01 35.21 11.75 36.17 12.78 36.98 12.8 36.98 12.8 37 12.8 37.03 12.78 37.05 12.4 36.89 12.06 36.68 11.75 36.45 11.4 36.2 11.09 35.94 10.78 35.71 10.44 35.48 10.08 35.3 9.61 35.02 9.11 34.77 8.63 34.54 8.11 34.29 7.6 34.05 7.08 33.8 6.6 33.55 6.08 33.27 5.63 32.99 5.17 32.7 4.72 32.35 4.31 31.98 3.93 31.59 3.6 31.17 3.29 30.69 3.03 30.18 3.15 30.74 3.29 31.24 3.48 31.75 3.72 32.21 3.96 32.7 4.22 33.13 4.53 33.55 4.86 33.94 5.32 34.49 5.79 35.02 6.32 35.46 6.89 35.85 7.46 36.2 8.06 36.54 8.68 36.77 9.35 37.03 10.01 37.26 10.68 37.44 11.37 37.6 12.09 37.79 12.8 37.93 13.52 38.09 14.26 38.23 14.97 38.36"/>
				<polygon class="cls-1" points="27.39 38.23 27.68 38.23 27.96 38.23 28.23 38.23 28.51 38.23 28.8 38.23 29.08 38.2 29.37 38.2 29.66 38.16 29.94 38.13 30.23 38.11 30.51 38.09 30.82 38.06 31.11 37.99 31.4 37.97 31.68 37.93 31.97 37.86 32.95 37.65 33.9 37.37 34.81 37.1 35.69 36.73 36.55 36.36 37.38 35.92 38.19 35.48 38.95 34.98 39.69 34.49 40.41 33.92 41.1 33.32 41.77 32.72 42.39 32.05 43.01 31.36 43.58 30.64 44.13 29.91 44.53 29.29 44.91 28.66 45.27 28 45.63 27.28 45.94 26.54 46.25 25.81 46.51 25.02 46.73 24.24 46.82 23.87 46.92 23.5 46.99 23.18 47.06 22.86 47.23 21.82 47.35 20.81 47.37 19.77 47.3 18.76 47.23 17.7 47.08 16.68 46.84 15.67 46.58 14.65 46.25 13.69 45.87 12.72 45.49 11.82 45.01 10.92 44.51 10.07 43.96 9.24 43.39 8.5 42.79 7.79 42.41 7.37 42.05 6.98 41.67 6.61 41.29 6.27 40.91 5.9 40.53 5.58 40.12 5.25 39.76 4.95 39.36 4.68 38.95 4.4 38.55 4.13 38.12 3.87 37.69 3.64 37.29 3.41 36.83 3.18 36.4 2.97 35.38 2.53 34.35 2.14 33.28 1.84 32.21 1.57 31.11 1.36 29.99 1.25 28.89 1.18 27.8 1.18 26.68 1.22 25.6 1.34 24.48 1.5 23.41 1.73 22.36 2.03 21.31 2.4 20.31 2.76 19.31 3.25 18.9 3.46 18.48 3.69 18.07 3.94 17.66 4.19 17.24 4.42 16.83 4.7 16.45 5.02 16.07 5.33 15.66 5.62 15.3 5.95 14.9 6.29 14.54 6.64 14.18 7.01 13.83 7.4 13.49 7.79 13.16 8.16 12.83 8.57 12.52 8.99 12.21 9.4 11.94 9.82 11.66 10.23 11.4 10.69 11.16 11.15 10.89 11.61 10.01 13.66 9.39 15.81 9.06 18.02 9.01 20.23 9.2 22.4 9.65 24.59 10.37 26.66 11.32 28.66 11.49 28.96 11.66 29.24 11.82 29.52 12.04 29.79 12.21 30.07 12.4 30.35 12.61 30.6 12.8 30.88 13.4 31.57 14.02 32.26 14.64 32.88 15.26 33.46 15.95 34.05 16.64 34.56 17.36 35.07 18.09 35.51 18.83 35.94 19.64 36.34 20.45 36.7 21.31 37.03 22.17 37.3 23.05 37.58 23.98 37.81 24.94 37.99 25.25 38.02 25.56 38.09 25.89 38.11 26.18 38.13 26.49 38.16 26.8 38.2 27.08 38.23 27.39 38.23"/>
				<polygon class="cls-1" points="41.43 38.2 42.27 38.06 43.1 37.88 43.93 37.72 44.72 37.53 45.53 37.3 46.3 37.05 47.08 36.77 47.8 36.47 48.51 36.15 49.2 35.76 49.82 35.34 50.42 34.88 50.99 34.35 51.52 33.78 51.97 33.16 52.4 32.46 52.57 32.19 52.71 31.87 52.88 31.57 52.99 31.2 53.14 30.88 53.23 30.51 53.3 30.14 53.4 29.79 53.11 30.35 52.8 30.88 52.42 31.34 51.99 31.75 51.54 32.14 51.06 32.49 50.54 32.83 50.02 33.13 49.49 33.41 48.94 33.69 48.37 33.96 47.82 34.24 47.27 34.52 46.77 34.81 46.25 35.09 45.77 35.44 45.63 35.53 45.49 35.62 45.34 35.74 45.2 35.85 45.01 35.99 44.84 36.13 44.65 36.27 44.49 36.4 44.29 36.5 44.1 36.64 43.91 36.75 43.7 36.87 43.7 36.84 43.67 36.84 43.67 36.82 44.2 36.36 44.65 35.9 45.06 35.39 45.41 34.91 45.72 34.38 45.99 33.8 46.22 33.18 46.39 32.53 46.51 31.91 46.58 31.29 46.68 30.67 46.8 30.05 46.92 29.42 47.06 28.82 47.23 28.2 47.49 27.63 46.94 28.13 46.44 28.71 46.01 29.31 45.65 29.95 45.34 30.64 45.01 31.36 44.72 32.12 44.44 32.83 44.2 33.57 43.91 34.33 43.58 35.05 43.24 35.76 42.86 36.43 42.43 37.05 41.96 37.67 41.41 38.2 41.43 38.2"/>
				<polygon class="cls-3" points="28.65 37.37 29.08 37.3 29.49 37.26 29.92 37.19 30.37 37.12 30.8 37.05 31.23 36.98 31.68 36.89 32.11 36.82 32.56 36.73 32.99 36.61 33.42 36.5 33.9 36.36 34.33 36.22 34.71 36.08 35.14 35.92 35.54 35.76 35.93 35.6 36.26 35.39 36.62 35.23 36.95 35.05 37.29 34.88 37.64 34.68 37.95 34.47 38.26 34.26 38.57 34.05 38.91 33.85 39.22 33.59 39.53 33.39 39.84 33.13 40.15 32.88 40.48 32.63 40.79 32.35 40.53 32.12 40.24 31.89 39.96 31.64 39.67 31.36 39.41 31.11 39.14 30.88 38.93 30.6 38.76 30.32 38.4 30.69 38.05 31.04 37.67 31.34 37.26 31.61 36.83 31.89 36.43 32.14 36.07 32.42 35.69 32.72 35.64 32.86 35.57 32.97 35.5 33.09 35.43 33.18 35.38 33.25 35.33 33.29 35.26 33.36 35.23 33.41 35.14 33.55 35.07 33.64 34.95 33.73 34.83 33.87 34.69 33.96 34.54 34.08 34.42 34.19 34.33 34.29 34.18 34.4 34.07 34.52 33.92 34.61 33.76 34.68 33.56 34.81 33.38 34.91 33.14 34.95 32.95 34.95 32.76 34.88 32.56 34.79 32.4 34.68 32.23 34.56 32.09 34.47 31.92 34.35 31.71 34.26 31.52 34.22 31.37 34.24 31.23 34.26 31.11 34.29 30.97 34.29 30.85 34.33 30.7 34.35 30.61 34.35 30.47 34.38 30.23 34.4 29.99 34.42 29.78 34.47 29.56 34.49 29.35 34.52 29.11 34.52 28.89 34.52 28.65 34.47 28.63 37.37 28.65 37.37"/>
				<polygon class="cls-3" points="27.68 37.3 27.56 37.1 27.56 36.45 27.56 35.78 27.56 35.11 27.65 34.49 27.27 34.52 26.91 34.52 26.53 34.49 26.2 34.47 25.82 34.4 25.46 34.33 25.08 34.26 24.75 34.22 24.2 34.1 23.67 33.94 23.17 33.8 22.67 33.59 22.19 33.41 21.69 33.23 21.24 33.02 20.81 32.81 20.41 32.56 19.98 32.3 19.6 32.05 19.19 31.77 18.81 31.5 18.4 31.17 18.05 30.88 17.64 30.51 17.4 30.76 17.16 31.01 16.93 31.24 16.66 31.5 16.4 31.75 16.16 32 15.9 32.26 15.64 32.49 16.07 32.86 16.52 33.18 16.95 33.52 17.4 33.85 17.88 34.15 18.33 34.47 18.81 34.75 19.31 35.02 19.79 35.3 20.31 35.51 20.81 35.76 21.36 35.99 21.91 36.17 22.48 36.36 23.08 36.57 23.7 36.73 24.22 36.84 24.7 36.96 25.22 37.03 25.75 37.1 26.22 37.14 26.7 37.19 27.2 37.26 27.68 37.3"/>
				<polygon class="cls-1" points="9.75 34.24 9.75 34.24 9.75 34.22 9.11 32.88 8.73 31.47 8.49 30.05 8.32 28.55 8.2 27.05 8.01 25.58 7.65 24.15 7.15 22.74 7.2 23.46 7.15 24.17 7.03 24.88 6.89 25.62 6.75 26.36 6.6 27.07 6.51 27.79 6.51 28.55 6.58 28.99 6.65 29.45 6.77 29.91 6.91 30.32 7.08 30.74 7.29 31.11 7.49 31.5 7.72 31.84 7.68 31.84 7.68 31.87 7.65 31.87 7.37 31.57 7.1 31.22 6.89 30.9 6.65 30.55 6.44 30.23 6.17 29.93 5.94 29.58 5.65 29.26 5.44 29.01 5.2 28.76 4.96 28.53 4.74 28.29 4.51 28.04 4.24 27.79 4.03 27.58 3.77 27.33 3.31 26.89 2.91 26.41 2.5 25.97 2.17 25.48 1.86 24.95 1.62 24.42 1.43 23.85 1.31 23.2 1.22 23.87 1.24 24.56 1.31 25.28 1.43 25.99 1.57 26.54 1.76 27.07 2 27.6 2.24 28.11 2.53 28.57 2.86 29.03 3.22 29.49 3.6 29.91 4.01 30.28 4.39 30.67 4.82 31.04 5.24 31.36 5.72 31.7 6.17 32 6.63 32.28 7.08 32.56 7.44 32.74 7.75 32.97 8.08 33.16 8.44 33.36 8.75 33.55 9.08 33.78 9.39 33.99 9.73 34.24 9.75 34.24"/>
				<polygon class="cls-1" points="46.68 33.99 47.27 33.59 47.92 33.18 48.54 32.76 49.2 32.4 49.82 31.93 50.49 31.5 51.11 31.04 51.71 30.55 52.28 30.05 52.83 29.52 53.35 28.94 53.81 28.29 54.21 27.63 54.55 26.94 54.81 26.17 55 25.37 55.09 24.72 55.14 24.06 55.14 23.43 55.09 22.79 54.92 23.57 54.69 24.26 54.35 24.88 53.95 25.51 53.45 26.08 52.95 26.64 52.4 27.19 51.8 27.76 51.3 28.25 50.87 28.73 50.52 29.22 50.16 29.7 49.82 30.18 49.49 30.64 49.13 31.11 48.73 31.59 48.7 31.59 48.7 31.57 49.11 30.88 49.59 29.84 49.8 28.8 49.82 27.74 49.71 26.66 49.54 25.58 49.37 24.52 49.25 23.46 49.25 22.4 48.7 23.83 48.4 25.25 48.2 26.73 48.06 28.2 47.92 29.7 47.68 31.15 47.3 32.58 46.68 33.94 46.68 33.96 46.68 33.99"/>
				<polygon class="cls-3" points="27.68 33.66 27.56 32.99 27.53 32.33 27.53 31.64 27.56 30.94 27.18 30.97 26.77 30.97 26.39 30.94 25.98 30.9 25.6 30.81 25.2 30.74 24.79 30.62 24.41 30.48 24.05 30.35 23.67 30.21 23.31 30.05 22.96 29.86 22.62 29.7 22.27 29.54 21.96 29.35 21.67 29.17 21.55 29.08 21.46 28.99 21.31 28.89 21.19 28.8 21.26 28.96 21.36 29.1 21.46 29.26 21.41 29.42 21.41 29.45 21.41 29.49 21.38 29.52 21.31 29.58 21.22 29.63 21.1 29.65 20.98 29.68 20.88 29.68 20.76 29.68 20.64 29.68 20.53 29.7 20.31 29.72 20.1 29.79 19.88 29.84 19.64 29.93 19.41 30 19.19 30.05 18.95 30.05 18.74 29.95 18.62 29.84 18.5 29.77 18.36 29.72 18.19 29.68 18.33 29.77 18.48 29.84 18.59 29.95 18.74 30.09 18.95 30.28 19.19 30.46 19.41 30.62 19.62 30.78 19.83 30.92 20.05 31.06 20.26 31.2 20.48 31.34 20.84 31.59 21.22 31.8 21.65 32.03 22.08 32.21 22.5 32.4 22.96 32.58 23.41 32.72 23.91 32.86 24.36 32.99 24.84 33.13 25.34 33.25 25.82 33.36 26.32 33.43 26.77 33.52 27.22 33.59 27.68 33.66"/>
				<polygon class="cls-3" points="28.65 33.59 28.94 33.55 29.2 33.5 29.49 33.43 29.78 33.41 30.06 33.39 30.35 33.36 30.63 33.32 30.92 33.29 30.68 33.23 30.49 33.09 30.28 32.97 30.09 32.88 29.94 32.67 29.8 32.44 29.7 32.21 29.7 31.98 29.78 31.84 29.85 31.73 29.89 31.61 29.89 31.47 29.78 31.43 29.63 31.38 29.49 31.36 29.32 31.36 29.18 31.36 28.99 31.36 28.85 31.34 28.7 31.29 28.68 31.24 28.65 31.2 28.61 31.17 28.51 31.15 28.63 31.73 28.68 32.35 28.65 32.99 28.65 33.59"/>
				<polygon class="cls-3" points="14.9 31.8 15.11 31.57 15.38 31.29 15.64 31.04 15.9 30.78 16.16 30.51 16.4 30.28 16.69 30.07 16.97 29.84 16.78 29.65 16.59 29.42 16.35 29.22 16.16 28.99 16.02 28.94 15.88 28.85 15.76 28.76 15.64 28.69 15.52 28.57 15.4 28.46 15.33 28.34 15.26 28.2 15.26 28.16 15.26 28.11 15.26 28.04 15.23 28 15.16 28.06 15.07 28.13 14.95 28.16 14.83 28.16 14.68 28.06 14.59 27.97 14.47 27.86 14.33 27.74 14.26 27.63 14.18 27.49 14.11 27.37 14.09 27.23 14.09 27.21 14.07 27.21 13.78 27.21 13.52 26.94 13.35 26.94 13.25 26.89 13.23 26.8 13.18 26.73 13.09 26.66 13.04 26.61 13.02 26.52 12.97 26.47 12.94 26.41 12.92 26.41 12.92 26.38 12.9 26.38 12.87 26.41 12.87 26.47 12.87 26.5 12.87 26.54 12.83 26.59 12.8 26.64 12.75 26.66 12.68 26.66 12.49 26.59 12.35 26.47 12.21 26.34 12.06 26.2 12.04 26.17 12.04 26.13 12.02 26.11 11.94 26.13 11.87 26.17 11.8 26.2 11.73 26.13 11.54 25.92 11.47 25.67 11.37 25.39 11.25 25.14 11.23 24.84 11.23 24.54 11.25 24.24 11.37 23.99 11.44 23.89 11.49 23.78 11.51 23.71 11.61 23.62 11.73 23.59 11.82 23.57 11.94 23.57 12.04 23.59 12.09 23.64 12.11 23.69 12.16 23.71 12.18 23.73 12.44 23.69 12.47 23.62 12.47 23.57 12.47 23.55 12.47 23.48 12.59 23.36 12.73 23.32 12.87 23.3 13.04 23.27 13.18 23.36 13.25 23.55 13.37 23.69 13.49 23.83 13.35 23.46 13.25 23.06 13.18 22.67 13.09 22.3 13.02 21.91 12.97 21.5 12.94 21.11 12.87 20.74 12.92 20.25 12.59 20.3 12.23 20.3 11.87 20.32 11.49 20.32 11.11 20.3 10.78 20.3 10.39 20.28 10.04 20.28 10.08 21.11 10.18 21.96 10.3 22.79 10.47 23.62 10.8 24.86 11.2 26.04 11.68 27.1 12.21 28.13 12.8 29.1 13.45 30 14.11 30.92 14.88 31.8 14.9 31.8"/>
				<polygon class="cls-3" points="41.53 31.75 41.79 31.36 42.08 31.01 42.36 30.64 42.65 30.28 42.93 29.95 43.2 29.58 43.44 29.24 43.67 28.85 43.82 28.66 43.93 28.43 44.06 28.25 44.15 28.02 44.27 27.79 44.39 27.58 44.53 27.37 44.65 27.17 44.86 26.64 45.1 26.11 45.34 25.55 45.51 25 45.68 24.45 45.84 23.87 45.96 23.32 46.08 22.77 46.2 22.1 46.25 21.43 46.34 20.78 46.49 20.16 46.11 20.18 45.77 20.23 45.39 20.23 45.01 20.23 44.65 20.23 44.27 20.23 43.93 20.18 43.56 20.18 43.53 20.16 43.51 20.16 43.48 20.14 43.48 20.88 43.41 21.66 43.27 22.44 43.1 23.23 42.86 23.99 42.62 24.75 42.29 25.48 41.98 26.17 41.86 26.41 41.72 26.64 41.62 26.87 41.48 27.07 41.36 27.3 41.22 27.51 41.07 27.72 40.93 27.93 40.86 28 40.81 28.06 40.79 28.16 40.72 28.2 40.58 28.41 40.43 28.59 40.29 28.8 40.12 28.96 39.98 29.15 39.81 29.35 39.65 29.54 39.43 29.7 39.41 29.7 39.38 29.7 39.57 29.86 39.81 30.05 40 30.23 40.22 30.41 40.43 30.62 40.65 30.83 40.84 31.04 41.05 31.24 41.19 31.36 41.29 31.47 41.41 31.61 41.5 31.75 41.53 31.75"/>
				<polygon class="cls-3" points="36.11 31.29 36.33 31.08 36.52 30.9 36.76 30.69 37 30.53 37.24 30.37 37.5 30.18 37.72 29.98 37.93 29.77 37.95 29.72 37.98 29.72 37.83 29.77 37.69 29.77 37.55 29.72 37.43 29.65 37.38 29.4 37.24 29.15 37.09 28.94 36.9 28.71 36.67 28.48 36.47 28.27 36.26 28.06 36.07 27.86 36.07 27.83 35.97 27.97 35.85 28.11 35.76 28.2 35.62 28.34 35.64 28.66 35.81 28.8 36 28.87 36.21 28.99 36.38 29.12 36.5 29.22 36.57 29.29 36.67 29.4 36.71 29.52 36.64 29.7 36.5 29.86 36.36 30.05 36.26 30.21 36.21 30.28 36.14 30.37 36.09 30.46 36.09 30.53 36.14 30.64 36.24 30.76 36.26 30.83 36.26 30.97 36.24 31.06 36.19 31.11 36.11 31.2 36.09 31.29 36.11 31.29"/>
				<polygon class="cls-3" points="26.6 29.86 26.6 29.86 26.6 29.84 26.41 29.79 26.25 29.7 26.1 29.63 25.96 29.52 25.82 29.4 25.7 29.26 25.63 29.12 25.51 28.96 25.41 28.8 25.34 28.62 25.27 28.48 25.27 28.32 25.34 28.27 25.41 28.2 25.48 28.16 25.51 28.11 25.6 27.83 25.7 27.58 25.89 27.35 26.1 27.21 26.25 27.17 26.39 27.14 26.53 27.07 26.68 27.05 26.32 27.14 25.94 27.1 25.56 27.05 25.22 26.91 24.89 26.77 24.53 26.61 24.22 26.45 23.91 26.27 23.77 26.17 23.62 26.08 23.48 25.99 23.36 25.9 23.22 25.81 23.1 25.67 22.98 25.55 22.91 25.39 22.7 25.62 22.48 25.85 22.24 26.11 21.98 26.36 21.77 26.61 21.5 26.82 21.24 27.07 20.98 27.28 21.34 27.49 21.67 27.72 22.03 27.93 22.34 28.16 22.65 28.39 22.98 28.59 23.36 28.8 23.74 28.96 24.08 29.12 24.41 29.24 24.79 29.38 25.17 29.45 25.53 29.56 25.91 29.65 26.25 29.77 26.6 29.86"/>
				<polygon class="cls-3" points="38.69 29.08 38.98 28.76 39.24 28.43 39.5 28.13 39.76 27.79 39.98 27.49 40.19 27.19 40.41 26.87 40.65 26.54 41 25.85 41.36 25.12 41.65 24.38 41.93 23.57 42.12 22.77 42.34 21.94 42.43 21.13 42.51 20.32 42.65 20.18 42.29 20.18 41.96 20.23 41.58 20.23 41.22 20.23 40.86 20.23 40.5 20.23 40.12 20.18 39.79 20.16 39.79 20.55 39.72 20.97 39.69 21.36 39.65 21.77 39.69 21.89 39.79 21.98 39.86 22.07 39.96 22.19 39.98 22.26 39.98 22.37 39.98 22.47 39.93 22.53 39.84 22.6 39.72 22.63 39.62 22.63 39.53 22.6 39.5 22.58 39.48 22.53 39.24 23.2 38.98 23.85 38.69 24.45 38.4 25.02 38.07 25.62 37.72 26.13 37.33 26.64 36.85 27.14 36.83 27.14 36.81 27.14 36.78 27.17 36.76 27.17 37.57 27.9 37.62 27.9 37.64 27.88 37.67 27.58 37.69 27.56 37.76 27.51 37.78 27.51 37.83 27.51 37.95 27.56 38.05 27.58 38.12 27.6 38.19 27.63 38.38 27.9 38.5 28.18 38.57 28.53 38.69 28.85 38.67 28.89 38.67 28.96 38.67 29.03 38.67 29.1 38.69 29.08"/>
				<polygon class="cls-3" points="21.1 28.71 20.88 28.46 20.93 28.59 21.1 28.71"/>
				<polygon class="cls-3" points="20.81 28.34 20.79 28.32 20.79 28.29 20.76 28.29 20.79 28.34 20.81 28.34"/>
				<polygon class="cls-1" points="5.75 28.2 5.63 27.42 5.63 26.59 5.72 25.78 5.89 24.98 6.1 24.17 6.37 23.34 6.6 22.53 6.82 21.75 7.08 20.65 7.29 19.49 7.44 18.39 7.51 17.28 7.51 17.14 7.51 17.01 7.49 16.87 7.49 16.73 7.25 17.51 6.94 18.18 6.6 18.8 6.22 19.4 5.86 20 5.48 20.6 5.17 21.24 4.89 21.96 4.65 22.93 4.6 23.87 4.67 24.82 4.89 25.76 4.86 25.76 4.86 25.78 4.82 25.78 4.79 25.78 4.77 25.76 4.6 25.23 4.46 24.68 4.34 24.12 4.22 23.57 3.93 22.53 3.53 21.57 3.1 20.6 2.65 19.63 2.29 18.64 2 17.65 1.88 16.64 1.95 15.55 1.64 16.38 1.43 17.26 1.29 18.18 1.22 19.08 1.29 19.95 1.38 20.81 1.57 21.66 1.79 22.49 2.1 23.34 2.53 24.12 3.05 24.84 3.6 25.53 4.17 26.2 4.72 26.87 5.24 27.51 5.72 28.25 5.75 28.2"/>
				<polygon class="cls-1" points="50.68 27.88 51.11 27.35 51.54 26.82 51.99 26.27 52.42 25.69 52.85 25.12 53.26 24.52 53.66 23.89 54 23.27 54.3 22.6 54.59 21.94 54.83 21.24 55 20.53 55.09 19.82 55.14 19.06 55.09 18.3 54.97 17.49 54.88 16.98 54.78 16.5 54.64 15.99 54.45 15.48 54.43 15.42 54.4 15.32 54.35 15.25 54.3 15.18 54.4 16.15 54.35 17.07 54.14 17.97 53.83 18.87 53.45 19.75 53.09 20.65 52.71 21.52 52.4 22.44 52.21 23.06 52.09 23.73 51.95 24.4 51.73 25.07 51.57 25.44 51.54 25.44 51.54 25.41 51.68 24.82 51.78 24.19 51.8 23.59 51.78 22.95 51.68 22.35 51.54 21.75 51.3 21.15 51.01 20.6 50.73 20.09 50.44 19.61 50.13 19.12 49.82 18.64 49.51 18.16 49.25 17.63 49.01 17.05 48.82 16.43 48.8 17.74 48.97 19.03 49.25 20.32 49.63 21.64 50.02 22.93 50.37 24.24 50.66 25.53 50.78 26.82 50.78 27.1 50.73 27.35 50.68 27.63 50.66 27.9 50.68 27.88"/>
				<polygon class="cls-3" points="19.76 27.17 19.79 27.07 19.83 27.03 19.88 27 19.93 26.91 20.22 26.64 20.5 26.36 20.79 26.08 21.07 25.81 21.36 25.53 21.62 25.25 21.93 24.98 22.22 24.72 21.91 24.4 21.62 24.03 21.36 23.69 21.17 23.27 20.95 22.86 20.76 22.4 20.6 21.96 20.45 21.47 20.45 21.41 20.45 21.36 20.41 21.34 20.41 21.27 20.12 21.11 20.07 21.29 20.05 21.52 19.98 21.75 19.95 21.96 19.95 21.98 19.93 21.98 19.91 22.03 19.88 22.05 19.76 22.03 19.69 21.98 19.67 21.94 19.62 21.91 19.52 21.89 19.45 21.82 19.38 21.77 19.33 21.66 19.31 21.57 19.33 21.52 19.36 21.47 19.38 21.43 19.41 21.43 19.48 21.41 19.52 21.43 19.6 21.47 19.64 21.47 19.69 21.24 19.69 21.01 19.67 20.81 19.64 20.58 19.64 20.55 19.67 20.53 19.69 20.53 19.74 20.51 19.83 20.53 19.93 20.58 20.02 20.69 20.07 20.78 20.19 20.81 20.31 20.78 20.41 20.71 20.53 20.69 20.55 20.67 20.55 20.65 20.6 20.65 20.6 20.6 20.67 20.28 20.64 20.25 20.62 20.25 20.6 20.23 20.55 20.18 20.6 20.02 20.62 19.86 20.62 19.68 20.55 19.49 20.6 19.33 20.55 19.19 20.5 19.06 20.41 18.94 20.24 18.87 20.05 18.87 19.83 18.89 19.67 18.94 19.64 18.99 19.62 19.01 19.6 19.01 19.52 19.08 19.5 19.19 19.52 19.31 19.52 19.42 19.64 19.59 19.74 19.77 19.76 19.98 19.74 20.16 19.69 20.18 19.67 20.23 19.62 20.25 19.55 20.28 19.48 20.25 19.38 20.25 19.26 20.25 19.19 20.25 19.1 20.39 19.1 20.55 19.07 20.71 18.98 20.85 18.83 20.92 18.67 20.92 18.5 20.97 18.38 21.08 18.4 21.29 18.5 21.5 18.52 21.71 18.5 21.96 18.69 22.17 18.9 22.37 19.05 22.6 19.12 22.88 19.21 23.16 19.26 23.43 19.31 23.71 19.48 23.92 19.48 24.06 19.48 24.19 19.48 24.31 19.5 24.45 19.52 25.02 19.76 25.53 19.95 26.04 19.98 26.59 19.91 26.68 19.76 26.77 19.67 26.82 19.62 26.96 19.6 27 19.6 27.03 19.62 27.03 19.67 27.03 19.69 27.05 19.74 27.05 19.76 27.07 19.76 27.1 19.76 27.14 19.76 27.17"/>
				<polygon class="cls-3" points="30.25 26.96 30.35 26.96 30.42 26.91 30.51 26.89 30.54 26.8 30.54 26.73 30.56 26.64 30.63 26.59 30.68 26.52 30.82 26.5 30.97 26.45 31.11 26.41 31.25 26.36 31.8 25.99 31.94 25.83 32.06 25.65 32.14 25.44 32.11 25.21 32.11 25.16 32.09 25.14 32.06 25.14 32.04 25.12 31.68 25.23 31.63 25.35 31.54 25.41 31.47 25.51 31.32 25.55 31.18 25.53 31.06 25.44 30.94 25.37 30.85 25.3 30.82 25.3 30.8 25.35 30.8 25.37 30.8 25.39 30.82 25.39 30.85 25.41 30.9 25.48 30.92 25.53 30.92 25.62 30.92 25.67 30.56 25.81 30.18 25.58 30.13 25.58 30.11 25.58 30.06 25.83 29.89 25.76 29.7 25.65 29.51 25.55 29.32 25.51 29.27 25.48 29.25 25.44 29.25 25.41 29.23 25.39 29.18 25.37 29.11 25.35 29.06 25.37 28.99 25.39 28.92 25.44 28.82 25.51 28.7 25.53 28.61 25.55 28.61 25.58 28.61 25.62 28.56 25.65 28.56 25.67 28.54 25.71 28.51 25.76 28.46 25.81 28.39 25.83 28.18 26.17 27.99 26.2 27.82 26.31 27.65 26.38 27.49 26.45 27.51 26.59 27.68 26.64 27.84 26.66 28.04 26.66 28.18 26.64 28.25 26.52 28.37 26.47 28.49 26.41 28.61 26.41 28.77 26.45 28.94 26.45 29.11 26.45 29.27 26.45 29.32 26.45 29.35 26.47 29.37 26.52 29.39 26.54 29.49 26.8 29.66 26.82 29.89 26.82 30.09 26.89 30.25 26.96"/>
				<polygon class="cls-3" points="33.92 26.89 35.23 26.77 35.33 26.5 35.43 26.24 35.54 25.99 35.71 25.78 35.81 25.71 35.83 25.71 35.9 25.78 35.93 25.81 35.95 25.85 36 25.99 36.05 26.13 36.07 26.27 36.09 26.41 36.47 26.04 36.78 25.62 37.09 25.21 37.36 24.75 37.62 24.29 37.83 23.83 38.07 23.32 38.26 22.77 38.26 22.74 38.24 22.74 38.05 22.77 37.81 22.79 37.62 22.86 37.38 22.88 37.19 22.9 36.95 22.9 36.76 22.88 36.55 22.79 36.38 23.09 36.33 23.16 36.26 23.16 36.14 23.18 36.07 23.16 36 23.09 35.95 23.02 35.9 22.93 35.85 22.81 35.81 23.04 35.69 23.23 35.52 23.43 35.4 23.64 35.26 23.76 35.12 23.83 34.95 23.87 34.78 23.89 34.66 24.01 34.57 24.17 34.47 24.29 34.28 24.38 34.18 24.38 34.07 24.38 33.95 24.4 33.85 24.45 33.83 24.45 33.83 24.47 33.85 24.54 33.9 24.56 33.95 24.59 33.99 24.59 34.07 24.59 34.09 24.59 34.14 24.59 34.18 24.59 34.47 24.47 34.52 24.45 34.57 24.42 34.64 24.4 34.66 24.33 34.69 24.24 34.76 24.12 34.81 24.01 34.9 23.92 35.04 23.89 35.14 23.85 35.28 23.83 35.4 23.85 35.52 23.99 35.62 24.12 35.69 24.29 35.69 24.47 35.69 24.65 35.66 24.79 35.62 24.93 35.54 25.02 35.52 25.23 35.5 25.41 35.47 25.58 35.38 25.71 35.35 25.85 35.33 25.99 35.23 26.08 35.14 26.2 35.12 26.24 35.12 26.31 35.12 26.36 35.09 26.41 34.97 26.47 34.83 26.52 34.69 26.54 34.54 26.54 34.33 26.47 34.09 26.38 33.9 26.34 33.66 26.27 33.42 26.24 33.23 26.2 32.99 26.13 32.78 26.08 32.61 26.06 32.42 26.04 32.28 26.04 32.14 26.06 32.09 26.13 32.09 26.2 32.11 26.22 32.18 26.24 32.21 26.27 32.42 26.31 32.66 26.36 32.9 26.45 33.11 26.5 33.33 26.59 33.52 26.68 33.71 26.77 33.92 26.89"/>
				<polygon class="cls-3" points="27.11 26.2 27.11 26.2 27.13 26.2 27.18 25.97 27.2 25.71 27.22 25.51 27.37 25.3 27.51 25.25 27.63 25.25 27.77 25.25 27.89 25.23 27.92 25.16 27.92 25.14 27.92 25.09 27.92 25.02 27.84 24.98 27.8 24.95 27.75 24.86 27.7 24.79 27.68 24.68 27.65 24.56 27.68 24.45 27.77 24.4 27.75 23.85 27.77 23.83 27.8 23.76 27.84 23.73 27.92 23.71 27.68 23.78 27.42 23.78 27.2 23.78 26.94 23.71 26.68 23.62 26.46 23.55 26.2 23.43 25.98 23.32 25.84 23.27 25.7 23.18 25.56 23.06 25.48 22.93 25.48 22.9 25.48 22.88 25.39 23.04 25.27 23.18 25.13 23.32 24.98 23.43 24.82 23.59 24.67 23.73 24.51 23.89 24.34 24.06 24.2 24.24 24.03 24.38 23.89 24.54 23.74 24.68 24.08 24.93 24.46 25.16 24.82 25.39 25.22 25.62 25.65 25.78 26.1 25.94 26.56 26.06 27.06 26.17 27.08 26.2 27.11 26.2"/>
				<polygon class="cls-3" points="30.99 24.7 31.71 24.29 31.71 24.26 31.75 24.24 31.75 24.17 31.75 24.15 31.25 24.24 31.23 24.24 31.23 24.26 31.21 24.29 31.11 24.33 31.04 24.4 30.97 24.47 30.92 24.59 30.97 24.68 30.99 24.7"/>
				<polygon class="cls-3" points="14.47 23.99 14.59 23.71 14.61 23.64 14.68 23.62 14.76 23.59 14.78 23.55 14.76 23.43 14.8 23.32 14.83 23.2 14.83 23.09 14.8 23 14.8 22.88 14.83 22.79 14.83 22.67 14.95 22.44 15.07 22.17 15.23 21.94 15.47 21.77 15.69 21.66 15.88 21.5 16.02 21.34 16.21 21.2 16.33 21.2 16.47 21.2 16.54 21.24 16.64 21.34 16.69 21.38 16.76 21.43 16.81 21.52 16.83 21.57 16.69 21.29 16.64 20.97 16.62 20.65 16.64 20.32 16.66 20.3 16.66 20.28 16.66 20.25 16.33 20.28 15.97 20.3 15.64 20.32 15.3 20.32 14.95 20.32 14.61 20.3 14.23 20.3 13.9 20.28 13.87 20.28 13.87 20.25 13.83 20.25 13.8 20.25 13.97 21.15 14.16 22.1 14.3 23.04 14.45 23.99 14.47 23.99"/>
				<polygon class="cls-3" points="22.98 23.99 23.17 23.73 23.36 23.55 23.6 23.32 23.79 23.09 23.55 22.17 23.53 22.12 23.51 22.12 23.48 22.12 23.46 22.21 23.48 22.33 23.51 22.44 23.53 22.51 23.53 22.53 23.51 22.58 23.48 22.6 23.41 22.6 23.36 22.6 23.34 22.58 23.31 22.53 23.31 22.51 23.24 22.49 23.22 22.47 23.17 22.47 23.08 22.37 22.96 22.3 22.89 22.21 22.81 22.07 22.89 21.96 22.65 21.77 22.62 21.8 22.6 21.82 22.55 21.84 22.5 21.84 22.48 21.84 22.46 21.84 22.41 21.84 22.39 21.82 22.36 21.75 22.31 21.64 22.24 21.54 22.12 21.52 21.98 21.5 21.84 21.47 21.69 21.41 21.6 21.36 21.67 21.57 21.79 21.8 21.88 22.05 21.96 22.33 22.08 22.53 22.19 22.77 22.34 23 22.46 23.18 22.6 23.36 22.7 23.57 22.84 23.76 22.96 23.99 22.98 23.99"/>
				<polygon class="cls-3" points="32.68 23.64 32.71 23.64 32.78 23.64 32.8 23.62 32.83 23.59 32.85 23.46 32.83 23.34 32.78 23.2 32.68 23.09 32.33 22.88 32.35 22.74 32.33 22.74 32.28 22.72 32.23 22.72 32.21 22.72 32.18 22.74 32.14 22.79 32.09 22.81 32.06 22.88 32.09 23 32.11 23.09 32.14 23.18 32.23 23.27 32.28 23.3 32.37 23.32 32.42 23.34 32.49 23.36 32.52 23.46 32.54 23.5 32.61 23.59 32.66 23.64 32.68 23.64"/>
				<polygon class="cls-3" points="28.08 22.86 28.56 22.77 28.68 22.49 28.8 22.21 28.94 21.94 29.13 21.71 29.25 21.71 29.37 21.71 29.49 21.75 29.61 21.75 29.68 21.75 29.8 21.75 29.92 21.71 29.99 21.68 30.11 21.5 30.2 21.27 30.25 21.06 30.28 20.83 30.09 20.6 30.04 20.32 29.99 20.05 29.85 19.82 29.85 19.77 29.82 19.72 29.82 19.7 29.8 19.68 29.75 19.61 29.66 19.59 29.61 19.56 29.54 19.49 29.54 19.4 29.61 19.29 29.63 19.19 29.66 19.08 29.68 19.06 29.68 19.03 29.8 18.99 29.82 18.94 29.82 18.89 29.82 18.87 29.8 18.8 29.75 18.73 29.68 18.62 29.68 18.53 29.68 18.43 29.7 18.39 29.7 18.36 29.7 18.34 29.75 18.32 29.47 18.2 29.35 18.09 29.23 17.95 29.11 17.83 28.96 17.74 28.92 17.67 28.89 17.6 28.82 17.56 28.75 17.54 28.61 17.51 28.49 17.49 28.34 17.49 28.2 17.51 28.13 17.47 28.08 17.4 28.06 17.35 28.04 17.28 27.89 17.21 27.77 17.12 27.68 17.01 27.63 16.84 27.65 16.73 27.75 16.68 27.82 16.66 27.94 16.66 28.06 16.66 28.11 16.68 28.13 16.68 28.2 16.68 28.23 16.68 28.23 16.66 28.2 16.66 28.18 16.66 28.13 16.64 28.11 16.57 28.08 16.54 28.06 16.52 27.46 16.57 27.46 16.59 27.42 16.59 27.42 16.64 27.53 16.73 27.65 17.35 27.56 17.47 27.49 17.56 27.37 17.65 27.22 17.74 27.11 17.81 26.96 17.88 26.82 17.93 26.68 17.97 26.63 17.97 26.56 18.02 26.51 18.02 26.46 18.04 26.27 18.39 26.13 18.46 25.98 18.57 25.89 18.66 25.77 18.8 25.7 19.15 25.68 19.47 25.63 19.82 25.6 20.14 25.6 20.16 25.56 20.18 25.53 20.23 25.51 20.23 25.41 20.23 25.34 20.23 25.25 20.18 25.2 20.14 25.13 19.98 25.08 19.82 25.03 19.63 24.91 19.54 24.82 19.68 24.79 19.7 24.75 19.7 24.65 19.68 24.63 19.63 24.53 19.59 24.46 19.56 24.36 19.56 24.27 19.59 24.1 19.75 24.03 19.95 23.93 20.16 23.84 20.37 23.79 20.39 23.74 20.42 23.7 20.44 23.65 20.51 23.67 20.53 23.7 20.55 23.77 20.55 23.82 20.55 23.96 20.53 24.1 20.51 24.24 20.46 24.39 20.44 24.53 20.42 24.67 20.42 24.82 20.39 24.96 20.39 24.98 20.39 25.06 20.32 25.08 20.3 25.1 20.28 25.27 20.3 25.32 20.32 25.36 20.39 25.39 20.44 25.39 20.53 25.41 20.53 25.48 20.46 25.56 20.42 25.6 20.37 25.63 20.28 25.63 20.16 25.63 20.09 25.65 20 25.7 19.91 25.98 19.86 26.08 20.14 26.22 20.25 26.1 20.46 25.96 20.67 25.84 20.88 25.79 21.15 25.77 21.22 25.7 21.27 25.63 21.29 25.56 21.29 25.53 21.29 25.51 21.27 25.48 21.27 25.46 21.24 25.46 21.22 25.46 21.2 25.41 21.15 25.41 21.13 25.39 21.13 25.39 21.15 25.36 21.15 25.36 21.2 25.63 21.54 25.77 21.38 25.91 21.2 26.08 21.06 26.32 20.95 26.34 20.83 26.39 20.39 26.51 20.28 26.7 20.23 26.89 20.23 27.08 20.18 27.32 20.18 27.53 20.23 27.75 20.28 27.92 20.39 27.92 20.42 27.94 20.42 27.94 20.44 27.94 20.51 27.92 20.53 27.89 20.58 27.84 20.6 27.96 20.78 27.65 21.43 27.65 21.52 27.65 21.61 27.63 21.68 27.56 21.77 27.53 21.77 27.51 21.8 27.46 21.96 27.37 22.05 27.27 22.1 27.18 22.12 27.06 22.17 26.94 22.17 26.82 22.19 26.7 22.21 26.6 22.24 26.53 22.24 26.49 22.24 26.41 22.24 26.37 22.24 26.46 22.35 26.6 22.44 26.77 22.51 26.91 22.6 27.06 22.65 27.2 22.67 27.37 22.74 27.51 22.77 27.65 22.79 27.8 22.79 27.94 22.81 28.08 22.86"/>
				<polygon class="cls-3" points="24.22 22.72 24.36 22.58 24.51 22.44 24.67 22.3 24.89 22.24 24.6 22.07 24.51 22.24 24.41 22.4 24.34 22.53 24.2 22.65 24.2 22.67 24.2 22.72 24.22 22.72"/>
				<polygon class="cls-3" points="17.81 22.21 17.88 22.05 17.95 21.91 18.05 21.77 18.17 21.66 18.17 21.64 18.07 21.52 17.97 21.38 17.95 21.24 17.97 21.08 18.07 20.92 18.09 20.74 18.17 20.58 18.21 20.42 18.45 20.28 18.33 20.28 18.21 20.3 18.07 20.32 17.95 20.3 17.83 20.3 17.76 20.28 17.64 20.25 17.55 20.18 17.69 20.65 17.78 21.13 17.81 21.64 17.81 22.12 17.81 22.17 17.81 22.19 17.81 22.21"/>
				<polygon class="cls-3" points="38.43 22.05 38.55 21.64 38.64 21.22 38.69 20.81 38.76 20.39 38.76 20.37 38.79 20.3 38.79 20.28 38.81 20.25 38.62 20.25 38.38 20.25 38.19 20.25 37.95 20.25 37.72 20.25 37.52 20.23 37.29 20.16 37.09 20.09 37.19 20.18 37.29 20.3 37.38 20.42 37.47 20.53 37.52 20.65 37.55 20.74 37.57 20.88 37.62 20.99 37.86 21.22 38.09 21.47 38.26 21.71 38.4 22.05 38.43 22.05"/>
				<polygon class="cls-1" points="4.31 21.52 4.53 20.58 4.89 19.72 5.32 18.92 5.79 18.18 6.32 17.47 6.82 16.77 7.34 16.04 7.82 15.32 8.06 14.93 8.25 14.52 8.44 14.1 8.61 13.64 8.77 13.2 8.89 12.72 9.01 12.26 9.08 11.82 8.75 12.37 8.32 12.86 7.82 13.36 7.29 13.82 6.75 14.31 6.22 14.79 5.77 15.3 5.36 15.85 5.17 16.13 5.01 16.45 4.86 16.8 4.72 17.12 4.62 17.49 4.51 17.83 4.46 18.23 4.39 18.59 4.36 18.62 4.39 17.14 4.46 15.67 4.39 14.15 4.15 12.65 4.08 11.68 4.15 10.65 4.36 9.68 4.79 8.83 4.74 8.83 4.67 8.85 4.62 8.92 4.58 8.96 4.46 9.13 4.34 9.26 4.22 9.45 4.1 9.59 4.03 9.75 3.91 9.89 3.81 10.05 3.72 10.21 3.34 10.85 3.05 11.55 2.79 12.24 2.62 12.97 2.53 13.73 2.48 14.47 2.5 15.21 2.62 15.97 2.79 16.68 3 17.37 3.24 18.04 3.5 18.73 3.77 19.4 4.01 20.09 4.17 20.78 4.29 21.5 4.29 21.52 4.29 21.54 4.31 21.52"/>
				<polygon class="cls-1" points="52.09 21.2 52.16 20.55 52.3 19.91 52.52 19.31 52.71 18.66 52.95 18.06 53.16 17.42 53.38 16.82 53.57 16.18 53.73 15.14 53.78 14.08 53.66 13.04 53.42 12.01 53.07 11.01 52.59 10.09 52.06 9.24 51.42 8.5 51.4 8.48 51.37 8.48 51.35 8.48 51.3 8.44 51.54 8.83 51.73 9.24 51.87 9.72 51.99 10.21 52.02 12.21 51.87 14.2 51.83 16.22 51.99 18.2 51.99 18.23 51.97 18.25 51.95 18.25 51.87 18.18 51.87 18.04 51.85 17.9 51.83 17.77 51.8 17.65 51.8 17.54 51.78 17.42 51.73 17.33 51.64 16.84 51.44 16.41 51.26 15.99 50.99 15.6 50.7 15.25 50.4 14.89 50.06 14.56 49.71 14.22 49.35 13.89 48.97 13.59 48.58 13.25 48.25 12.93 47.92 12.58 47.58 12.26 47.35 11.89 47.08 11.52 47.15 12.03 47.3 12.58 47.49 13.11 47.68 13.64 47.92 14.17 48.15 14.63 48.42 15.07 48.7 15.48 49.2 16.15 49.71 16.82 50.23 17.47 50.68 18.11 51.13 18.8 51.52 19.54 51.83 20.32 52.06 21.2 52.06 21.22 52.09 21.2"/>
				<polygon class="cls-3" points="16.69 19.31 16.64 18.5 16.76 17.7 16.97 16.87 17.21 16.08 17.45 15.48 17.69 14.93 17.95 14.45 18.24 13.94 18.55 13.48 18.88 13.04 19.24 12.56 19.64 12.12 19.38 11.89 19.12 11.68 18.88 11.43 18.62 11.17 18.36 10.97 18.12 10.71 17.88 10.44 17.66 10.18 17.36 10.65 17.02 11.11 16.66 11.55 16.35 11.96 16.04 12.4 15.76 12.83 15.47 13.34 15.23 13.82 14.95 14.47 14.68 15.14 14.49 15.83 14.33 16.52 14.16 17.21 14.04 17.9 13.95 18.59 13.9 19.29 14.23 19.29 14.59 19.29 14.95 19.26 15.3 19.26 15.64 19.26 16.02 19.26 16.35 19.29 16.69 19.31"/>
				<polygon class="cls-3" points="17.59 19.31 17.74 19.29 17.88 19.26 18.02 19.22 18.17 19.22 18.31 19.22 18.45 19.22 18.59 19.26 18.74 19.29 18.67 19.03 18.62 18.76 18.59 18.48 18.64 18.23 18.76 18.04 18.83 17.81 18.95 17.6 19.1 17.42 19.17 17.28 19.21 17.12 19.31 17.01 19.41 16.94 19.6 16.94 19.76 16.94 19.91 16.91 20.02 16.8 20.05 16.73 20.05 16.68 20.02 16.64 19.98 16.57 20.05 16.5 20.12 16.41 20.24 16.36 20.34 16.29 20.45 16.27 20.55 16.24 20.64 16.18 20.74 16.13 20.88 15.9 21.05 15.74 21.24 15.6 21.46 15.48 21.67 15.35 21.88 15.21 22.03 15.05 22.17 14.86 22.22 14.79 22.31 14.77 22.39 14.75 22.48 14.75 22.22 14.56 21.93 14.31 21.67 14.08 21.38 13.82 21.12 13.59 20.88 13.34 20.62 13.09 20.38 12.83 20.24 13 20.12 13.13 19.98 13.32 19.83 13.48 19.69 13.64 19.6 13.8 19.45 14.01 19.33 14.17 18.98 14.7 18.67 15.28 18.4 15.9 18.19 16.57 17.97 17.26 17.81 17.95 17.66 18.64 17.55 19.31 17.59 19.31"/>
				<polygon class="cls-3" points="10.01 19.31 10.37 19.29 10.75 19.26 11.09 19.26 11.47 19.26 11.82 19.26 12.21 19.26 12.54 19.29 12.92 19.29 12.97 17.93 13.21 16.59 13.54 15.3 14.04 14.03 14.61 12.83 15.26 11.71 16.02 10.69 16.83 9.75 16.9 9.72 16.93 9.68 16.97 9.66 17.02 9.63 16.78 9.4 16.52 9.17 16.26 8.92 15.97 8.67 15.73 8.41 15.47 8.13 15.23 7.86 15.04 7.56 14.76 7.86 14.49 8.13 14.23 8.44 13.97 8.76 13.73 9.06 13.49 9.38 13.25 9.68 13.04 10 12.66 10.58 12.32 11.15 11.97 11.75 11.68 12.37 11.37 13.04 11.11 13.69 10.89 14.38 10.66 15.12 10.54 15.48 10.47 15.88 10.37 16.24 10.3 16.64 10.18 17.28 10.11 17.95 10.06 18.62 10.01 19.31"/>
				<polygon class="cls-3" points="43.48 19.29 43.84 19.22 44.2 19.17 44.55 19.15 44.94 19.15 45.29 19.15 45.7 19.15 46.08 19.17 46.44 19.17 46.37 18.34 46.25 17.51 46.11 16.71 45.91 15.9 45.7 15.12 45.44 14.33 45.15 13.55 44.84 12.81 44.51 12.1 44.15 11.38 43.77 10.69 43.34 10.02 42.86 9.38 42.39 8.76 41.91 8.16 41.36 7.58 41.34 7.56 41.34 7.54 41.29 7.51 41.27 7.47 41.15 7.7 39.34 9.47 39.1 9.47 39.07 9.47 39.07 9.49 39.07 9.52 39.1 9.52 39.12 9.54 39.14 9.54 39.14 9.59 39.19 9.59 39.29 9.75 39.43 9.91 39.62 10.07 39.79 10.21 39.93 10.35 40.1 10.51 40.24 10.69 40.36 10.88 40.5 11.01 40.62 11.13 40.72 11.24 40.86 11.34 41 11.57 41.15 11.8 41.34 11.98 41.43 12.24 41.69 12.51 41.86 12.81 42.05 13.13 42.15 13.48 42.27 13.8 42.41 14.17 42.53 14.52 42.7 14.86 42.86 15.42 43.05 15.97 43.2 16.52 43.29 17.07 43.41 17.63 43.48 18.2 43.51 18.73 43.48 19.29"/>
				<polygon class="cls-3" points="39.81 19.22 40.15 19.19 40.5 19.17 40.84 19.17 41.19 19.17 41.53 19.17 41.86 19.17 42.22 19.17 42.55 19.17 42.48 18.66 42.41 18.2 42.34 17.67 42.27 17.19 42.15 16.66 42.05 16.15 41.86 15.62 41.69 15.14 41.58 14.89 41.5 14.61 41.38 14.38 41.24 14.2 41.1 14.24 40.93 14.31 40.76 14.31 40.62 14.29 40.53 14.05 40.33 13.87 40.15 13.64 39.98 13.46 39.79 13.25 39.65 13.13 39.5 13.06 39.36 12.97 39.22 12.9 39.07 12.83 38.93 12.77 38.79 12.67 38.64 12.56 38.43 12.49 38.29 12.37 38.19 12.24 38.09 12.1 38.09 12.03 38.09 12.01 38.09 11.96 38.07 11.94 37.93 11.87 37.78 11.84 37.62 11.82 37.5 11.73 37.38 11.71 37.29 11.61 37.24 11.55 37.19 11.43 37.09 11.01 37 10.6 36.85 10.23 36.57 9.95 36.5 9.93 36.38 9.91 36.28 9.93 36.21 9.95 36.09 10.05 35.97 10.14 35.83 10.16 35.69 10.16 35.62 10 35.54 9.79 35.52 9.63 35.38 9.47 35.35 9.31 35.4 9.13 35.43 8.96 35.4 8.8 35.23 8.69 35.12 8.5 35.04 8.27 34.97 8.06 34.95 7.97 34.92 7.88 34.85 7.81 34.83 7.72 34.54 7.44 34.21 7.24 33.83 7.03 33.42 6.84 32.99 6.71 32.56 6.57 32.11 6.45 31.68 6.32 31.35 6.22 30.99 6.18 30.68 6.13 30.35 6.06 30.04 6.02 29.7 5.99 29.37 5.95 29.06 5.92 29.04 5.92 28.96 5.92 28.94 5.92 28.92 5.92 28.56 5.81 28.63 6.45 28.65 7.14 28.63 7.83 28.56 8.5 28.56 8.52 28.61 8.52 28.99 8.52 29.39 8.55 29.8 8.62 30.2 8.67 30.61 8.76 30.97 8.83 31.37 8.94 31.78 9.06 32.14 9.2 32.52 9.33 32.9 9.49 33.25 9.63 33.61 9.79 33.92 10 34.23 10.16 34.54 10.35 34.61 10.42 34.66 10.48 34.71 10.55 34.81 10.58 34.69 10.44 34.57 10.3 34.47 10.16 34.38 9.95 34.38 9.93 34.38 9.91 34.4 9.91 34.49 9.89 34.47 9.68 34.35 9.54 34.23 9.4 34.14 9.24 34.14 9.2 34.18 9.17 34.23 9.13 34.26 9.1 34.28 9.1 34.33 9.1 34.35 9.1 34.49 9.22 34.61 9.33 34.71 9.47 34.83 9.59 34.92 9.68 35 9.82 35.12 9.93 35.23 10.05 35.4 10.05 35.57 10.09 35.69 10.21 35.83 10.32 35.9 10.51 35.95 10.69 36 10.88 36.09 11.04 36.24 11.41 36.5 11.68 36.69 11.98 36.78 12.35 36.85 12.37 36.95 12.37 37 12.42 37.09 12.51 37.21 12.67 37.36 12.81 37.47 12.95 37.52 13.13 37.5 13.2 37.5 13.23 37.5 13.27 37.52 13.32 37.55 13.34 37.57 13.36 37.62 13.41 37.64 13.46 37.81 13.48 37.95 13.41 38.09 13.34 38.26 13.27 38.33 13.32 38.36 13.34 38.4 13.41 38.43 13.48 38.43 13.62 38.38 13.69 38.33 13.8 38.26 13.92 38.26 13.94 38.29 13.97 38.4 13.94 38.5 13.92 38.62 13.92 38.69 13.97 38.71 14.03 38.71 14.08 38.69 14.17 38.67 14.22 38.62 14.29 38.57 14.33 38.52 14.36 38.5 14.38 38.52 14.61 38.55 14.61 38.57 14.63 38.67 14.63 38.79 14.63 38.86 14.7 38.95 14.75 39 14.93 39.1 15.14 39.14 15.35 39.22 15.55 39.07 15.95 39.1 16.36 39.12 16.77 39.05 17.14 38.91 17.4 38.79 17.67 38.67 17.95 38.48 18.18 38.43 18.25 38.38 18.32 38.36 18.36 38.26 18.39 38.14 18.43 38.07 18.43 37.95 18.46 37.83 18.48 37.78 18.57 37.78 18.71 37.81 18.8 37.83 18.92 37.9 19.03 37.83 19.15 37.81 19.17 38.83 19.19 38.71 18.99 38.69 18.73 38.69 18.46 38.71 18.2 38.86 17.88 38.98 17.54 39.12 17.24 39.24 16.94 39.34 16.84 39.41 16.8 39.5 16.73 39.57 16.71 39.62 16.71 39.65 16.73 39.65 16.8 39.67 16.82 39.67 17.05 39.65 17.28 39.57 17.51 39.5 17.74 39.67 18.06 39.76 18.43 39.79 18.85 39.79 19.22 39.81 19.22"/>
				<polygon class="cls-3" points="37.69 18.02 37.81 18.02 37.93 17.97 38.05 17.93 38.12 17.83 38.21 17.67 38.33 17.54 38.4 17.37 38.5 17.21 38.38 16.84 38.26 16.45 38.12 16.13 37.95 15.83 37.83 15.76 37.69 15.69 37.57 15.6 37.5 15.53 37.38 15.46 37.26 15.39 37.12 15.3 37 15.25 36.95 15.18 36.93 15.14 36.9 15.07 36.9 15 36.98 14.84 37.07 14.65 37.12 14.49 37.12 14.33 37 14.15 36.85 13.92 36.69 13.73 36.55 13.53 36.38 13.34 36.21 13.13 36.05 12.93 35.9 12.72 35.71 12.95 35.52 13.2 35.28 13.41 35.07 13.62 34.83 13.82 34.57 14.05 34.35 14.29 34.12 14.49 33.99 14.63 33.9 14.77 33.76 14.91 33.64 15.02 33.52 15.16 33.38 15.3 33.25 15.42 33.14 15.55 33.25 15.74 33.38 15.83 33.4 15.74 33.42 15.67 33.47 15.6 33.52 15.53 33.54 15.42 33.56 15.32 33.56 15.25 33.61 15.16 33.66 15.07 33.76 15.05 33.85 15 33.97 14.98 34.12 15.05 34.23 15.07 34.38 15.12 34.52 15.12 34.66 15.12 34.81 15.12 34.95 15.14 35.09 15.16 35.23 15.16 35.35 15.16 35.5 15.16 35.64 15.18 35.76 15.21 35.85 15.25 35.97 15.3 36.07 15.42 36.14 15.53 36.21 15.67 36.26 15.81 36.38 15.9 36.4 15.9 36.43 15.95 36.47 15.97 36.5 15.99 36.52 16.01 36.52 16.04 36.52 16.11 36.55 16.13 36.38 16.36 36.38 16.38 36.55 16.59 36.57 16.59 36.57 16.57 36.62 16.57 36.76 16.45 36.93 16.36 37.12 16.29 37.36 16.31 37.52 16.41 37.64 16.52 37.76 16.66 37.83 16.77 38.07 16.84 38.09 16.91 38.09 16.96 38.09 17.01 38.07 17.1 38 17.12 37.95 17.14 37.9 17.21 37.83 17.24 37.83 17.35 37.81 17.49 37.76 17.6 37.67 17.7 37.67 17.79 37.64 17.83 37.64 17.93 37.64 18.02 37.67 18.02 37.69 18.02"/>
				<polygon class="cls-3" points="30.51 16.64 30.9 16.54 30.92 16.52 30.92 16.41 30.94 16.31 30.99 16.24 31.09 16.15 31.23 16.01 31.4 15.9 31.56 15.81 31.75 15.71 31.9 15.6 32.06 15.48 32.21 15.35 32.33 15.18 32.14 15.21 31.92 15.07 31.9 15.05 31.9 15 31.9 14.93 31.92 14.91 32.06 14.86 32.18 14.75 32.33 14.63 32.47 14.59 32.35 14.52 32.23 14.47 32.11 14.38 31.99 14.33 31.9 14.29 31.8 14.2 31.68 14.15 31.56 14.08 31.25 13.89 30.92 13.76 30.54 13.62 30.13 13.5 29.75 13.39 29.37 13.32 28.96 13.23 28.61 13.13 28.65 13.62 28.68 14.05 28.65 14.52 28.68 15 29.39 15.28 29.54 15.14 29.7 14.98 29.89 14.86 30.11 14.75 30.13 14.7 30.2 14.63 30.25 14.59 30.35 14.56 30.4 14.56 30.49 14.61 30.54 14.63 30.56 14.7 30.61 14.93 30.56 15.16 30.49 15.39 30.4 15.58 30.28 15.69 30.2 15.76 30.09 15.83 29.97 15.9 29.89 15.97 29.78 16.01 29.66 16.08 29.54 16.13 29.27 16.31 29.27 16.36 29.49 16.36 29.63 16.27 29.78 16.22 29.97 16.24 30.09 16.29 30.18 16.38 30.25 16.43 30.35 16.5 30.37 16.54 30.4 16.57 30.47 16.59 30.51 16.64"/>
				<polygon class="cls-3" points="25.68 16.01 26.13 15.9 26.2 15.83 26.25 15.74 26.27 15.67 26.37 15.58 26.39 15.39 26.41 15.18 26.51 15.02 26.65 14.89 26.68 14.86 26.75 14.86 26.77 14.86 26.8 14.86 26.84 14.91 26.84 15 26.82 15.07 26.82 15.16 26.99 15.18 27.18 15.16 27.34 15.12 27.51 15.07 27.68 15.21 27.65 15.14 27.63 15.02 27.61 14.91 27.56 14.79 27.53 14.38 27.53 14.01 27.53 13.62 27.56 13.2 27.03 13.27 26.49 13.41 25.94 13.55 25.46 13.76 24.96 14.01 24.51 14.24 24.08 14.56 23.7 14.89 23.65 14.93 23.62 14.98 23.55 15.02 23.51 15.05 23.7 15.07 24.24 15.32 24.48 15.55 24.48 15.58 24.48 15.6 24.48 15.62 24.46 15.69 24.39 15.71 24.34 15.74 24.32 15.81 24.51 15.95 24.6 15.95 24.63 15.88 24.65 15.85 24.65 15.81 24.67 15.76 24.67 15.74 24.7 15.74 24.75 15.71 24.77 15.71 24.89 15.74 24.96 15.81 25.03 15.9 25.13 15.97 25.22 15.97 25.32 15.95 25.39 15.9 25.48 15.88 25.51 15.9 25.53 15.9 25.56 15.95 25.6 15.97 25.65 16.04 25.68 16.01"/>
				<polygon class="cls-1" points="5.08 15.18 5.44 14.63 5.82 14.15 6.29 13.64 6.77 13.2 7.25 12.77 7.77 12.31 8.3 11.89 8.8 11.45 9.32 11.01 9.77 10.55 10.2 10.07 10.58 9.54 10.89 8.99 11.16 8.39 11.32 7.72 11.4 7.01 11.18 7.42 10.89 7.83 10.54 8.23 10.2 8.62 9.8 8.94 9.39 9.24 8.96 9.54 8.58 9.79 8.15 10.09 7.75 10.44 7.34 10.78 6.96 11.15 6.63 11.57 6.32 11.98 6.06 12.42 5.86 12.9 5.82 12.9 5.79 12.9 5.91 12.49 6.03 12.03 6.17 11.61 6.34 11.17 6.48 10.74 6.6 10.3 6.72 9.89 6.79 9.45 6.82 9.24 6.89 9.08 6.91 8.92 6.94 8.76 7.03 8.34 7.15 7.95 7.25 7.56 7.39 7.19 7.58 6.84 7.77 6.5 8.01 6.2 8.25 5.92 8.82 5.46 8.37 5.6 7.94 5.76 7.53 6.02 7.18 6.27 6.79 6.57 6.48 6.89 6.17 7.26 5.89 7.6 5.39 8.48 5.15 9.38 5.03 10.35 5.01 11.32 5.05 12.28 5.1 13.27 5.1 14.24 5.05 15.18 5.08 15.18"/>
				<polygon class="cls-1" points="51.23 14.86 51.13 13.97 51.11 13.06 51.11 12.17 51.16 11.27 51.21 10.69 51.16 10.09 51.09 9.52 50.97 8.94 50.8 8.39 50.56 7.86 50.28 7.37 49.97 6.96 49.66 6.61 49.37 6.32 49.06 6.04 48.7 5.79 48.37 5.6 48.01 5.39 47.63 5.25 47.2 5.16 47.58 5.44 47.94 5.76 48.23 6.13 48.49 6.5 48.68 6.96 48.87 7.42 49.01 7.88 49.13 8.39 49.25 8.92 49.37 9.45 49.51 9.95 49.68 10.48 49.85 10.99 50.06 11.52 50.23 12.01 50.42 12.51 50.42 12.54 50.4 12.54 50.4 12.56 50.37 12.56 50.35 12.54 50.06 11.94 49.68 11.38 49.23 10.85 48.73 10.37 48.2 9.93 47.66 9.52 47.11 9.17 46.56 8.83 46.25 8.62 45.96 8.39 45.7 8.13 45.44 7.88 45.22 7.6 45.01 7.3 44.84 7.03 44.67 6.73 44.72 7.17 44.84 7.6 44.98 8.06 45.15 8.5 45.34 8.92 45.56 9.31 45.8 9.66 46.06 10 46.37 10.32 46.68 10.62 47.01 10.9 47.37 11.2 47.73 11.48 48.09 11.75 48.44 12.01 48.8 12.28 49.16 12.56 49.51 12.86 49.82 13.13 50.13 13.46 50.44 13.78 50.7 14.15 50.97 14.49 51.21 14.89 51.23 14.86"/>
				<polygon class="cls-3" points="33.25 14.01 33.5 13.76 33.71 13.5 33.95 13.25 34.21 12.97 34.47 12.72 34.76 12.49 35 12.28 35.28 12.12 35.26 12.1 35.21 12.08 35.14 12.03 35.09 12.03 34.78 11.8 34.47 11.55 34.12 11.32 33.76 11.11 33.38 10.88 32.97 10.69 32.56 10.48 32.18 10.32 31.75 10.18 31.32 10.02 30.9 9.91 30.42 9.79 29.99 9.68 29.54 9.61 29.08 9.54 28.63 9.49 28.61 9.47 28.56 9.47 28.63 10.14 28.65 10.78 28.63 11.48 28.63 12.14 29.25 12.21 29.89 12.31 30.49 12.44 31.09 12.67 31.66 12.93 32.21 13.2 32.68 13.5 33.14 13.82 33.19 13.87 33.21 13.92 33.23 13.94 33.23 14.01 33.25 14.01"/>
				<polygon class="cls-3" points="23.1 14.01 23.1 14.01 23.1 13.97 23.36 13.73 23.65 13.5 23.96 13.27 24.27 13.09 24.63 12.93 24.96 12.77 25.34 12.63 25.7 12.49 25.94 12.42 26.18 12.35 26.39 12.28 26.65 12.24 26.89 12.21 27.11 12.17 27.34 12.14 27.56 12.17 27.53 11.52 27.51 10.83 27.53 10.16 27.61 9.47 27.13 9.52 26.7 9.61 26.27 9.68 25.82 9.79 25.39 9.91 24.96 10.05 24.55 10.18 24.17 10.32 23.77 10.48 23.36 10.69 22.98 10.85 22.62 11.06 22.27 11.27 21.93 11.48 21.62 11.73 21.31 11.98 21.22 12.01 21.17 12.08 21.12 12.1 21.07 12.14 21.34 12.35 21.6 12.56 21.84 12.79 22.1 13.04 22.36 13.27 22.6 13.53 22.84 13.78 23.08 14.01 23.1 14.01"/>
				<polygon class="cls-3" points="20.34 11.48 20.36 11.48 20.36 11.45 20.38 11.45 20.62 11.24 20.88 11.01 21.12 10.83 21.38 10.6 21.65 10.44 21.91 10.23 22.19 10.07 22.48 9.93 22.77 9.77 23.05 9.63 23.36 9.49 23.67 9.36 23.98 9.24 24.34 9.13 24.67 9.03 25.03 8.92 25.34 8.83 25.65 8.76 25.96 8.69 26.27 8.64 26.6 8.57 26.94 8.55 27.22 8.52 27.53 8.52 27.53 7.88 27.51 7.26 27.51 6.59 27.53 5.95 27.53 5.92 27.06 5.95 26.56 5.99 26.06 6.04 25.56 6.13 25.08 6.22 24.55 6.34 24.08 6.48 23.6 6.61 23.1 6.78 22.65 6.96 22.19 7.14 21.77 7.37 21.34 7.56 20.91 7.79 20.53 8 20.17 8.25 19.93 8.39 19.69 8.55 19.48 8.76 19.26 8.92 19.05 9.1 18.81 9.26 18.59 9.4 18.36 9.54 18.33 9.54 18.33 9.59 18.36 9.59 18.62 9.77 18.88 9.95 19.12 10.21 19.38 10.44 19.64 10.69 19.91 10.97 20.12 11.2 20.34 11.45 20.34 11.48"/>
				<polygon class="cls-1" points="7.44 9.82 7.77 9.52 8.15 9.22 8.49 8.94 8.87 8.64 9.23 8.36 9.58 8.02 9.94 7.72 10.3 7.37 10.75 6.82 11.18 6.27 11.59 5.67 11.97 5.12 12.44 4.56 12.9 4.06 13.4 3.5 14.02 2.97 13.52 3.14 13.04 3.3 12.54 3.5 12.09 3.69 11.63 3.92 11.18 4.13 10.78 4.38 10.37 4.66 9.96 4.95 9.63 5.25 9.3 5.62 9.01 5.99 8.73 6.36 8.46 6.78 8.25 7.26 8.08 7.72 7.94 8.27 7.8 8.83 7.6 9.36 7.39 9.86 7.44 9.82"/>
				<polygon class="cls-1" points="48.7 9.52 48.54 8.85 48.35 8.25 48.11 7.65 47.84 7.05 47.53 6.55 47.23 6.02 46.84 5.53 46.42 5.09 45.99 4.68 45.51 4.29 45.01 3.94 44.49 3.64 43.91 3.32 43.29 3.09 42.65 2.86 41.98 2.7 42.43 3.14 42.84 3.57 43.27 4.01 43.65 4.47 44.06 4.93 44.41 5.37 44.8 5.85 45.2 6.29 45.56 6.73 45.96 7.17 46.37 7.6 46.8 8.02 47.23 8.41 47.68 8.8 48.2 9.17 48.7 9.52"/>
				<polygon class="cls-3" points="17.74 8.92 18.05 8.62 18.36 8.29 18.69 8.02 19.02 7.79 19.36 7.54 19.69 7.3 20.05 7.1 20.41 6.87 20.76 6.68 21.12 6.5 21.53 6.32 21.93 6.15 22.34 5.99 22.74 5.81 23.17 5.64 23.62 5.51 23.65 5.51 23.67 5.51 24.17 5.35 24.63 5.23 25.1 5.12 25.6 5.02 26.08 4.95 26.6 4.91 27.08 4.89 27.56 4.84 27.51 4.66 27.49 4.47 27.46 4.24 27.46 4.06 27.46 3.83 27.46 3.6 27.46 3.39 27.46 3.16 27.46 2.91 27.46 2.63 27.46 2.4 27.51 2.14 26.75 2.19 25.98 2.26 25.22 2.35 24.48 2.49 23.74 2.7 22.98 2.88 22.24 3.11 21.55 3.37 20.84 3.64 20.17 3.94 19.5 4.24 18.88 4.61 18.26 4.95 17.69 5.35 17.12 5.74 16.62 6.15 16.47 6.27 16.35 6.34 16.23 6.48 16.09 6.59 15.97 6.71 15.83 6.78 15.69 6.87 15.54 6.96 15.83 7.12 16.16 7.33 16.45 7.58 16.69 7.83 16.97 8.11 17.24 8.39 17.5 8.67 17.74 8.92"/>
				<polygon class="cls-3" points="38.79 8.64 38.93 8.39 39.1 8.16 39.29 7.93 39.5 7.7 39.72 7.47 39.98 7.28 40.22 7.1 40.48 6.91 40.5 6.91 40.53 6.89 40.43 6.78 40.29 6.68 40.19 6.55 40.05 6.43 39.5 5.95 38.91 5.51 38.29 5.09 37.67 4.7 36.98 4.36 36.28 3.99 35.57 3.69 34.83 3.39 34.09 3.14 33.33 2.88 32.54 2.7 31.78 2.49 30.97 2.33 30.18 2.21 29.37 2.12 28.56 2.05 28.61 2.12 28.63 2.19 28.65 2.28 28.63 2.4 28.63 2.95 28.63 3.5 28.63 4.01 28.56 4.56 28.65 4.4 28.68 4.38 28.7 4.36 28.75 4.36 28.8 4.36 28.85 4.38 28.92 4.42 28.96 4.52 28.99 4.56 28.99 4.66 28.99 4.75 28.99 4.82 28.96 4.89 28.94 4.89 28.94 4.91 29.47 4.91 29.97 4.93 30.51 4.98 31.06 5.09 31.56 5.21 32.11 5.35 32.64 5.51 33.14 5.67 33.35 5.76 33.54 5.85 33.76 5.92 33.95 6.02 34.14 6.08 34.35 6.18 34.54 6.27 34.71 6.34 35.21 6.59 35.23 6.61 35.23 6.59 35.23 6.57 35.26 6.57 35.47 6.45 35.66 6.41 35.85 6.36 36.07 6.36 36.26 6.41 36.47 6.45 36.67 6.48 36.85 6.5 37 6.64 37.12 6.78 37.26 6.91 37.43 6.98 37.57 7.03 37.69 7.12 37.78 7.24 37.9 7.33 37.98 7.44 38.09 7.56 38.19 7.67 38.29 7.74 38.36 8.02 38.48 8.25 38.62 8.44 38.79 8.64"/>
				<polygon class="cls-1" points="37.41 6.71 37.64 6.71 37.67 6.71 37.69 6.68 37.72 6.64 37.72 6.61 37.67 6.45 37.62 6.27 37.57 6.08 37.5 5.92 37.38 5.88 37.24 5.85 37.12 5.85 36.98 5.88 36.93 5.85 36.85 5.81 36.81 5.79 36.76 5.81 36.71 5.85 36.69 5.85 36.67 5.85 36.64 5.88 36.64 5.99 36.67 6.06 36.69 6.15 36.78 6.2 36.93 6.29 37.05 6.41 37.14 6.5 37.24 6.61 37.41 6.71"/>
				<polygon class="cls-1" points="29.63 4.66 29.8 4.66 29.97 4.63 30.13 4.63 30.28 4.63 30.42 4.56 30.56 4.54 30.68 4.52 30.8 4.49 30.99 4.49 31.21 4.49 31.4 4.49 31.56 4.47 31.78 4.42 31.94 4.36 32.09 4.26 32.23 4.15 32.23 4.13 32.25 4.13 32.25 4.1 32.25 4.06 32.23 4.01 32.18 3.96 32.14 3.94 31.99 3.85 31.85 3.78 31.68 3.69 31.52 3.64 31.35 3.57 31.13 3.55 30.97 3.53 30.78 3.53 30.61 3.6 30.42 3.67 30.23 3.73 30.04 3.83 29.85 3.92 29.68 3.99 29.51 4.06 29.32 4.1 29.25 4.08 29.2 4.06 29.11 4.06 29.06 4.08 29.04 4.1 28.99 4.13 28.96 4.15 28.94 4.22 29.08 4.36 29.25 4.47 29.42 4.56 29.63 4.66"/>
			</g>
		</svg>
	</xsl:variable>

	<xsl:variable name="Image-Recycle">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAJkAAAAmCAYAAADXwDkaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA+lpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJNaWNyb3NvZnTCriBXb3JkIDIwMTYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MzM0NUVBQ0U2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MzM0NUVBQ0Y2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiPiA8ZGM6Y3JlYXRvcj4gPHJkZjpTZXE+IDxyZGY6bGk+RGhhbmplZTwvcmRmOmxpPiA8L3JkZjpTZXE+IDwvZGM6Y3JlYXRvcj4gPGRjOnRpdGxlPiA8cmRmOkFsdD4gPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ij4xODAxNzYzPC9yZGY6bGk+IDwvcmRmOkFsdD4gPC9kYzp0aXRsZT4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVm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</xsl:text>
	</xsl:variable>

			<xsl:strip-space elements="un:xref"/>

	<xsl:variable name="namespace_full" select="namespace-uri(/*)"/> <!-- example: https://www.metanorma.org/ns/iso -->
	<xsl:variable name="root_element" select="local-name(/*)"/> <!-- example: iso-standard -->

	<xsl:variable name="document_scheme" select="normalize-space(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'document-scheme']/*[local-name() = 'value'])"/>

	<!-- external parameters -->

	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="inputxml_basepath"/> <!-- input xml file path -->
	<xsl:param name="inputxml_filename"/> <!-- input xml file name -->
	<xsl:param name="output_path"/> <!-- output PDF file name -->
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->

	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths"/> <!-- (debug: path to) xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
		<table page-width="509103" id="table1" width_max="223561" width_min="223560">
			<column width_max="39354" width_min="39354"/>
			<column width_max="75394" width_min="75394"/>
			<column width_max="108813" width_min="108813"/>
			<tbody>
				<tr>
					<td width_max="39354" width_min="39354">
						<p_len>39354</p_len>
						<word_len>39354</word_len>
					</td>
					
		OLD:
			<tables>
					<table id="table_if_tab-symdu" page-width="75"> - table id prefixed by 'table_if_' to simple search in IF 
						<tbody>
							<tr>
								<td id="tab-symdu_1_1">
									<p_len>6</p_len>
									<p_len>100</p_len>  for 2nd paragraph
									<word_len>6</word_len>
									<word_len>20</word_len>
								...
	-->

	<!-- for command line debug: <xsl:variable name="table_widths_from_if" select="document($table_widths)"/> -->
	<xsl:variable name="table_widths_from_if" select="xalan:nodeset($table_widths)"/>

	<xsl:variable name="table_widths_from_if_calculated_">
		<xsl:for-each select="$table_widths_from_if//table">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:call-template name="calculate-column-widths-autolayout-algorithm"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="table_widths_from_if_calculated" select="xalan:nodeset($table_widths_from_if_calculated_)"/>

	<xsl:param name="table_if_debug">false</xsl:param> <!-- set 'true' to put debug width data before table or dl -->

	<xsl:variable name="isApplyAutolayoutAlgorithm_">
		true
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF_">
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:value-of select="normalize-space($table_if) = 'true'"/>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isGenerateTableIF" select="normalize-space($isGenerateTableIF_)"/>

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="inputxml_filename_prefix">
		<xsl:choose>
			<xsl:when test="contains($inputxml_filename, '.presentation.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.presentation.xml')"/>
			</xsl:when>
			<xsl:when test="contains($inputxml_filename, '.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputxml_filename"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->

	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->

	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata']/*[local-name() = 'papersize'])))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>

	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>
				210
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>

	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>
				297
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>

	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">
		40
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>

	<xsl:variable name="marginLeftRight2_">
		40
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>

	<xsl:variable name="marginTop_">
		30
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>

	<xsl:variable name="marginBottom_">
		40
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>

	<xsl:variable name="layout_columns_default">1</xsl:variable>
	<xsl:variable name="layout_columns_" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata']/*[local-name() = 'layout-columns'])"/>
	<xsl:variable name="layout_columns">
		<xsl:choose>
			<xsl:when test="$layout_columns_ != ''"><xsl:value-of select="$layout_columns_"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout_columns_default"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">

		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<!-- <title-toc lang="en">
			<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc> -->
		<title-toc lang="en">Table of contents</title-toc>
		<!-- <title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc> -->
		<!-- <title-toc lang="zh">
			<xsl:choose>
				<xsl:when test="$namespace = 'gb'">
					<xsl:text>目次</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contents</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title-toc> -->
		<title-toc lang="zh">目次</title-toc>

		<title-part lang="en">

		</title-part>
		<title-part lang="fr">

		</title-part>
		<title-part lang="ru">

		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>

		<title-subpart lang="en">Sub-part #</title-subpart>
		<title-subpart lang="fr">Partie de sub #</title-subpart>

	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>

	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='requirement']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']"/>
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']"/>
	</xsl:variable>

	<!-- Characters -->
	<xsl:variable name="linebreak">&#8232;</xsl:variable>
	<xsl:variable name="tab_zh">　</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">‑</xsl:variable>
	<xsl:variable name="thin_space"> </xsl:variable>
	<xsl:variable name="zero_width_space">​</xsl:variable>
	<xsl:variable name="hair_space"> </xsl:variable>
	<xsl:variable name="en_dash">–</xsl:variable>
	<xsl:variable name="em_dash">—</xsl:variable>
	<xsl:variable name="cr">&#13;</xsl:variable>
	<xsl:variable name="lf">
</xsl:variable>

	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

	<!-- ====================================== -->
	<!-- STYLES -->
	<!-- ====================================== -->
	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">

			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>

	</xsl:attribute-set> <!-- root-style -->

	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>

		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//*[contains(local-name(), '-standard')][1]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value'] |       //*[contains(local-name(), '-standard')][1]/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value']">
				<xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="additional_fonts" select="normalize-space($additional_fonts_)"/>

		<xsl:variable name="font_family_generic" select="$root-style_/root-style/@font-family-generic"/>

		<xsl:for-each select="$root-style_/root-style/@*">

			<xsl:choose>
				<xsl:when test="local-name() = 'font-family-generic'"><!-- skip, it's using for determine 'sans' or 'serif' --></xsl:when>
				<xsl:when test="local-name() = 'font-family'">

					<xsl:variable name="font_regional_prefix">
						<xsl:choose>
							<xsl:when test="$font_family_generic = 'Sans'">Noto Sans</xsl:when>
							<xsl:otherwise>Noto Serif</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:attribute name="{local-name()}">

						<xsl:variable name="font_extended">
							<xsl:choose>
								<xsl:when test="$lang = 'zh'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'hk'"><xsl:value-of select="$font_regional_prefix"/> HK</xsl:when>
								<xsl:when test="$lang = 'jp'"><xsl:value-of select="$font_regional_prefix"/> JP</xsl:when>
								<xsl:when test="$lang = 'kr'"><xsl:value-of select="$font_regional_prefix"/> KR</xsl:when>
								<xsl:when test="$lang = 'sc'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'tc'"><xsl:value-of select="$font_regional_prefix"/> TC</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($font_extended) != ''">
							<xsl:value-of select="$font_regional_prefix"/><xsl:text>, </xsl:text>
							<xsl:value-of select="$font_extended"/><xsl:text>, </xsl:text>
						</xsl:if>

						<xsl:variable name="font_family" select="."/>

						<xsl:choose>
							<xsl:when test="$additional_fonts = ''">
								<xsl:value-of select="$font_family"/>
							</xsl:when>
							<xsl:otherwise> <!-- $additional_fonts != '' -->
								<xsl:choose>
									<xsl:when test="contains($font_family, ',')">
										<xsl:value-of select="substring-before($font_family, ',')"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
										<xsl:text>, </xsl:text><xsl:value-of select="substring-after($font_family, ',')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$font_family"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- <xsl:choose>
				<xsl:when test="local-name() = 'font-family'">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>, <xsl:value-of select="$additional_fonts"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:for-each>
	</xsl:template> <!-- insertRootStyle -->

	<!-- Preface sections styles -->
	<xsl:attribute-set name="copyright-statement-style">

	</xsl:attribute-set> <!-- copyright-statement-style -->

	<xsl:attribute-set name="copyright-statement-title-style">

	</xsl:attribute-set> <!-- copyright-statement-title-style -->

	<xsl:attribute-set name="copyright-statement-p-style">

	</xsl:attribute-set> <!-- copyright-statement-p-style -->

	<xsl:attribute-set name="license-statement-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set> <!-- license-statement-title-style -->

	<xsl:attribute-set name="license-statement-p-style">

	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:attribute-set name="legal-statement-style">

	</xsl:attribute-set> <!-- legal-statement-style -->

	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set> <!-- legal-statement-title-style -->

	<xsl:attribute-set name="legal-statement-p-style">

	</xsl:attribute-set> <!-- legal-statement-p-style -->

	<xsl:attribute-set name="feedback-statement-style">

	</xsl:attribute-set> <!-- feedback-statement-style -->

	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set> <!-- feedback-statement-title-style -->

	<xsl:attribute-set name="feedback-statement-p-style">

	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<!-- End Preface sections styles -->

	<xsl:attribute-set name="link-style">

	</xsl:attribute-set>

	<xsl:template name="refine_link-style">

	</xsl:template> <!-- refine_link-style -->

	<xsl:attribute-set name="sourcecode-container-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>

			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_sourcecode-style">

	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

			<xsl:attribute name="margin-top">6pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="permission-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-name-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-label-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="termexample-style">

	</xsl:attribute-set>

	<xsl:template name="refine_termexample-style">

	</xsl:template>

	<xsl:attribute-set name="example-style">

	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">

	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">

	</xsl:attribute-set> <!-- example-body-style -->

	<xsl:attribute-set name="example-name-style">

			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">

	</xsl:template>

	<xsl:attribute-set name="example-p-style">

			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>

	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">

			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- refine_example-p-style -->

	<xsl:attribute-set name="termexample-name-style">

	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">

	</xsl:template>

	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">

	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>

	<xsl:variable name="table-cell-border_">

	</xsl:variable>
	<xsl:variable name="table-cell-border" select="normalize-space($table-cell-border_)"/>

	<xsl:attribute-set name="table-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>

			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-container-style -->

	<xsl:template name="refine_table-container-style">
		<xsl:param name="margin-side"/>

			<xsl:attribute name="margin-left"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>
			<xsl:attribute name="margin-right"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>

		<!-- end table block-container attributes -->
	</xsl:template> <!-- refine_table-container-style -->

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>

			<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>

	</xsl:attribute-set><!-- table-style -->

	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>

			<xsl:if test="$margin-side != 0">
				<xsl:attribute name="margin-left"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
				<xsl:attribute name="margin-right"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
			</xsl:if>

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-style -->

	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>

	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:template name="refine_table-name-style">
		<xsl:param name="continued"/>

	</xsl:template> <!-- refine_table-name-style -->

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_table-header-row-style">

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-header-row-style -->

	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-footer-row-style">

	</xsl:template> <!-- refine_table-footer-row-style -->

	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style">

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-body-row-style -->

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>

			<xsl:attribute name="display-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			<xsl:attribute name="border-top">solid black 0.2pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>

	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:template name="refine_table-header-cell-style">

		<xsl:call-template name="setBordersTableArray"/>

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setTableCellAttributes"/>

	</xsl:template> <!-- refine_table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>

			<xsl:attribute name="display-align">before</xsl:attribute>
			<xsl:attribute name="padding-left">0mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>

	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:template name="refine_table-cell-style">

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		 <!-- bsi -->

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>

	</xsl:attribute-set> <!-- table-footer-cell-style -->

	<xsl:template name="refine_table-footer-cell-style">

	</xsl:template> <!-- refine_table-footer-cell-style -->

	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set><!-- table-note-style -->

	<xsl:template name="refine_table-note-style">

	</xsl:template> <!-- refine_table-note-style -->

	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-fn-style -->

	<xsl:template name="refine_table-fn-style">

	</xsl:template>

	<xsl:attribute-set name="table-fn-number-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>

			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set> <!-- table-fn-number-style -->

	<xsl:template name="refine_table-fn-number-style">

	</xsl:template>

	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>

			<xsl:attribute name="margin-left">-8mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-fn-body-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>
	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->

	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->

	<xsl:attribute-set name="dl-block-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="dt-row-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="dt-cell-style">

	</xsl:attribute-set>

	<xsl:template name="refine_dt-cell-style">

	</xsl:template> <!-- refine_dt-cell-style -->

	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_dt-block-style">

	</xsl:template> <!-- refine_dt-block-style -->

	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

			<xsl:attribute name="font-weight">normal</xsl:attribute>

	</xsl:attribute-set> <!-- dl-name-style -->

	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_dd-cell-style">

	</xsl:template> <!-- refine_dd-cell-style -->

	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->

	<xsl:attribute-set name="appendix-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="appendix-example-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="xref-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="eref-style">

			<xsl:attribute name="color">blue</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>

	</xsl:template> <!-- refine_eref-style -->

	<xsl:attribute-set name="note-style">

			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_note-style">

	</xsl:template>

	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>

	<xsl:attribute-set name="note-name-style">

			<xsl:attribute name="padding-right">4mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_note-name-style">

	</xsl:template> <!-- refine_note-name-style -->

	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_table-note-name-style">

			<xsl:if test="@type = 'source' or @type = 'abbreviation'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- refine_table-note-name-style -->

	<xsl:attribute-set name="note-p-style">

			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">0</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-style">

			<xsl:attribute name="margin-top">4pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_termnote-style">

	</xsl:template> <!-- refine_termnote-style -->

	<xsl:attribute-set name="termnote-name-style">

	</xsl:attribute-set>

	<xsl:template name="refine_termnote-name-style">

	</xsl:template>

	<xsl:attribute-set name="termnote-p-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_quote-style">

	</xsl:template>

	<xsl:attribute-set name="quote-source-style">
		<xsl:attribute name="text-align">right</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termsource-style">

	</xsl:attribute-set>

	<xsl:template name="refine_termsource-style">

	</xsl:template> <!-- refine_termsource-style -->

	<xsl:attribute-set name="termsource-text-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="origin-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="term-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>

			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_figure-block-style">

	</xsl:template>

	<xsl:attribute-set name="figure-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>

			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_figure-name-style">

	</xsl:template> <!-- refine_figure-name-style -->

	<xsl:attribute-set name="figure-source-style">

	</xsl:attribute-set>

	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- formula-style -->

	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>

	</xsl:attribute-set> <!-- formula-stem-block-style -->

	<xsl:template name="refine_formula-stem-block-style">

			<xsl:if test="ancestor::*[local-name() ='annex']">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- refine_formula-stem-block-style -->

	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>

	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->

	<xsl:template name="refine_formula-stem-number-style">

	</xsl:template>

	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>

			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="border">2pt solid black</xsl:attribute>
			<xsl:attribute name="text-indent">0</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_image-style">

	</xsl:template>

	<xsl:attribute-set name="figure-pseudocode-p-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>

			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="tt-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="preferred-block-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="domain-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="admitted-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="deprecates-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">

	</xsl:attribute-set>

	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">

				<xsl:attribute name="color">red</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->

	</xsl:attribute-set>

	<xsl:variable name="add-style">
			<add-style xsl:use-attribute-sets="add-style"/>
		</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_mathml-style">

	</xsl:template>

	<xsl:attribute-set name="list-style">

			<xsl:attribute name="provisional-distance-between-starts">4mm</xsl:attribute>
			<xsl:attribute name="margin-left">-8mm</xsl:attribute>

	</xsl:attribute-set> <!-- list-style -->

	<xsl:template name="refine_list-style">

	</xsl:template> <!-- refine_list-style -->

	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="font-weight">normal</xsl:attribute>

	</xsl:attribute-set> <!-- list-name-style -->

	<xsl:attribute-set name="list-item-style">

	</xsl:attribute-set>

	<xsl:template name="refine_list-item-style">

	</xsl:template> <!-- refine_list-item-style -->

	<xsl:attribute-set name="list-item-label-style">

	</xsl:attribute-set>

	<xsl:template name="refine_list-item-label-style">

	</xsl:template> <!-- refine_list-item-label-style -->

	<xsl:attribute-set name="list-item-body-style">

	</xsl:attribute-set>

	<xsl:template name="refine_list-item-body-style">

	</xsl:template> <!-- refine_list-item-body-style -->

	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="line-height">135%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_fn-reference-style">

	</xsl:template> <!-- refine_fn-reference-style -->

	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>

			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>

			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
			<xsl:attribute name="margin-left">8mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_fn-body-style">

	</xsl:template> <!-- refine_fn-body-style -->

	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>

			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">8mm</xsl:attribute>

	</xsl:attribute-set> <!-- fn-body-num-style -->

	<xsl:template name="refine_fn-body-num-style">

	</xsl:template> <!-- refine_fn-body-num-style -->

	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">

			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-right">-3mm</xsl:attribute>
			<xsl:attribute name="padding-top">4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- admonition-style -->

	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>

			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="margin-right">2mm</xsl:attribute>

	</xsl:attribute-set> <!-- admonition-container-style -->

	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

	</xsl:attribute-set> <!-- admonition-name-style -->

	<xsl:attribute-set name="admonition-p-style">

			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">122%</xsl:attribute>

	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->

	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">

			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">14mm</xsl:attribute>
			<xsl:attribute name="text-indent">-14mm</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-normative-style -->

	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

		<!-- <xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">9.5mm</xsl:attribute>
		</xsl:if> -->

	</xsl:attribute-set> <!-- bibitem-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-style">

	</xsl:attribute-set> <!-- bibitem-non-normative-style -->

	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-list-item-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<!-- bibitem in bibliography section (references/@normative="false"), list body -->
	<xsl:attribute-set name="bibitem-normative-list-body-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="bibitem-non-normative-list-body-style">

	</xsl:attribute-set> <!-- bibitem-non-normative-list-body-style -->

	<!-- footnote reference number for bibitem, in the text  -->
	<xsl:attribute-set name="bibitem-note-fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>

			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-note-fn-style -->

	<!-- footnote number on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-number-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>

			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-note-fn-number-style -->

	<!-- footnote body (text) on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-body-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-note-fn-body-style -->

	<xsl:attribute-set name="references-non-normative-style">

	</xsl:attribute-set> <!-- references-non-normative-style -->

	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->

	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set>

	<!-- End Index section styles -->
	<!-- ====================================== -->
	<!-- END STYLES -->
	<!-- ====================================== -->

	<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
	<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>

	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>

	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition' or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition' or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault_Contents">

		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/*[local-name()='sections']/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |    /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<!-- <xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->

		<xsl:for-each select="/*/*[local-name()='annex'] | /*/*[local-name()='bibliography']/*[not(@normative='true') and not(*[local-name()='references'][@normative='true'])][count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0] |          /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]][count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<tables>
			<xsl:for-each select="//*[local-name() = 'table'][not(ancestor::*[local-name() = 'metanorma-extension'])][@id and *[local-name() = 'name'] and normalize-space(@id) != '']">
				<table id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</table>
			</xsl:for-each>
		</tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<figures>
			<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name'] and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(*[local-name() = 'name'], 'Figure ') and normalize-space(@id) != '']">
				<figure id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</figure>
			</xsl:for-each>
		</figures>
	</xsl:template>

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="copyCommonElements">
		<!-- copy bibdata, localized-strings, metanorma-extension and boilerplate -->
		<xsl:copy-of select="/*/*[local-name() != 'preface' and local-name() != 'sections' and local-name() != 'annex' and local-name() != 'bibliography' and local-name() != 'indexsect']"/>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>

		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |          /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template><!-- END: processMainSectionsDefault -->

	<!-- Example:
	<iso-standard>
		<preface>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</preface>
		<sections>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</sections>
		<page_sequence>
			<annex ..
		</page_sequence>
		<page_sequence>
			<annex ..
		</page_sequence>
	</iso-standard>
	-->
	<xsl:template name="processPrefaceAndMainSectionsDefault_items">

		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:call-template name="insertMainSectionsPageSequences"/>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsDefault_items -->

	<xsl:template name="insertPrefaceSectionsPageSequences">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertPrefaceSectionsPageSequences -->

	<xsl:template name="insertMainSectionsPageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>

				</xsl:for-each>
			</xsl:element>
		</xsl:element>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:for-each select="/*/*[local-name()='annex']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:for-each>
		</xsl:element>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
				<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |            /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertMainSectionsPageSequences -->

	<xsl:template name="insertMainSectionsInSeparatePageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>

		<xsl:call-template name="insertAnnexInSeparatePageSequences"/>

		<xsl:call-template name="insertBibliographyInSeparatePageSequences"/>

		<!-- <xsl:call-template name="insertIndexInSeparatePageSequences"/> -->
	</xsl:template> <!-- END: insertMainSectionsInSeparatePageSequences -->

	<xsl:template name="insertAnnexInSeparatePageSequences">
		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertBibliographyInSeparatePageSequences">
		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |           /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndexInSeparatePageSequences">
		<xsl:for-each select="/*/*[local-name()='indexsect']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processAllSectionsDefault_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertPrefaceSections"/>
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_and_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		<!-- <xsl:message>updated_xml_step_move_pagebreak_filename=<xsl:value-of select="$updated_xml_step_move_pagebreak_filename"/></xsl:message>
		<xsl:message>start write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:message>end write updated_xml_step_move_pagebreak_filename</xsl:message> -->

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<!-- <xsl:message>start delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
		<!-- <xsl:message>end delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
	</xsl:template> <!-- END: processAllSectionsDefault_items -->

	<xsl:template name="insertPrefaceSections">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSections">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->

			<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>

			</xsl:for-each>
		</xsl:element>

		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
		</xsl:for-each>

		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |           /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="deleteFile">
		<xsl:param name="filepath"/>
		<xsl:variable name="xml_file" select="java:java.io.File.new($filepath)"/>
		<xsl:variable name="xml_file_path" select="java:toPath($xml_file)"/>
		<xsl:variable name="deletefile" select="java:java.nio.file.Files.deleteIfExists($xml_file_path)"/>
	</xsl:template>

	<xsl:template name="getPageSequenceOrientation">
		<xsl:variable name="previous_orientation" select="preceding-sibling::*[local-name() = 'page_sequence'][@orientation][1]/@orientation"/>
		<xsl:choose>
			<xsl:when test="@orientation = 'landscape'">-<xsl:value-of select="@orientation"/></xsl:when>
			<xsl:when test="$previous_orientation = 'landscape' and not(@orientation = 'portrait')">-<xsl:value-of select="$previous_orientation"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">

				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),$regex_standard_reference,concat($tag_fo_inline_keep-together_within-line_open,'$1',$tag_fo_inline_keep-together_within-line_close))"/>
						<xsl:call-template name="replace_fo_inline_tags">
							<xsl:with-param name="tag_open" select="$tag_fo_inline_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_fo_inline_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

	</xsl:template>

	<xsl:template name="replace_fo_inline_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<!-- <xsl:text disable-output-escaping="yes">&lt;fo:inline keep-together.within-line="always"&gt;</xsl:text> -->
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				<xsl:choose>
					<xsl:when test="local-name(..) = 'keep-together_within-line'"> <!-- prevent two nested <fo:inline keep-together.within-line="always"><fo:inline keep-together.within-line="always" -->
						<xsl:value-of select="substring-before($text_after, $tag_close)"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline keep-together.within-line="always" role="SKIP">
							<xsl:value-of select="substring-before($text_after, $tag_close)"/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text> -->
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<!-- keep-together for standard's name (ISO 12345:2020) -->
	<xsl:template match="*[local-name() = 'keep-together_within-line']">
		<xsl:param name="split_keep-within-line"/>

		<!-- <fo:inline>split_keep-within-line='<xsl:value-of select="$split_keep-within-line"/>'</fo:inline> -->
		<xsl:choose>

			<xsl:when test="normalize-space($split_keep-within-line) = 'true'">
				<xsl:variable name="sep">_</xsl:variable>
				<xsl:variable name="items">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="$sep"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($items)/item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="*[local-name()='copyright-statement']">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- copyright-statement -->

	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template> <!-- copyright-statement//title -->

	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='p']">

				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>

	</xsl:template> <!-- copyright-statement//p -->

	<xsl:template match="*[local-name()='license-statement']">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='p']">

				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>

	</xsl:template> <!-- license-statement/p -->

	<xsl:template match="*[local-name()='legal-statement']">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- legal-statement -->

	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template> <!-- legal-statement/title -->

	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>

				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>

	</xsl:template> <!-- legal-statement/p -->

	<xsl:template match="*[local-name()='feedback-statement']">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- feedback-statement -->

	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template>

	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>

				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>

	</xsl:template>

	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'keep-together_within-line']">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="addZeroWidthSpacesToTextNodes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addZeroWidthSpacesToTextNodes">
		<xsl:variable name="text"><text><xsl:call-template name="text"/></text></xsl:variable>
		<!-- <xsl:copy-of select="$text"/> -->
		<xsl:for-each select="xalan:nodeset($text)/text/node()">
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:call-template name="add-zero-spaces-java"/></xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- for table auto-layout algorithm -->
	<xsl:param name="table_only_with_id"/> <!-- Example: 'table1' -->
	<xsl:param name="table_only_with_ids"/> <!-- Example: 'table1 table2 table3 ' -->

	<xsl:template match="*[local-name()='table']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='table']" name="table">

		<xsl:variable name="table-preamble">

		</xsl:variable>

		<xsl:variable name="table">

			<xsl:variable name="simple-table">
				<xsl:if test="$isGenerateTableIF = 'true' and $isApplyAutolayoutAlgorithm = 'true'">
					<xsl:call-template name="getSimpleTable">
						<xsl:with-param name="id" select="@id"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->

			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->

			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->

					<xsl:apply-templates select="*[local-name()='name']"/> <!-- table's title rendered before table -->

					<xsl:call-template name="table_name_fn_display"/>

			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>

			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col']) and not(@class = 'dl')">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="colwidths" select="xalan:nodeset($colwidths_)"/> -->

			<!-- DEBUG -->
			<xsl:if test="$table_if_debug = 'true'">
				<fo:block font-size="60%">
					<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
				</fo:block>
			</xsl:if>

			<!-- <xsl:copy-of select="$colwidths"/> -->

			<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
			DEBUG
			colwidths=<xsl:copy-of select="$colwidths"/>
		<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

			<xsl:variable name="margin-side">
				<xsl:choose>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">0</xsl:when>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'">0</xsl:when>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">

				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>

				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->

				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->

							<xsl:choose>
								<xsl:when test="@width = 'full-page-width' or @width = 'text-width'">100%</xsl:when>
								<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$table_width_default"/></xsl:otherwise>
							</xsl:choose>

				</xsl:variable>

				<xsl:variable name="table_attributes">

					<xsl:element name="table_attributes" use-attribute-sets="table-style">

						<xsl:if test="$margin-side != 0">
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-right">0mm</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></xsl:attribute>

						<xsl:call-template name="refine_table-style">
							<xsl:with-param name="margin-side" select="$margin-side"/>
						</xsl:call-template>

					</xsl:element>
				</xsl:variable>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<!-- to determine start of table -->
					<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
				</xsl:if>

				<fo:table id="{@id}">

					<xsl:if test="$isGenerateTableIF = 'true'">
						<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
					</xsl:if>

					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:attribute name="{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>

					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'][not(@type = 'units')] or ./*[local-name()='example'] or .//*[local-name()='fn'][local-name(..) != 'name'] or ./*[local-name()='source']"/>
					<xsl:if test="$isNoteOrFnExist = 'true'">

								<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute><!-- set 0pt border, because there is a separete table below for footer -->

					</xsl:if>

					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<!-- generate IF for table widths -->
							<!-- example:
								<tr>
									<td valign="top" align="left" id="tab-symdu_1_1">
										<p>Symbol</p>
										<word id="tab-symdu_1_1_word_1">Symbol</word>
									</td>
									<td valign="top" align="left" id="tab-symdu_1_2">
										<p>Description</p>
										<word id="tab-symdu_1_2_word_1">Description</word>
									</td>
								</tr>
							-->
							<!-- Simple_table=<xsl:copy-of select="$simple-table"/> -->
							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>

						</xsl:when>
						<xsl:otherwise>

							<xsl:choose>
								<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
									<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@class = 'dl'">
									<xsl:for-each select=".//*[local-name()='tr'][1]/*">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertTableColumnWidth">
										<xsl:with-param name="colwidths" select="$colwidths"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
									<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'note') and not(local-name() = 'example') and not(local-name() = 'dl') and not(local-name() = 'source') and not(local-name() = 'p')          and not(local-name() = 'thead') and not(local-name() = 'tfoot')]"/> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>

				</fo:table>

				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>

						<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
							<xsl:call-template name="insertTableFooterInSeparateTable">
								<xsl:with-param name="table_attributes" select="$table_attributes"/>
								<xsl:with-param name="colwidths" select="$colwidths"/>
								<xsl:with-param name="colgroup" select="$colgroup"/>
							</xsl:call-template>
						</xsl:for-each>

				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</xsl:variable>

		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">

				<!-- centered table when table name is centered (see table-name-style) -->

					<xsl:choose>
						<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
							<xsl:copy-of select="$table-preamble"/>
							<fo:block>
								<xsl:call-template name="setTrackChangesStyles">
									<xsl:with-param name="isAdded" select="$isAdded"/>
									<xsl:with-param name="isDeleted" select="$isDeleted"/>
								</xsl:call-template>
								<xsl:copy-of select="$table"/>
							</fo:block>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$table-preamble"/>
							<xsl:copy-of select="$table"/>
						</xsl:otherwise>
					</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="setBordersTableArray">

	</xsl:template>

	<xsl:template match="*[local-name()='table']/*[local-name() = 'name']">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">

					<fo:block xsl:use-attribute-sets="table-name-style" role="SKIP">

						<xsl:call-template name="refine_table-name-style">
							<xsl:with-param name="continued" select="$continued"/>
						</xsl:call-template>

						<xsl:choose>
							<xsl:when test="$continued = 'true'">

							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>

					</fo:block>

					<!-- <xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'"> -->
					<xsl:if test="$continued = 'true'">
						<fo:block text-align="right">
							<xsl:apply-templates select="../*[local-name() = 'note'][@type = 'units']/node()"/>
						</fo:block>
					</xsl:if>
					<!-- </xsl:if> -->

		</xsl:if>
	</xsl:template> <!-- table/name -->

	<!-- workaround solution for https://github.com/metanorma/metanorma-iso/issues/1151#issuecomment-2033087938 -->
	<xsl:template match="*[local-name()='table']/*[local-name() = 'note'][@type = 'units']/*[local-name() = 'p']/text()" priority="4">
		<xsl:choose>
			<xsl:when test="preceding-sibling::*[local-name() = 'br']">
				<!-- remove CR or LF at start -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'^(&#13;&#10;|&#13;|&#10;)', '')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/*[local-name() = 'source']" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:call-template name="get-calculated-column-widths-autolayout-algorithm"/>
			</xsl:when>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'"/>
			<xsl:otherwise>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================== -->
	<!-- Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	<xsl:template name="calculate-column-widths-proportional">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>

		<!-- table=<xsl:copy-of select="$table"/> -->

		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>

						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- <curr_col><xsl:value-of select="$curr-col"/></curr_col> -->

						<!-- <table><xsl:copy-of select="$table"/></table>
						 -->
						<xsl:for-each select="xalan:nodeset($table)/*/*[local-name()='tr']">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
							</xsl:variable>
							<!-- <td_text><xsl:value-of select="$td_text"/></td_text> -->
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:message>string_with_added_zerospaces=<xsl:value-of select="$string_with_added_zerospaces"/></xsl:message> -->
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
								</xsl:call-template>
							</xsl:variable>
							<!-- words=<xsl:copy-of select="$words"/> -->
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<!-- <xsl:message>max_length=<xsl:value-of select="$max_length"/></xsl:message> -->
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>

						</xsl:for-each>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- widths=<xsl:copy-of select="$widths"/> -->

			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths-proportional">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- calculate-column-widths-proportional -->

	<!-- ================================= -->
	<!-- mode="td_text" -->
	<!-- ================================= -->
	<!-- replace each each char to 'X', just to process the tag 'keep-together_within-line' as whole word in longest word calculation -->
	<xsl:template match="*[@keep-together.within-line or local-name() = 'keep-together_within-line']/text()" priority="2" mode="td_text">
		<!-- <xsl:message>DEBUG t1=<xsl:value-of select="."/></xsl:message>
		<xsl:message>DEBUG t2=<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/></xsl:message> -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/>

		<!-- if all capitals english letters or digits -->
		<xsl:if test="normalize-space(translate(., concat($upper,'0123456789'), '')) = ''">
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="'X'"/>
				<xsl:with-param name="count" select="string-length(normalize-space(.)) * 0.5"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="td_text">
		<xsl:value-of select="translate(., $zero_width_space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template>

	<xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	<xsl:template match="*[local-name()='math']" mode="td_text" name="math_length">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<xsl:variable name="mathml_">
				<xsl:for-each select="*">
					<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="mathml" select="xalan:nodeset($mathml_)"/>

			<xsl:variable name="math_text">
				<xsl:value-of select="normalize-space($mathml)"/>
				<xsl:for-each select="$mathml//@open"><xsl:value-of select="."/></xsl:for-each>
				<xsl:for-each select="$mathml//@close"><xsl:value-of select="."/></xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
		</xsl:if>
	</xsl:template>
	<!-- ================================= -->
	<!-- END mode="td_text" -->
	<!-- ================================= -->
	<!-- ================================================== -->
	<!-- END Calculate column's width based on text string max widths -->
	<!-- ================================================== -->

	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- (https://www.w3.org/TR/REC-html40/appendix/notes.html#h-B.5.2) -->
	<!-- ================================================== -->

	<!-- INPUT: table with columns widths, generated by table_if.xsl  -->
	<xsl:template name="calculate-column-widths-autolayout-algorithm">
		<xsl:param name="parent_table_page-width"/> <!-- for nested tables, in re-calculate step -->

		<!-- via intermediate format -->

		<!-- The algorithm uses two passes through the table data and scales linearly with the size of the table -->

		<!-- In the first pass, line wrapping is disabled, and the user agent keeps track of the minimum and maximum width of each cell. -->

		<!-- Since line wrap has been disabled, paragraphs are treated as long lines unless broken by BR elements. -->

		<xsl:variable name="page_width">
			<xsl:choose>
				<xsl:when test="$parent_table_page-width != ''">
					<xsl:value-of select="$parent_table_page-width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@page-width"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$table_if_debug = 'true'">
			<page_width><xsl:value-of select="$page_width"/></page_width>
		</xsl:if>

		<!-- There are three cases: -->
		<xsl:choose>
			<!-- 1. The minimum table width is equal to or wider than the available space -->
			<xsl:when test="@width_min &gt;= $page_width and 1 = 2"> <!-- this condition isn't working see case 3 below -->
				<!-- call old algorithm -->
				<case1/>
				<!-- <xsl:variable name="cols-count" select="count(xalan:nodeset($table)/*/tr[1]/td)"/>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template> -->
			</xsl:when>
			<!-- 2. The maximum table width fits within the available space. In this case, set the columns to their maximum widths. -->
			<xsl:when test="@width_max &lt;= $page_width">
				<case2/>
				<autolayout/>
				<xsl:for-each select="column/@width_max">
					<column divider="100"><xsl:value-of select="."/></column>
				</xsl:for-each>
			</xsl:when>
			<!-- 3. The maximum width of the table is greater than the available space, but the minimum table width is smaller. 
			In this case, find the difference between the available space and the minimum table width, lets call it W. 
			Lets also call D the difference between maximum and minimum width of the table. 
			For each column, let d be the difference between maximum and minimum width of that column. 
			Now set the column's width to the minimum width plus d times W over D. 
			This makes columns with large differences between minimum and maximum widths wider than columns with smaller differences. -->
			<xsl:when test="(@width_max &gt; $page_width and @width_min &lt; $page_width) or (@width_min &gt;= $page_width)">
				<!-- difference between the available space and the minimum table width -->
				<_width_min><xsl:value-of select="@width_min"/></_width_min>
				<xsl:variable name="W" select="$page_width - @width_min"/>
				<W><xsl:value-of select="$W"/></W>
				<!-- difference between maximum and minimum width of the table -->
				<xsl:variable name="D" select="@width_max - @width_min"/>
				<D><xsl:value-of select="$D"/></D>
				<case3/>
				<autolayout/>
				<xsl:if test="@width_min &gt;= $page_width">
					<split_keep-within-line>true</split_keep-within-line>
				</xsl:if>
				<xsl:for-each select="column">
					<!-- difference between maximum and minimum width of that column.  -->
					<xsl:variable name="d" select="@width_max - @width_min"/>
					<d><xsl:value-of select="$d"/></d>
					<width_min><xsl:value-of select="@width_min"/></width_min>
					<e><xsl:value-of select="$d * $W div $D"/></e>
					<!-- set the column's width to the minimum width plus d times W over D.  -->
					<xsl:variable name="column_width_" select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
					<xsl:variable name="column_width" select="$column_width_*($column_width_ &gt;= 0) - $column_width_*($column_width_ &lt; 0)"/> <!-- absolute value -->
					<column divider="100">
						<xsl:value-of select="$column_width"/>
					</column>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise><unknown_case/></xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- calculate-column-widths-autolayout-algorithm -->

	<xsl:template name="get-calculated-column-widths-autolayout-algorithm">

		<!-- if nested 'dl' or 'table' -->
		<xsl:variable name="parent_table_id" select="normalize-space(ancestor::*[local-name() = 'table' or local-name() = 'dl'][1]/@id)"/>
		<parent_table_id><xsl:value-of select="$parent_table_id"/></parent_table_id>

		<parent_element><xsl:value-of select="local-name(..)"/></parent_element>

		<ancestor_tree>
			<xsl:for-each select="ancestor::*">
				<ancestor><xsl:value-of select="local-name()"/></ancestor>
			</xsl:for-each>
		</ancestor_tree>

		<xsl:variable name="parent_table_page-width_">
			<xsl:if test="$parent_table_id != ''">
				<!-- determine column number in the parent table -->
				<xsl:variable name="parent_table_column_number">
					<xsl:choose>
						<!-- <xsl:when test="parent::*[local-name() = 'dd']">2</xsl:when> -->
						<xsl:when test="(ancestor::*[local-name() = 'dd' or local-name() = 'table' or local-name() = 'dl'])[last()][local-name() = 'dd' or local-name() = 'dl']">2</xsl:when>
						<xsl:otherwise> <!-- parent is table -->
							<xsl:value-of select="count(ancestor::*[local-name() = 'td'][1]/preceding-sibling::*[local-name() = 'td']) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- find table by id in the file 'table_widths' and get all Nth `<column>...</column> -->

				<xsl:variable name="parent_table_column_" select="$table_widths_from_if_calculated//table[@id = $parent_table_id]/column[number($parent_table_column_number)]"/>
				<xsl:variable name="parent_table_column" select="xalan:nodeset($parent_table_column_)"/>
				<!-- <xsl:variable name="divider">
					<xsl:value-of select="$parent_table_column/@divider"/>
					<xsl:if test="not($parent_table_column/@divider)">1</xsl:if>
				</xsl:variable> -->
				<xsl:value-of select="$parent_table_column/text()"/> <!--  * 10 -->
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="parent_table_page-width" select="normalize-space($parent_table_page-width_)"/>

		<parent_table_page-width><xsl:value-of select="$parent_table_page-width"/></parent_table_page-width>

		<!-- get current table id -->
		<xsl:variable name="table_id" select="@id"/>

		<xsl:choose>
			<xsl:when test="$parent_table_id = '' or $parent_table_page-width = ''">
				<!-- find table by id in the file 'table_widths' and get all `<column>...</column> -->
				<xsl:copy-of select="$table_widths_from_if_calculated//table[@id = $table_id]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- recalculate columns width based on parent table width -->
				<xsl:for-each select="$table_widths_from_if//table[@id = $table_id]">
					<xsl:call-template name="calculate-column-widths-autolayout-algorithm">
						<xsl:with-param name="parent_table_page-width" select="$parent_table_page-width"/> <!-- padding-left = 2mm  = 50000-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- get-calculated-column-widths-autolayout-algorithm -->

	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->

	<xsl:template match="*[local-name()='thead']">
		<xsl:param name="cols-count"/>
		<fo:table-header>

			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template> <!-- thead -->

	<!-- template is using for iec, iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row role="SKIP">
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black" role="SKIP">

				<xsl:call-template name="refine_table-header-title-style"/>

						<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']">
							<xsl:with-param name="continued">true</xsl:with-param>
						</xsl:apply-templates>

						<xsl:if test="not(ancestor::*[local-name()='table']/*[local-name()='name'])"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
							<fo:block role="SKIP"/>
						</xsl:if>

			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->

	<xsl:template name="refine_table-header-title-style">

	</xsl:template> <!-- refine_table-header-title-style -->

	<xsl:template match="*[local-name()='thead']" mode="process_tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tfoot']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>
				<xsl:apply-templates select="../*[local-name()='tfoot']"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>

		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'][not(@type = 'units')] or ../*[local-name()='example'] or ../*[local-name()='dl'] or ..//*[local-name()='fn'][local-name(..) != 'name'] or ../*[local-name()='source'] or ../*[local-name()='p']"/>

		<xsl:variable name="isNoteOrFnExistShowAfterTable">

		</xsl:variable>

		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">

			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display"/>
			</xsl:variable>

			<xsl:variable name="tableWithNotesAndFootnotes">

				<fo:table keep-with-previous="always">
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$name = 'border-top'">
								<xsl:attribute name="{$name}">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:when test="$name = 'border'">
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
								<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
							<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}">

								<xsl:call-template name="refine_table-footer-cell-style"/>

								<xsl:call-template name="setBordersTableArray"/>

								<!-- fn will be processed inside 'note' processing -->

								<!-- for BSI (not PAS) display Notes before footnotes -->

								<!-- except gb and bsi  -->

										<xsl:apply-templates select="../*[local-name()='p']"/>
										<xsl:apply-templates select="../*[local-name()='dl']"/>
										<xsl:apply-templates select="../*[local-name()='note'][not(@type = 'units')]"/>
										<xsl:apply-templates select="../*[local-name()='example']"/>
										<xsl:apply-templates select="../*[local-name()='source']"/>

								<xsl:variable name="isDisplayRowSeparator">

								</xsl:variable>

								<!-- horizontal row separator -->
								<xsl:if test="normalize-space($isDisplayRowSeparator) = 'true'">
									<xsl:if test="(../*[local-name()='note'][not(@type = 'units')] or ../*[local-name()='example']) and normalize-space($table_fn_block) != ''">
										<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">

											<xsl:call-template name="setBordersTableArray"/>
											<fo:block font-size="1pt"> </fo:block>
										</fo:block-container>
									</xsl:if>
								</xsl:if>

								<!-- fn processing -->

										<!-- <xsl:call-template name="table_fn_display" /> -->
										<xsl:copy-of select="$table_fn_block"/>

								<!-- for PAS display Notes after footnotes -->

							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>

				</fo:table>
			</xsl:variable>

			<xsl:if test="normalize-space($tableWithNotesAndFootnotes) != ''">
				<xsl:copy-of select="$tableWithNotesAndFootnotes"/>
			</xsl:if>

		</xsl:if>
	</xsl:template> <!-- insertTableFooterInSeparateTable -->

	<xsl:template match="*[local-name()='tbody']">

		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="../*[local-name()='thead']">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>

		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>

		<fo:table-body>

			<xsl:apply-templates/>

		</fo:table-body>

	</xsl:template> <!-- tbody -->

	<xsl:template match="/" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		<xsl:apply-templates mode="process_table-if">
			<xsl:with-param name="table_or_dl" select="$table_or_dl"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>

		<fo:table-body>
			<xsl:for-each select="*[local-name() = 'tr']">
				<xsl:variable name="col_count" select="count(*)"/>

				<!-- iteration for each tr/td -->

				<xsl:choose>
					<xsl:when test="$table_or_dl = 'table'">
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']/*">
							<fo:table-row number-columns-spanned="{$col_count}">
								<xsl:copy-of select="../@font-weight"/>
								<!-- <test_table><xsl:copy-of select="."/></test_table> -->
								<xsl:call-template name="td"/>
							</fo:table-row>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> <!-- $table_or_dl = 'dl' -->
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']">
							<xsl:variable name="is_dt" select="position() = 1"/>

							<xsl:for-each select="*">
								<!-- <test><xsl:copy-of select="."/></test> -->
								<fo:table-row number-columns-spanned="{$col_count}">
									<xsl:choose>
										<xsl:when test="$is_dt">
											<xsl:call-template name="insert_dt_cell"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insert_dd_cell"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:table-row>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</fo:table-body>
	</xsl:template> <!-- process_table-if -->

	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="*[local-name()='thead']/*[local-name()='tr']" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">

			<xsl:call-template name="refine_table-header-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::*[local-name() = 'table'][1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::*[local-name() = 'table'][1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="*[local-name() = 'table'][@id = $table_id]//*[local-name() = 'tr']"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="*[local-name()='tfoot']/*[local-name()='tr']" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">

			<xsl:call-template name="refine_table-footer-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<!-- row in table's body (tbody) -->
	<xsl:template match="*[local-name()='tr']">
		<fo:table-row xsl:use-attribute-sets="table-body-row-style">

			<xsl:if test="count(*) = count(*[local-name() = 'th'])"> <!-- row contains 'th' only -->
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_table-body-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setTableRowAttributes">

			<xsl:if test="not(*[local-name()='th'])">
				<xsl:attribute name="min-height">8mm</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- setTableRowAttributes -->
	<!-- ===================== -->
	<!-- END Table's row processing -->
	<!-- ===================== -->

	<!-- cell in table header row -->
	<xsl:template match="*[local-name()='th']">
		<fo:table-cell xsl:use-attribute-sets="table-header-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">center</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-header-cell-style"/>

			<!-- experimental feature, see https://github.com/metanorma/metanorma-plateau/issues/30#issuecomment-2145461828 -->
			<!-- <xsl:choose>
				<xsl:when test="count(node()) = 1 and *[local-name() = 'span'][contains(@style, 'text-orientation')]">
					<fo:block-container reference-orientation="270">
						<fo:block role="SKIP" text-align="start">
							<xsl:apply-templates />
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block role="SKIP">
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- cell in table header row - 'th' -->

	<xsl:template name="setTableCellAttributes">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:call-template name="display-align"/>
	</xsl:template>

	<xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-cell-style"/>

			<xsl:if test=".//*[local-name() = 'table']"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:apply-templates/>

				<xsl:if test="$isGenerateTableIF = 'true'"> <fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- td -->

	<xsl:template match="*[local-name()='table']/*[local-name()='note' or local-name() = 'example']" priority="2">

				<fo:block xsl:use-attribute-sets="table-note-style">
					<xsl:copy-of select="@id"/>

					<xsl:call-template name="refine_table-note-style"/>

					<!-- Table's note/example name (NOTE, for example) -->
					<fo:inline xsl:use-attribute-sets="table-note-name-style">

						<xsl:call-template name="refine_table-note-name-style"/>

						<xsl:apply-templates select="*[local-name() = 'name']"/>

					</fo:inline>

					<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
				</fo:block>

	</xsl:template> <!-- table/note -->

	<xsl:template match="*[local-name()='table']/*[local-name()='note' or local-name()='example']/*[local-name()='p']" priority="2">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body, table's, figure's names), not for tables, figures -->
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))]" priority="2" name="fn">

		<!-- list of footnotes to calculate actual footnotes number -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
			<!-- <xsl:choose>
				<xsl:when test="$namespace = 'jis'">
					<xsl:call-template name="get_fn_list_for_element"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_fn_list"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>

		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference_">
			<xsl:value-of select="@reference"/>
			<xsl:if test="normalize-space(@reference) = ''"><xsl:value-of select="$gen_id"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="reference" select="normalize-space($reference_)"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number">
			<xsl:choose>
				<xsl:when test="@current_fn_number"><xsl:value-of select="@current_fn_number"/></xsl:when> <!-- for BSI -->
				<xsl:otherwise>
					<xsl:value-of select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>

		</xsl:variable>

		<xsl:variable name="ref_id">
			<xsl:choose>
				<xsl:when test="normalize-space(@ref_id) != ''"><xsl:value-of select="@ref_id"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('footnote_', $lang, '_', $reference, '_', $current_fn_number)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">

				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'bibitem']">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style"/>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>

				<xsl:if test="following-sibling::node()[normalize-space() != ''][1][local-name() = 'fn']">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}" role="Lbl">
							<xsl:copy-of select="$current_fn_number_text"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false'">
				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">

						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">

							<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">

								<xsl:call-template name="refine_fn-body-style"/>

								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">

									<xsl:call-template name="refine_fn-body-num-style"/>

									<xsl:value-of select="$current_fn_number_text"/>
								</fo:inline>
								<xsl:apply-templates/>
							</fo:block>
						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->

	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'note'][@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='boilerplate']/* |       ancestor::*[contains(local-name(), '-standard')]//*[local-name()='preface']/* |      ancestor::*[contains(local-name(), '-standard')]//*[local-name()='sections']/* |       ancestor::*[contains(local-name(), '-standard')]//*[local-name()='annex'] |      ancestor::*[contains(local-name(), '-standard')]//*[local-name()='bibliography']/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//*[local-name() = 'bibitem'][ancestor::*[local-name() = 'references']]/*[local-name() = 'note'] |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="get_fn_list_for_element">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]">
					<xsl:variable name="element_id" select="@id"/>
					<xsl:for-each select=".//*[local-name() = 'fn'][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->
	<xsl:template name="table_fn_display">
		<xsl:variable name="references">

			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<xsl:call-template name="create_fn"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->

						<fo:block xsl:use-attribute-sets="table-fn-style">
							<xsl:call-template name="refine_table-fn-style"/>
							<fo:inline id="{@id}" xsl:use-attribute-sets="table-fn-number-style">
								<xsl:call-template name="refine_table-fn-number-style"/>

								<xsl:value-of select="@reference"/>

							</fo:inline>
							<fo:inline xsl:use-attribute-sets="table-fn-body-style">
								<xsl:copy-of select="./node()"/>
							</fo:inline>

						</fo:block>

			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="ancestor::*[local-name()='table'][1]/@id"> <!-- for footnotes in tables -->
				<xsl:attribute name="id">
					<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</fn>
	</xsl:template>

	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================ -->
	<!-- EMD table's footnotes rendering -->
	<!-- ============================ -->

	<!-- figure's footnotes rendering -->
	<xsl:template name="fn_display_figure">

		<!-- current figure id -->
		<xsl:variable name="figure_id_">
			<xsl:value-of select="@id"/>
			<xsl:if test="not(@id)"><xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="figure_id" select="normalize-space($figure_id_)"/>

		<!-- all footnotes relates to the current figure -->
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])][ancestor::*[local-name() = 'figure'][1][@id = $figure_id]]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="xalan:nodeset($references)//fn">

			<xsl:variable name="key_iso">

			</xsl:variable>

			<fo:block>

						<!-- current hierarchy is 'figure' element -->
						<xsl:variable name="following_dl_colwidths">
							<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
								<xsl:variable name="simple-table">
									<!-- <xsl:variable name="doc_ns">
										<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable> -->

									<xsl:for-each select="*[local-name() = 'dl'][1]">
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									</xsl:for-each>
								</xsl:variable>

								<xsl:call-template name="calculate-column-widths">
									<xsl:with-param name="cols-count" select="2"/>
									<xsl:with-param name="table" select="$simple-table"/>
								</xsl:call-template>

							</xsl:if>
						</xsl:variable>

						<xsl:variable name="maxlength_dt">
							<xsl:for-each select="*[local-name() = 'dl'][1]">
								<xsl:call-template name="getMaxLength_dt"/>
							</xsl:for-each>
						</xsl:variable>

						<fo:table width="95%" table-layout="fixed">
							<xsl:if test="normalize-space($key_iso) = 'true'">
								<xsl:attribute name="font-size">10pt</xsl:attribute>

							</xsl:if>
							<xsl:choose>
								<!-- if there 'dl', then set same columns width -->
								<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
									<xsl:call-template name="setColumnWidth_dl">
										<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>
										<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="5%"/>
									<fo:table-column column-width="95%"/>
								</xsl:otherwise>
							</xsl:choose>
							<fo:table-body>
								<xsl:for-each select="xalan:nodeset($references)//fn">
									<xsl:variable name="reference" select="@reference"/>
									<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
										<fo:table-row>
											<fo:table-cell>
												<fo:block>
													<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fn-number-style">
														<xsl:value-of select="@reference"/>
													</fo:inline>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block xsl:use-attribute-sets="figure-fn-body-style">
													<xsl:if test="normalize-space($key_iso) = 'true'">

																<xsl:attribute name="margin-bottom">0</xsl:attribute>

													</xsl:if>
													<xsl:copy-of select="./node()"/>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:if>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>

			</fo:block>
		</xsl:if>

	</xsl:template> <!-- fn_display_figure -->

	<!-- fn reference in the text rendering (for instance, 'some text 1) some text' ) -->
	<xsl:template match="*[local-name()='fn']">
		<fo:inline xsl:use-attribute-sets="fn-reference-style">

			<xsl:call-template name="refine_fn-reference-style"/>

			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				<xsl:if test="ancestor::*[local-name()='table'][1]/@id"> <!-- for footnotes in tables -->
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
					</xsl:attribute>
				</xsl:if>

				<xsl:value-of select="@reference"/>

			</fo:basic-link>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='fn']/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='fn']//*[local-name()='p']">
		<fo:inline role="P">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->

	<!-- for table auto-layout algorithm -->
	<xsl:template match="*[local-name()='dl']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="dl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='dl']" name="dl">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

					<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

			<xsl:if test="ancestor::*[local-name() = 'sourcecode']">
				<!-- set font-size as sourcecode font-size -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:call-template name="get_sourcecode_attributes"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@font-size">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block-container margin-left="0mm" role="SKIP">

						<xsl:attribute name="margin-right">0mm</xsl:attribute>

				<xsl:variable name="parent" select="local-name(..)"/>

				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>

				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(*[local-name()='dt']) = 1)"/>

				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->

								<fo:block margin-bottom="12pt" text-align="left">

									<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
									<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'p' and @keep-with-next = 'true']/node()"/>
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="*[local-name()='dt']/*"/>
									<xsl:if test="*[local-name()='dd']/node()[normalize-space() != ''][1][self::text()]">
										<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:apply-templates select="*[local-name()='dd']/node()" mode="inline"/>
								</fo:block>

					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">

							<xsl:call-template name="refine_dl_formula_where_style"/>

							<!-- <xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'bsi' or $namespace = 'itu'">:</xsl:if> -->
							<!-- preceding 'p' with word 'where' -->
							<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'p' and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">

							<xsl:call-template name="refine_figure_key_style"/>

							<xsl:variable name="title-key">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">key</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>

				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">

						<xsl:call-template name="refine_multicomponent_style"/>

						<xsl:if test="ancestor::*[local-name() = 'dd' or local-name() = 'td']">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>

						<fo:block role="SKIP">

							<xsl:call-template name="refine_multicomponent_block_style"/>

							<xsl:apply-templates select="*[local-name() = 'name']">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>

							<xsl:if test="$isGenerateTableIF = 'true'">
								<!-- to determine start of table -->
								<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
							</xsl:if>

							<fo:table width="95%" table-layout="fixed">

								<xsl:if test="$isGenerateTableIF = 'true'">
									<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
								</xsl:if>

								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'"/>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>

									</xsl:when>
								</xsl:choose>

								<xsl:choose>
									<xsl:when test="$isGenerateTableIF = 'true'">
										<!-- generate IF for table widths -->
										<!-- example:
											<tr>
												<td valign="top" align="left" id="tab-symdu_1_1">
													<p>Symbol</p>
													<word id="tab-symdu_1_1_word_1">Symbol</word>
												</td>
												<td valign="top" align="left" id="tab-symdu_1_2">
													<p>Description</p>
													<word id="tab-symdu_1_2_word_1">Description</word>
												</td>
											</tr>
										-->

										<!-- create virtual html table for dl/[dt and dd] -->
										<xsl:variable name="simple-table">
											<!-- initial='<xsl:copy-of select="."/>' -->
											<xsl:variable name="dl_table">
												<tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
											</xsl:variable>

											<!-- dl_table='<xsl:copy-of select="$dl_table"/>' -->

											<!-- Step: replace <br/> to <p>...</p> -->
											<xsl:variable name="table_without_br">
												<xsl:apply-templates select="xalan:nodeset($dl_table)" mode="table-without-br"/>
											</xsl:variable>

											<!-- table_without_br='<xsl:copy-of select="$table_without_br"/>' -->

											<!-- Step: add id to each cell -->
											<!-- add <word>...</word> for each word, image, math -->
											<xsl:variable name="simple-table-id">
												<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-id">
													<xsl:with-param name="id" select="@id"/>
												</xsl:apply-templates>
											</xsl:variable>

											<!-- simple-table-id='<xsl:copy-of select="$simple-table-id"/>' -->

											<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

										</xsl:variable>

										<!-- DEBUG: simple-table<xsl:copy-of select="$simple-table"/> -->

										<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if">
											<xsl:with-param name="table_or_dl">dl</xsl:with-param>
										</xsl:apply-templates>

									</xsl:when>
									<xsl:otherwise>

										<xsl:variable name="simple-table">

											<xsl:variable name="dl_table">
												<tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
											</xsl:variable>

											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>

										<xsl:variable name="colwidths">
											<xsl:choose>
												<!-- dl from table[@class='dl'] -->
												<xsl:when test="*[local-name() = 'colgroup']">
													<autolayout/>
													<xsl:for-each select="*[local-name() = 'colgroup']/*[local-name() = 'col']">
														<column><xsl:value-of select="translate(@width,'%m','')"/></column>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="calculate-column-widths">
														<xsl:with-param name="cols-count" select="2"/>
														<xsl:with-param name="table" select="$simple-table"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->

										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>
										</xsl:variable>

										<xsl:variable name="isContainsKeepTogetherTag_">
											false
										</xsl:variable>
										<xsl:variable name="isContainsKeepTogetherTag" select="normalize-space($isContainsKeepTogetherTag_)"/>
										<!-- isContainsExpressReference=<xsl:value-of select="$isContainsExpressReference"/> -->

										<xsl:call-template name="setColumnWidth_dl">
											<xsl:with-param name="colwidths" select="$colwidths"/>
											<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
											<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
										</xsl:call-template>

										<fo:table-body>

											<!-- DEBUG -->
											<xsl:if test="$table_if_debug = 'true'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2" font-size="60%">
														<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if>

											<xsl:apply-templates>
												<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
												<xsl:with-param name="split_keep-within-line" select="xalan:nodeset($colwidths)/split_keep-within-line"/>
											</xsl:apply-templates>

										</fo:table-body>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if> <!-- END: a few components -->
			</fo:block-container>
		</fo:block-container>

		<xsl:if test="$isGenerateTableIF = 'true'"> <!-- process nested 'dl' -->
			<xsl:apply-templates select="*[local-name() = 'dd']/*[local-name() = 'dl']"/>
		</xsl:if>

	</xsl:template> <!-- END: dl -->

	<xsl:template name="refine_dl_formula_where_style">

	</xsl:template> <!-- refine_dl_formula_where_style -->

	<xsl:template name="refine_figure_key_style">

	</xsl:template> <!-- refine_figure_key_style -->

	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>

	</xsl:template> <!-- refine_multicomponent_style -->

	<xsl:template name="refine_multicomponent_block_style">
		<xsl:variable name="parent" select="local-name(..)"/>

	</xsl:template> <!-- refine_multicomponent_block_style -->

	<!-- ignore 'p' with 'where' in formula, before 'dl' -->
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'p' and @keep-with-next = 'true' and following-sibling::*[1][local-name() = 'dl']]"/>

	<xsl:template match="*[local-name() = 'dl']/*[local-name() = 'name']">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>
		<xsl:param name="maxlength_dt"/>
		<xsl:param name="isContainsKeepTogetherTag"/>

		<!-- <colwidths><xsl:copy-of select="$colwidths"/></colwidths> -->

		<xsl:choose>
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colwidths)/autolayout">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$isContainsKeepTogetherTag">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>

		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- <fo:table-column column-width="proportional-column-width({.})"/> -->
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<fo:table-column column-width="proportional-column-width({round(. div $divider)})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="*[local-name()='dt']">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template>

	<!-- note in definition list: dl/note -->
	<!-- renders in the 2-column spanned table row -->
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<!-- OLD Variant -->
		<!-- <fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row> -->
		<!-- <tr>
			<td number-columns-spanned="2">NOTE <xsl:apply-templates /> </td>
		</tr> 
		-->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="2">
				<fo:block role="SKIP">
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->

	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="*[local-name()='dt']" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::*[local-name()='dt']) + 1"/>
		<tr>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</td>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_2')"/>
				</xsl:attribute>

						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]">
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>

			</td>
		</tr>

	</xsl:template>

	<!-- Definition's term -->
	<xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>

		<fo:table-row xsl:use-attribute-sets="dt-row-style">

			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::*[local-name()='dd'][1]">
				<xsl:call-template name="insert_dd_cell">
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:call-template>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template> <!-- END: dt -->

	<xsl:template name="insert_dt_cell">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dt-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>

			</xsl:if>

			<xsl:call-template name="refine_dt-cell-style"/>

			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">
				<xsl:copy-of select="@id"/>

				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="refine_dt-block-style"/>

				<xsl:apply-templates>
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:apply-templates>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dt_cell -->

	<xsl:template name="insert_dd_cell">
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dd-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dd-cell-style"/>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::*[local-name()='dd'][1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::*[local-name()='dd'][1] -->
							<xsl:with-param name="process">true</xsl:with-param>
							<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
						</xsl:apply-templates>
					</xsl:otherwise>

				</xsl:choose>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dd_cell -->

	<!-- END Definition's term -->

	<xsl:template match="*[local-name()='dd']" mode="dl"/>
	<xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name()='dd']">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='dd']/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="(local-name() = 'p') and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$is_inline_element_after_where = 'true'">
				<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="*[local-name()='dt']" mode="dl_if">
		<xsl:param name="id"/>
		<tr>
			<td>
				<xsl:copy-of select="node()"/>
			</td>
			<td>
				<!-- <xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'dl']" mode="dl_if_nested"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if"/>

	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p']" mode="dl_if">
		<xsl:param name="indent"/>
		<p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</p>

	</xsl:template>

	<xsl:template match="*[local-name() = 'ul' or local-name() = 'ol']" mode="dl_if">
		<xsl:variable name="list_rendered_">
			<xsl:apply-templates select="."/>
		</xsl:variable>
		<xsl:variable name="list_rendered" select="xalan:nodeset($list_rendered_)"/>

		<xsl:variable name="indent">
			<xsl:for-each select="($list_rendered//fo:block[not(.//fo:block)])[1]">
				<xsl:apply-templates select="ancestor::*[@provisional-distance-between-starts]/@provisional-distance-between-starts" mode="dl_if"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name() = 'li']" mode="dl_if">
		<xsl:param name="indent"/>
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@provisional-distance-between-starts" mode="dl_if">
		<xsl:variable name="value" select="round(substring-before(.,'mm'))"/>
		<!-- emulate left indent for list item -->
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'x'"/>
			<xsl:with-param name="count" select="$value"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[local-name()='dl']" mode="dl_if_nested">
		<xsl:for-each select="*[local-name() = 'dt']">
			<p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'p']/node()"/>
			</p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if_nested"/>
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->

	<!-- default: ignore title in sections/p -->
	<xsl:template match="*[local-name() = 'sections']/*[local-name() = 'p'][starts-with(@class, 'zzSTDTitle')]" priority="3"/>

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->
	<xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:call-template name="refine_italic_style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_italic_style">

	</xsl:template>

	<xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline font-weight="bold">

			<xsl:call-template name="refine_strong_style"/>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_strong_style">

		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">

			<xsl:variable name="_font-size">

				 <!-- inherit -->

			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::*[local-name()='note'] or ancestor::*[local-name()='example']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template> <!-- tt -->

	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="*[local-name()='tt']/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="*[local-name()='add'] | *[local-name() = 'change-open-tag'] | *[local-name() = 'change-close-tag']" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or local-name() = 'change-open-tag' or local-name() = 'change-close-tag'"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and       ((local-name(../..) = 'note' and not(preceding-sibling::node())) or       (local-name(..) = 'title' and preceding-sibling::node()[1][local-name() = 'tab']) or      local-name(..) = 'formattedref' and not(preceding-sibling::node()))      and       ../node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag'">start</xsl:when>
										<xsl:when test="local-name() = 'change-close-tag'">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag' or local-name() = 'change-close-tag'">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag' or local-name() = 'change-close-tag'">
											<xsl:value-of select="*[local-name() = 'sub']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add -->

	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->

	<!-- highlight text -->
	<xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<!-- <xsl:variable name="text" select="normalize-space(.)"/> --> <!-- https://github.com/metanorma/metanorma-iso/issues/1115 -->
		<xsl:variable name="text" select="."/>
		<xsl:variable name="ratio_">
			0.75
		</xsl:variable>
		<xsl:variable name="ratio" select="number(normalize-space($ratio_))"/>
		<fo:inline font-size="{$ratio * 100}%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ratio" select="$ratio"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</fo:inline>
	</xsl:template>

	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:param name="ratio">0.75</xsl:param>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div $ratio}%" role="SKIP">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
        <xsl:with-param name="ratio" select="$ratio"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

	<xsl:template match="*[local-name() = 'pagebreak']">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="*[local-name() = 'span'][@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or $key = 'font-size' or $key = 'color'">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
				<xsl:if test="$key = 'text-indent'">
					<style name="padding-left"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>

					</xsl:for-each>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="*[local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:apply-templates/></xsl:when>
			<xsl:when test="following-sibling::*[2][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always"><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::*[local-name() = 'table']) and preceding-sibling::*[1][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and   following-sibling::*[1][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'span'][contains(@style, 'text-transform:none')]//text()" priority="5">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->

	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="$isGenerateTableIF = 'true' and not(contains($text, $separator))">
				<word><xsl:value-of select="normalize-space($text)"/></word>
			</xsl:when>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:choose>
						<xsl:when test="normalize-space(translate($text, 'X', '')) = ''"> <!-- special case for keep-together.within-line -->
							<xsl:value-of select="$len_str_tmp"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
							<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
							<xsl:variable name="len_str">
								<xsl:choose>
									<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
										<xsl:value-of select="$len_str_tmp * 1.5"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$len_str_tmp"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
								<xsl:message>
									div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
									len_str=<xsl:value-of select="$len_str"/>
									len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
								</xsl:message>
							</xsl:if> -->
							<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
							<len_str><xsl:value-of select="$len_str"/></len_str> -->
							<xsl:choose>
								<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
									<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$len_str"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:variable name="word" select="normalize-space(substring-before($text, $separator))"/>
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<xsl:value-of select="$word"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($word)"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- split string 'text' by 'separator', enclosing in formatting tags -->
	<xsl:template name="tokenize_with_tags">
		<xsl:param name="tags"/>
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:if test="ancestor::*[local-name() = 'p'][@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:if test="ancestor::*[local-name() = 'p'][@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space(substring-before($text, $separator))"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
				<xsl:call-template name="tokenize_with_tags">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="tags" select="$tags"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="enclose_text_in_tags">
		<xsl:param name="text"/>
		<xsl:param name="tags"/>
		<xsl:param name="num">1</xsl:param> <!-- default (start) value -->

		<xsl:variable name="tag_name" select="normalize-space(xalan:nodeset($tags)//tag[$num])"/>

		<xsl:choose>
			<xsl:when test="$tag_name = ''"><xsl:value-of select="$text"/></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag_name}">
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="tags" select="$tags"/>
						<xsl:with-param name="num" select="$num + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>

		<!-- add zero-width space (#x200B) after dot with next non-digit -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(\.)([^\d\s])','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, equal, underscore, em dash, thin space, arrow right, ;   -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1),'(-|=|_|—| |→|;)','$1​')"/>
		<!-- add zero-width space (#x200B) after characters: colon, if there aren't digits after -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2),'(:)(\D)','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(\u003e)(?!\u003e)', '$1​')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(?&lt;!\u003c)(\u003c)', '​$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text6" select="java:replaceAll(java:java.lang.String.new($text5), '(?&lt;!\W)(\{)', '​$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text7" select="java:replaceAll(java:java.lang.String.new($text6), '(\,)(?!\d)', '$1​')"/> <!-- negative lookahead: ',' not followed by digit -->
		<!-- add zero-width space (#x200B) after character: '/' -->
		<xsl:variable name="text8" select="java:replaceAll(java:java.lang.String.new($text7), '(\u002f)(?!\u002f)', '$1​')"/><!-- negative lookahead: '/' not followed by '/' -->

		<xsl:variable name="text9">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text8), '([\u3000-\u9FFF])', '$1​')"/> <!-- 3000 - CJK Symbols and Punctuation ... 9FFF CJK Unified Ideographs-->
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$text8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="text10" select="java:replaceAll(java:java.lang.String.new($text9), '\u200b{2,}', '​')"/>

		<!-- replace sequence #x200B and space TO space -->
		<xsl:variable name="text11" select="java:replaceAll(java:java.lang.String.new($text10), '\u200b ', ' ')"/>

		<xsl:value-of select="$text11"/>
	</xsl:template>

	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>

		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, comma, slash, @  -->
		<xsl:variable name="url" select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/|@)','$1​')"/>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="url2" select="java:replaceAll(java:java.lang.String.new($url), '\u200b{2,}', '​')"/>

		<!-- remove zero-width space at the end -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url2), '​$', '')"/>
	</xsl:template>

	<!-- add zero space after dash character (for table's entries) -->
	<xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>

		<!-- <test0>
			<xsl:copy-of select="."/>
		</test0> -->

		<xsl:variable name="simple-table">

			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<xsl:apply-templates mode="table-without-br"/>
			</xsl:variable>

			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>

			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>

			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>

	<!-- ================================== -->
	<!-- Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->
	<xsl:template match="@*|node()" mode="table-without-br">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="table-without-br"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(*[local-name()='br']) and not(*[local-name()='p']) and not(*[local-name()='sourcecode']) and not(*[local-name()='ul']) and not(*[local-name()='ol'])]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<p>
				<xsl:copy-of select="node()"/>
			</p>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td'][*[local-name()='br']]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="*[local-name()='br']">
				<xsl:variable name="current_id" select="generate-id()"/>
				<p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
				<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
					<p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p'][*[local-name()='br']]" mode="table-without-br">
		<xsl:for-each select="*[local-name()='br']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</p>
			<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
				<p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']/text()[contains(., '&#13;') or contains(., '&#10;')]" mode="table-without-br">

		<xsl:variable name="sep">###SOURCECODE_NEWLINE###</xsl:variable>
		<xsl:variable name="sourcecode_text" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', $sep)"/>
		<xsl:variable name="items">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$sourcecode_text"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($items)/*">
			<p>
				<sourcecode><xsl:copy-of select="node()"/></sourcecode>
			</p>
		</xsl:for-each>
	</xsl:template>

	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::*[local-name() = 'sourcecode'])]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#9;&#10;&#13;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'ol' or local-name() = 'ul']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'li']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<!-- mode="table-without-br" -->
	<!-- ================================== -->
	<!-- END: Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->

	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="{local-name()}">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:if test="local-name()='th'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name()}">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:if test="local-name()='th'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@colspan" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>

	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>

		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>

		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//*[self::td or self::th]">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/*[self::td or self::th][1 + count(current()/preceding-sibling::*[self::td or self::th][not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<!-- optimize to prevent StackOverflowError, just copy next 'tr' -->
		<xsl:variable name="currrow_num" select="count(preceding-sibling::tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan_" select="count(following-sibling::tr[*[@rowspan and @rowspan != 1]][1]/preceding-sibling::tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan" select="$nextrow_without_rowspan_ - $currrow_num"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($newRow)/*/*[@rowspan and @rowspan != 1]) and $nextrow_without_rowspan &lt;= 0">
				<xsl:copy-of select="following-sibling::tr"/>
			</xsl:when>
			<!-- <xsl:when test="xalan:nodeset($newRow)/*[not(@rowspan) or (@rowspan = 1)] and $nextrow_without_rowspan &gt; 0">
				<xsl:copy-of select="following-sibling::tr[position() &lt;= $nextrow_without_rowspan]"/>
				
				<xsl:copy-of select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				<xsl:apply-templates select="following-sibling::tr[$nextrow_without_rowspan + 2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				</xsl:apply-templates>
			</xsl:when> -->
			<xsl:otherwise>
				<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="$newRow"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->

	<!-- Step 3: add id for each cell -->
	<!-- mode: simple-table-id -->
	<xsl:template match="/" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:variable name="id_prefixed" select="concat('table_if_',$id)"/> <!-- table id prefixed by 'table_if_' to simple search in IF  -->
		<xsl:apply-templates select="@*|node()" mode="simple-table-id">
			<xsl:with-param name="id" select="$id_prefixed"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*|node()" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:apply-templates select="node()" mode="simple-table-id">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="font_main_root_style">
		<root-style xsl:use-attribute-sets="root-style">
		</root-style>
	</xsl:variable>
	<xsl:variable name="font_main_root_style_font_family" select="xalan:nodeset($font_main_root_style)/root-style/@font-family"/>
	<xsl:variable name="font_main">
		<xsl:choose>
			<xsl:when test="contains($font_main_root_style_font_family, ',')"><xsl:value-of select="substring-before($font_main_root_style_font_family, ',')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$font_main_root_style_font_family"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="*[local-name()='th' or local-name()='td']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="row_number" select="count(../preceding-sibling::*) + 1"/>
			<xsl:variable name="col_number" select="count(preceding-sibling::*) + 1"/>
			<xsl:variable name="divide">
				<xsl:choose>
					<xsl:when test="@divide"><xsl:value-of select="@divide"/></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>

			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
					</xsl:attribute>

					<!-- <xsl:copy-of select="node()" /> -->
					<xsl:apply-templates mode="simple-table-noid"/>

				</xsl:copy>
			</xsl:for-each>

			<xsl:if test="$isGenerateTableIF = 'true'"> <!-- split each paragraph to words, image, math -->

				<xsl:variable name="td_text">
					<xsl:apply-templates select="." mode="td_text_with_formatting"/>
				</xsl:variable>

				<!-- td_text='<xsl:copy-of select="$td_text"/>' -->

				<xsl:variable name="words_with_width">
					<!-- calculate width for 'word' which contain text only (without formatting tags inside) -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][not(*)]">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="width">
								<xsl:value-of select="java:org.metanorma.fop.Util.getStringWidth(., $font_main)"/> <!-- Example: 'Times New Roman' -->
							</xsl:attribute>
							<xsl:copy-of select="node()"/>
						</xsl:copy>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="words_with_width_sorted">
					<xsl:for-each select="xalan:nodeset($words_with_width)//*[local-name() = 'word']">
						<xsl:sort select="@width" data-type="number" order="descending"/>
						<!-- select word maximal width only -->
						<xsl:if test="position() = 1">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
					<!-- add 'word' with formatting tags inside -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][*]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>

					<xsl:for-each select="xalan:nodeset($words_with_width_sorted)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<!-- <xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each> -->

				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
						</xsl:attribute>
						<xsl:copy-of select="node()"/>
					</xsl:copy>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>

	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p']//*" mode="simple-table-noid">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@*[local-name() != 'id']"/> <!-- to prevent repeat id in colspan/rowspan cells -->
					<!-- <xsl:if test="local-name() = 'dl' or local-name() = 'table'">
						<xsl:copy-of select="@id"/>
					</xsl:if> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()" mode="simple-table-noid"/>
		</xsl:copy>
	</xsl:template>

	<!-- End mode: simple-table-id -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- =============================== -->
	<!-- mode="td_text_with_formatting" -->
	<!-- =============================== -->
	<xsl:template match="@*|node()" mode="td_text_with_formatting">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="td_text_with_formatting"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

	<xsl:template match="*[local-name() = 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		<word>
			<xsl:call-template name="enclose_text_in_tags">
				<xsl:with-param name="text" select="normalize-space(.)"/>
				<xsl:with-param name="tags" select="$formatting_tags"/>
			</xsl:call-template>
		</word>
	</xsl:template>

	<xsl:template match="*[local-name() != 'keep-together_within-line']/text()" mode="td_text_with_formatting">

		<xsl:variable name="td_text" select="."/>

		<xsl:variable name="string_with_added_zerospaces">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$td_text"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>

		<!-- <word>text</word> -->
		<xsl:call-template name="tokenize_with_tags">
			<xsl:with-param name="tags" select="$formatting_tags"/>
			<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[local-name() = 'link'][normalize-space() = '']" mode="td_text_with_formatting">
		<xsl:variable name="link">
			<link_updated>
				<xsl:variable name="target_text">
					<xsl:choose>
						<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
							<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$target_text"/>
			</link_updated>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($link)/*">
			<xsl:apply-templates mode="td_text_with_formatting"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::*[local-name() = 'strong']"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'em']"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sub']"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sup']"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tt']"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sourcecode']"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="language_current_3" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'])"/>
							<xsl:choose>
								<xsl:when test="$language_current_3 != ''">
									<xsl:value-of select="$language_current_3"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLang_fromCurrentNode">
		<xsl:variable name="language_current" select="normalize-space(.//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//*[local-name()='bibdata']//*[local-name()='language']"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>
	</xsl:template>

	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<fo:inline xsl:use-attribute-sets="mathml-style">

			<!-- DEBUG -->
			<!-- <xsl:copy-of select="ancestor::*[local-name() = 'stem']/@font-family"/> -->

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:if test="$isGenerateTableIF = 'true' and ancestor::*[local-name() = 'td' or local-name() = 'th' or local-name() = 'dl'] and not(following-sibling::node()[not(self::comment())][normalize-space() != ''])"> <!-- math in table cell, and math is last element -->
				<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<xsl:if test="$add_math_as_text = 'true'">
				<!-- insert helper tag -->
				<!-- set unique font-size (fiction) -->
				<xsl:variable name="font-size_sfx"><xsl:number level="any"/></xsl:variable>
				<fo:inline color="white" font-size="1.{$font-size_sfx}pt" font-style="normal" font-weight="normal"><xsl:value-of select="$zero_width_space"/></fo:inline> <!-- zero width space -->
			</xsl:if>

			<xsl:variable name="mathml_content">
				<xsl:apply-templates select="." mode="mathml_actual_text"/>
			</xsl:variable>

					<xsl:call-template name="mathml_instream_object">
						<xsl:with-param name="mathml_content" select="$mathml_content"/>
					</xsl:call-template>

		</fo:inline>
	</xsl:template>

	<xsl:template name="getMathml_comment_text">
		<xsl:variable name="comment_text_following" select="following-sibling::node()[1][self::comment()]"/>
		<xsl:variable name="comment_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($comment_text_following) != ''">
					<xsl:value-of select="$comment_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment_text_2" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
		<xsl:variable name="comment_text" select="java:trim(java:java.lang.String.new($comment_text_2))"/>
		<xsl:value-of select="$comment_text"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'asciimath']">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'latexmath']"/>

	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../*[local-name() = 'asciimath']"/>
		<xsl:variable name="latexmath">

		</xsl:variable>
		<xsl:variable name="asciimath_text_following">
			<xsl:choose>
				<xsl:when test="normalize-space($latexmath) != ''">
					<xsl:value-of select="$latexmath"/>
				</xsl:when>
				<xsl:when test="normalize-space($asciimath) != ''">
					<xsl:value-of select="$asciimath"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="following-sibling::node()[1][self::comment()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text_following) != ''">
					<xsl:value-of select="$asciimath_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_2" select="java:org.metanorma.fop.Util.unescape($asciimath_text_)"/>
		<xsl:variable name="asciimath_text" select="java:trim(java:java.lang.String.new($asciimath_text_2))"/>
		<xsl:value-of select="$asciimath_text"/>
	</xsl:template>

	<xsl:template name="mathml_instream_object">
		<xsl:param name="asciimath_text"/>
		<xsl:param name="mathml_content"/>

		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text) != ''"><xsl:value-of select="$asciimath_text"/></xsl:when>
				<!-- <xsl:otherwise><xsl:call-template name="getMathml_comment_text"/></xsl:otherwise> -->
				<xsl:otherwise><xsl:call-template name="getMathml_asciimath_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mathml">
			<xsl:apply-templates select="." mode="mathml"/>
		</xsl:variable>

		<fo:instream-foreign-object fox:alt-text="Math">

			<xsl:call-template name="refine_mathml_insteam_object_style"/>

			<!-- put MathML in Actual Text -->
			<!-- DEBUG: mathml_content=<xsl:value-of select="$mathml_content"/> -->
			<xsl:attribute name="fox:actual-text">
				<xsl:value-of select="$mathml_content"/>
			</xsl:attribute>

			<!-- <xsl:if test="$add_math_as_text = 'true'"> -->
			<xsl:if test="normalize-space($asciimath_text_) != ''">
			<!-- put Mathin Alternate Text -->
				<xsl:attribute name="fox:alt-text">
					<xsl:value-of select="$asciimath_text_"/>
				</xsl:attribute>
			</xsl:if>
			<!-- </xsl:if> -->

			<xsl:copy-of select="xalan:nodeset($mathml)"/>

		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="refine_mathml_insteam_object_style">

	</xsl:template> <!-- refine_mathml_insteam_object_style -->

	<xsl:template match="mathml:*" mode="mathml_actual_text">
		<!-- <xsl:text>a+b</xsl:text> -->
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:if test="local-name() = 'math'">
			<xsl:text> xmlns="http://www.w3.org/1998/Math/MathML"</xsl:text>
		</xsl:if>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="mathml_actual_text"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="mathml_actual_text">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template>

	<!-- <xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = '&#xa0;'])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			if in msub, then don't add space
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"></xsl:when>
			if next char in digit,  don't add space
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"></xsl:when>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/>

	<!-- patch: slash in the mtd wrong rendering -->
	<xsl:template match="mathml:mtd/mathml:mo/text()[. = '/']" mode="mathml">
		<xsl:value-of select="."/><xsl:value-of select="$zero_width_space"/>
	</xsl:template>

	<!-- special case for:
		<math xmlns="http://www.w3.org/1998/Math/MathML">
			<mstyle displaystyle="true">
				<msup>
					<mi color="#00000000">C</mi>
					<mtext>R</mtext>
				</msup>
				<msubsup>
					<mtext>C</mtext>
					<mi>n</mi>
					<mi>k</mi>
				</msubsup>
			</mstyle>
		</math>
	-->
	<xsl:template match="mathml:msup/mathml:mi[. = '‌' or . = ''][not(preceding-sibling::*)][following-sibling::mathml:mtext]" mode="mathml">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="next_mtext" select="ancestor::mathml:msup/following-sibling::*[1][self::mathml:msubsup or self::mathml:msub or self::mathml:msup]/mathml:mtext"/>
			<xsl:if test="string-length($next_mtext) != ''">
				<xsl:attribute name="color">#00000000</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:value-of select="$next_mtext"/>
		</xsl:copy>
	</xsl:template>

	<!-- special case for:
				<msup>
					<mtext/>
					<mn>1</mn>
				</msup>
		convert to (add mspace after mtext and enclose them into mrow):
			<msup>
				<mrow>
					<mtext/>
					<mspace height="1.47ex"/>
				</mrow>
				<mn>1</mn>
			</msup>
	-->
	<xsl:template match="mathml:msup/mathml:mtext[not(preceding-sibling::*)]" mode="mathml">
		<mathml:mrow>
			<xsl:copy-of select="."/>
			<mathml:mspace height="1.47ex"/>
		</mathml:mrow>
	</xsl:template>

	<!-- add space around vertical line -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '|']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace) and not(following-sibling::*[1][self::mathml:mo and normalize-space(text()) = '|'])">
				<xsl:attribute name="rspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- decrease fontsize for 'Circled Times' char -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '⊗']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@fontsize)">
				<xsl:attribute name="fontsize">55%</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- increase space before '(' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '(']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="(preceding-sibling::* and not(preceding-sibling::*[1][self::mathml:mo])) or (../preceding-sibling::* and not(../preceding-sibling::*[1][self::mathml:mo]))">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0.4em</xsl:attribute>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
						<xsl:when test="../preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="*[local-name() = 'stem'][@type = 'AsciiMath'][count(*) = 0]/text() | *[local-name() = 'stem'][@type = 'AsciiMath'][*[local-name() = 'asciimath']]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:choose>
				<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates>
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>

		</fo:inline>
	</xsl:template>
	<!-- ======================================= -->
	<!-- END: math -->
	<!-- ======================================= -->

	<xsl:template match="*[local-name()='localityStack']"/>

	<xsl:variable name="pdfAttachmentsList_">
		<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'attachment']">
			<attachment filename="{@name}"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="pdfAttachmentsList" select="xalan:nodeset($pdfAttachmentsList_)"/>

	<xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target_normalized" select="translate(@target, '\', '/')"/>
		<xsl:variable name="target_attachment_name" select="substring-after($target_normalized, '_attachments/')"/>
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<!-- link to the PDF attachment -->
				<xsl:when test="starts-with($target_normalized, '_') and contains($target_normalized, '_attachments/') and $pdfAttachmentsList//attachment[@filename = $target_attachment_name]">
					<xsl:value-of select="concat('url(embedded-file:', $target_attachment_name, ')')"/>
				</xsl:when>
				<xsl:when test="contains(@target, concat('_', $inputxml_filename_prefix, '_attachments'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="target__" select="substring-after($target_, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
					<xsl:value-of select="concat('url(embedded-file:', $target__, ')')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">

			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_link-style"/>

			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link external-destination="{$target}" fox:alt-text="{$target}">
								<xsl:choose>
									<xsl:when test="normalize-space(.) = ''">
										<xsl:call-template name="add-zero-spaces-link-java">
											<xsl:with-param name="text" select="$target_text"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- output text from <link>text</link> -->
										<xsl:apply-templates/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='title')]"/>
	</xsl:template>

	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->

	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='name')]"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'callout']">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates/>&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}" white-space="nowrap">

			<fo:inline>
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'xref']">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
					<xsl:if test="string-length(normalize-space()) &lt; 30 and not(contains(normalize-space(), 'http://')) and not(contains(normalize-space(), 'https://')) and not(ancestor::*[local-name() = 'table' or local-name() = 'dl'])">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::*[local-name() = 'add']">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- command between two xref points to non-standard bibitem -->
	<xsl:template match="text()[. = ','][preceding-sibling::node()[1][local-name() = 'sup'][*[local-name() = 'xref'][@type = 'footnote']] and    following-sibling::node()[1][local-name() = 'sup'][*[local-name() = 'xref'][@type = 'footnote']]]">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm" role="SKIP">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(local-name() = 'name')]"/> <!-- formula's number will be process in 'stem' template -->
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"> <!-- show in 'stem' template -->
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][*[local-name() = 'name']]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">

			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style" role="SKIP">

								<xsl:call-template name="refine_formula-stem-block-style"/>

								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-number-style" role="SKIP">

								<xsl:call-template name="refine_formula-stem-number-style"/>

								<xsl:apply-templates select="../*[local-name() = 'name']"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][not(*[local-name() = 'name'])]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or     (local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'note']" name="note">

		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_note-style"/>

			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">

						<fo:block>

							<xsl:call-template name="refine_note_block_style"/>

							<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">

								<xsl:call-template name="refine_note-name-style"/>

								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>

								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(local-name() = 'name')]) = 1 and *[not(local-name() = 'name')]/node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(local-name() = 'name')]/node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>

								<xsl:apply-templates select="*[local-name() = 'name']"/>

							</fo:inline>

							<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
						</fo:block>

			</fo:block-container>
		</fo:block-container>

	</xsl:template>

	<xsl:template name="refine_note_block_style">

			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-indent">0</xsl:attribute>
			<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
			<xsl:if test="../@type = 'source' or ../@type = 'abbreviation'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="text-align">justify</xsl:attribute>
				<xsl:attribute name="padding-top">0mm</xsl:attribute>
			</xsl:if>

	</xsl:template>

	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_termnote-style"/>

			<fo:inline xsl:use-attribute-sets="termnote-name-style">

				<xsl:if test="not(*[local-name() = 'name']/following-sibling::node()[1][self::text()][normalize-space()=''])">
					<xsl:attribute name="padding-right">1mm</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="refine_termnote-name-style"/>

				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>

				<xsl:apply-templates select="*[local-name() = 'name']"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>

						<xsl:text>:</xsl:text>

				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>

						<xsl:text> – </xsl:text>

				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- first paragraph renders in the same line as titlenote name -->
				<fo:inline xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- term      -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'terms']">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'term'])">

			</xsl:if>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<xsl:call-template name="refine_figure-block-style"/>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<!-- Example: Dimensions in millimeters -->
			<xsl:apply-templates select="*[local-name() = 'note'][@type = 'units']"/>

			<fo:block xsl:use-attribute-sets="figure-style" role="SKIP">
				<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'note' and @type = 'units')]"/>
			</fo:block>
			<xsl:for-each select="*[local-name() = 'note'][not(@type = 'units')]">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:call-template name="fn_display_figure"/>

					<xsl:apply-templates select="*[local-name() = 'name']"/> <!-- show figure's name AFTER image -->

		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'source']" priority="2">

				<xsl:call-template name="termsource"/>

	</xsl:template>

	<xsl:template match="*[local-name() = 'image']">
		<xsl:param name="indent">0</xsl:param>
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title'] or not(parent::*[local-name() = 'figure']) or parent::*[local-name() = 'p']"> <!-- inline image ( 'image:path' in adoc, with one colon after image) -->
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:if test="not(parent::*[local-name() = 'figure']) or parent::*[local-name() = 'p']">
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:call-template name="getImageScale">
							<xsl:with-param name="indent" select="$indent"/>
						</xsl:call-template>
					</xsl:variable>

					<!-- debug scale='<xsl:value-of select="$scale"/>', indent='<xsl:value-of select="$indent"/>' -->

					<!-- <fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/> -->
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle">

						<xsl:variable name="width">
							<xsl:call-template name="setImageWidth"/>
						</xsl:variable>
						<xsl:if test="$width != ''">
							<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="height">
							<xsl:call-template name="setImageHeight"/>
						</xsl:variable>
						<xsl:if test="$height != ''">
							<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
						</xsl:if>

						<xsl:if test="$width = '' and $height = ''">
							<xsl:if test="number($scale) &lt; 100">
								<xsl:attribute name="content-width"><xsl:value-of select="number($scale)"/>%</xsl:attribute>
								<!-- <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute> -->
							</xsl:if>
						</xsl:if>

					</fo:external-graphic>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">

					<xsl:call-template name="refine_image-style"/>

					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>

								<xsl:apply-templates select="." mode="cross_image"/>

							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<!-- <fo:block>debug block image:
							<xsl:variable name="scale">
								<xsl:call-template name="getImageScale">
									<xsl:with-param name="indent" select="$indent"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="concat('scale=', $scale,', indent=', $indent)"/>
							</fo:block> -->

							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}">

								<xsl:choose>
									<!-- default -->
									<xsl:when test="((@width = 'auto' or @width = 'text-width' or @width = 'full-page-width' or @width = 'narrow') and @height = 'auto') or            (normalize-space(@width) = '' and normalize-space(@height) = '') ">
										<!-- add attribute for automatic scaling -->
										<xsl:variable name="image-graphic-style_attributes">
											<attributes xsl:use-attribute-sets="image-graphic-style"/>
										</xsl:variable>
										<xsl:copy-of select="xalan:nodeset($image-graphic-style_attributes)/attributes/@*"/>

										<xsl:if test="not(@mimetype = 'image/svg+xml') and not(ancestor::*[local-name() = 'table'])">
											<xsl:variable name="scale">
												<xsl:call-template name="getImageScale">
													<xsl:with-param name="indent" select="$indent"/>
												</xsl:call-template>
											</xsl:variable>

											<xsl:variable name="scaleRatio">
												0.985
											</xsl:variable>

											<xsl:if test="number($scale) &lt; 100">
												<xsl:attribute name="content-width"><xsl:value-of select="number($scale) * number($scaleRatio)"/>%</xsl:attribute>
											</xsl:if>
										</xsl:if>

									</xsl:when> <!-- default -->
									<xsl:otherwise>

										<xsl:variable name="width_height_">
											<attributes>
												<xsl:call-template name="setImageWidthHeight"/>
											</attributes>
										</xsl:variable>
										<xsl:variable name="width_height" select="xalan:nodeset($width_height_)"/>

										<xsl:copy-of select="$width_height/attributes/@*"/>

										<xsl:if test="$width_height/attributes/@content-width != '' and             $width_height/attributes/@content-height != ''">
											<xsl:attribute name="scaling">non-uniform</xsl:attribute>
										</xsl:if>

									</xsl:otherwise>
								</xsl:choose>

								<!-- 
								<xsl:if test="not(@mimetype = 'image/svg+xml') and (../*[local-name() = 'name'] or parent::*[local-name() = 'figure'][@unnumbered = 'true']) and not(ancestor::*[local-name() = 'table'])">
								-->

							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setImageWidth">
		<xsl:if test="@width != '' and @width != 'auto' and @width != 'text-width' and @width != 'full-page-width' and @width != 'narrow'">
			<xsl:value-of select="@width"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageHeight">
		<xsl:if test="@height != '' and @height != 'auto'">
			<xsl:value-of select="@height"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageWidthHeight">
		<xsl:variable name="width">
			<xsl:call-template name="setImageWidth"/>
		</xsl:variable>
		<xsl:if test="$width != ''">
			<xsl:attribute name="content-width">
				<xsl:value-of select="$width"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:variable name="height">
			<xsl:call-template name="setImageHeight"/>
		</xsl:variable>
		<xsl:if test="$height != ''">
			<xsl:attribute name="content-height">
				<xsl:value-of select="$height"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getImageScale">
		<xsl:param name="indent"/>
		<xsl:variable name="indent_left">
			<xsl:choose>
				<xsl:when test="$indent != ''"><xsl:value-of select="$indent"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="img_src">
			<xsl:choose>
				<xsl:when test="not(starts-with(@src, 'data:'))"><xsl:value-of select="concat($basepath, @src)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="image_width_effective">

					<xsl:value-of select="$width_effective - number($indent_left)"/>

		</xsl:variable>
		<!-- <xsl:message>width_effective=<xsl:value-of select="$width_effective"/></xsl:message>
		<xsl:message>indent_left=<xsl:value-of select="$indent_left"/></xsl:message>
		<xsl:message>image_width_effective=<xsl:value-of select="$image_width_effective"/> for <xsl:value-of select="ancestor::ogc:p[1]/@id"/></xsl:message> -->
		<xsl:variable name="scale" select="java:org.metanorma.fop.Util.getImageScale($img_src, $image_width_effective, $height_effective)"/>
		<xsl:value-of select="$scale"/>
	</xsl:template>

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<!-- in WebP format, then convert image into PNG -->
			<xsl:when test="starts-with(@src, 'data:image/webp')">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="$src_png"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:')) and        (java:endsWith(java:java.lang.String.new(@src), '.webp') or       java:endsWith(java:java.lang.String.new(@src), '.WEBP'))">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="concat('url(file:///',$basepath, $src_png, ')')"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:value-of select="concat('url(file:///',$basepath, @src, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'image']" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src">
					<xsl:value-of select="concat('url(file:///',$basepath, @src, ')')"/>
				</xsl:variable>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template>

	<!-- =================== -->
	<!-- SVG images processing -->
	<!-- =================== -->
	<xsl:variable name="figure_name_height">14</xsl:variable>
	<xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><!-- paper width minus margins -->
	<xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><!-- paper height minus margins and title height -->
	<xsl:variable name="image_dpi" select="96"/>
	<xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/>
	<xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/>

	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image']) and *[local-name() = 'svg']]/*[local-name() = 'name']/*[local-name() = 'bookmark']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image'])]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>

		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>

		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../*[local-name() = 'name']) != ''">
					<xsl:value-of select="../*[local-name() = 'name']"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isPrecedingTitle" select="normalize-space(ancestor::*[local-name() = 'figure']/preceding-sibling::*[1][local-name() = 'title'] and 1 = 1)"/>

		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>

					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>

					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>

											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>

			</xsl:when>
			<xsl:otherwise>

				<xsl:variable name="image_class" select="ancestor::*[local-name() = 'image']/@class"/>
				<xsl:variable name="ancestor_table_cell" select="normalize-space(ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])"/>

				<xsl:variable name="element">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'tr'] and $isGenerateTableIF = 'true'">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:when test="not(ancestor::*[local-name() = 'figure'])">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:block xsl:use-attribute-sets="image-style">
								<xsl:if test="ancestor::*[local-name() = 'dt']">
									<xsl:attribute name="text-align">left</xsl:attribute>
								</xsl:if>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($element)/*">
					<xsl:copy>
						<xsl:copy-of select="@*"/>
					<!-- <fo:block xsl:use-attribute-sets="image-style"> -->
						<fo:instream-foreign-object fox:alt-text="{$alt-text}">

							<xsl:choose>
								<xsl:when test="$image_class = 'corrigenda-tag'">
									<xsl:attribute name="fox:alt-text">CorrigendaTag</xsl:attribute>
									<xsl:attribute name="baseline-shift">-10%</xsl:attribute>
									<xsl:if test="$ancestor_table_cell = 'true'">
										<xsl:attribute name="baseline-shift">-25%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="height">3.5mm</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$isGenerateTableIF = 'false'">
										<xsl:attribute name="width">100%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:variable name="svg_width_" select="xalan:nodeset($svg_content)/*/@width"/>
							<xsl:variable name="svg_width" select="number(translate($svg_width_, 'px', ''))"/>
							<xsl:variable name="svg_height_" select="xalan:nodeset($svg_content)/*/@height"/>
							<xsl:variable name="svg_height" select="number(translate($svg_height_, 'px', ''))"/>

							<!-- Example: -->
							<!-- effective height 297 - 27.4 - 13 =  256.6 -->
							<!-- effective width 210 - 12.5 - 25 = 172.5 -->
							<!-- effective height / width = 1.48, 1.4 - with title -->

							<xsl:variable name="scale_x">
								<xsl:choose>
									<xsl:when test="$svg_width &gt; $width_effective_px">
										<xsl:value-of select="$width_effective_px div $svg_width"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="scale_y">
								<xsl:choose>
									<xsl:when test="$svg_height * $scale_x &gt; $height_effective_px">
										<xsl:variable name="height_effective_px_">
											<xsl:choose>
												<!-- title is 'keep-with-next' with following figure -->
												<xsl:when test="$isPrecedingTitle = 'true'"><xsl:value-of select="$height_effective_px - 80"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$height_effective_px"/></xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:value-of select="$height_effective_px_ div ($svg_height * $scale_x)"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							 <!-- for images with big height -->
							<!-- <xsl:if test="$svg_height &gt; ($svg_width * 1.4)">
								<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
								<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
							</xsl:if> -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>

							<xsl:if test="$scale_y != 1">
								<xsl:attribute name="content-height"><xsl:value-of select="round($scale_x * $scale_y * 100)"/>%</xsl:attribute>
							</xsl:if>

							<xsl:copy-of select="$svg_content"/>
						</fo:instream-foreign-object>
					<!-- </fo:block> -->
					</xsl:copy>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============== -->
	<!-- svg_update     -->
	<!-- ============== -->
	<xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'image']/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:variable name="regex_starts_with_digit">^[0-9].*</xsl:variable>

	<xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="viewbox" select="xalan:nodeset($viewbox_)"/>
			<xsl:variable name="width" select="normalize-space($viewbox//item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//item[4])"/>

			<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[1][local-name() = 'image']/@width)"/>
			<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[1][local-name() = 'image']/@height)"/>

			<xsl:attribute name="width">
				<xsl:choose>
					<!-- width is non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<!-- height non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@width" mode="svg_update">
		<!-- image[@width]/svg -->
		<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[2][local-name() = 'image']/@width)"/>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@height" mode="svg_update">
		<!-- image[@height]/svg -->
		<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[2][local-name() = 'image']/@height)"/>
		<xsl:attribute name="height">
			<xsl:choose>
				<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- regex for 'display: inline-block;' -->
	<xsl:variable name="regex_svg_style_notsupported">display(\s|\h)*:(\s|\h)*inline-block(\s|\h)*;</xsl:variable>
	<xsl:template match="*[local-name() = 'svg']//*[local-name() = 'style']/text()" mode="svg_update">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), $regex_svg_style_notsupported, '')"/>
	</xsl:template>

	<!-- replace
			stroke="rgba(r, g, b, alpha)" to 
			stroke="rgb(r,g,b)" stroke-opacity="alpha", and
			fill="rgba(r, g, b, alpha)" to 
			fill="rgb(r,g,b)" fill-opacity="alpha" -->
	<xsl:template match="@*[local-name() = 'stroke' or local-name() = 'fill'][starts-with(normalize-space(.), 'rgba')]" mode="svg_update">
		<xsl:variable name="components_">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-before(substring-after(., '('), ')')"/>
				<xsl:with-param name="sep" select="','"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="components" select="xalan:nodeset($components_)"/>
		<xsl:variable name="att_name" select="local-name()"/>
		<xsl:attribute name="{$att_name}"><xsl:value-of select="concat('rgb(', $components/item[1], ',', $components/item[2], ',', $components/item[3], ')')"/></xsl:attribute>
		<xsl:attribute name="{$att_name}-opacity"><xsl:value-of select="$components/item[4]"/></xsl:attribute>
	</xsl:template>

	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->

	<!-- image with svg and emf -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- For the structures like: <dt><image src="" mimetype="image/svg+xml" height="" width=""><svg xmlns="http://www.w3.org/2000/svg" ... -->
	<xsl:template match="*[local-name() != 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<xsl:call-template name="insert_basic_link">
				<xsl:with-param name="element">
					<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
						<fo:inline-container inline-progression-dimension="100%">
							<fo:block-container height="{$height - 1}px" width="100%">
								<!-- DEBUG <xsl:if test="local-name()='polygon'">
									<xsl:attribute name="background-color">magenta</xsl:attribute>
								</xsl:if> -->
							<fo:block> </fo:block></fo:block-container>
						</fo:inline-container>
					</fo:basic-link>
				</xsl:with-param>
			</xsl:call-template>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->

	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="*[local-name() = 'emf']"/>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name'] |               *[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'sourcecode']/*[local-name() = 'name']//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'add'][starts-with(., $ace_tag)]/text()" mode="bookmarks" priority="3"/>

	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[local-name() = 'preface' or local-name() = 'sections']/*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>

	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="*[local-name() = 'clause']/*[local-name() = 'p'][@type = 'section-title' and (@depth != ../*[local-name() = 'title']/@depth or ../*[local-name() = 'title']/@depth = 1)]" priority="3" mode="contents"/>

	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"/>
				<xsl:otherwise>
					<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="*[local-name() = 'tab']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::*[local-name() = 'preface']">preface</xsl:if>
				<xsl:if test="ancestor-or-self::*[local-name() = 'annex']">annex</xsl:if>
			</xsl:variable>

			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
			</item>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/>

	<xsl:template match="*[local-name() = 'references']/*[local-name() = 'bibitem']" mode="contents"/>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/doc) &gt; 1">

								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>

								<xsl:for-each select="$contents_nodes/doc">
									<fo:bookmark internal-destination="{contents/item[@display = 'true'][1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>

										<xsl:apply-templates select="contents/item" mode="bookmark"/>

										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>

										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>

									</fo:bookmark>

								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/doc">

									<xsl:apply-templates select="contents/item" mode="bookmark"/>

									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>

									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>

								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/contents/item" mode="bookmark"/>

						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
						</xsl:call-template>

						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>

			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/figure">
			<fo:bookmark internal-destination="{$contents_nodes/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>

				<xsl:if test="$contents_nodes//figures/figure">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

						<xsl:variable name="bookmark-title">

									<xsl:value-of select="$title-list-figures"/>

						</xsl:variable>
						<fo:bookmark-title><xsl:value-of select="normalize-space($bookmark-title)"/></fo:bookmark-title>
						<xsl:for-each select="$contents_nodes//figures/figure">
							<fo:bookmark internal-destination="{@id}">
								<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>

	</xsl:template> <!-- insertFigureBookmarks -->

	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/table">
			<fo:bookmark internal-destination="{$contents_nodes/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>

				<xsl:if test="$contents_nodes//tables/table">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

						<xsl:variable name="bookmark-title">

									<xsl:value-of select="$title-list-tables"/>

						</xsl:variable>

						<fo:bookmark-title><xsl:value-of select="$bookmark-title"/></fo:bookmark-title>

						<xsl:for-each select="$contents_nodes//tables/table">
							<fo:bookmark internal-destination="{@id}">
								<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>

	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->

	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">

				</xsl:when>
			<xsl:when test="$lang = 'fr'">

			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="title" mode="bookmark"/>
	<xsl:template match="text()" mode="bookmark"/>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="figure-name-style">

				<xsl:call-template name="refine_figure-name-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note'][@type = 'units'] |         *[local-name() = 'image']/*[local-name() = 'note'][@type = 'units']" priority="2">
		<fo:block text-align="right" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
								<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>

	<xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'fn']" mode="contents"/>
	<xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/>

	<xsl:template match="*[local-name() = 'fn']" mode="contents_item"/>

	<xsl:template match="*[local-name() = 'xref'] | *[local-name() = 'eref']" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'review']" mode="contents_item"/>

	<xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:copy>
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="element" select="$element"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'sub']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'sup']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name() = 'add']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<text><xsl:call-template name="add-zero-spaces-java"/></text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name() = 'add'][starts-with(., $ace_tag)]/text()" mode="contents_item" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->

	<xsl:variable name="source-highlighter-css_" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'source-highlighter-css']"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>

	<xsl:template match="*[local-name() = 'property']" mode="css">
		<xsl:attribute name="{@name}">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size">

				<!-- inherit -->

				<!-- <xsl:if test="$namespace = 'ieee'">							
					<xsl:if test="$current_template = 'standard'">8</xsl:if>
				</xsl:if> -->

				10		
			</xsl:variable>

			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*[local-name()='sourcecode']" name="sourcecode">

		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>

    <!-- <xsl:copy-of select="$sourcecode_css"/> -->

		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
			</xsl:when>

			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">

					<xsl:if test="not(ancestor::*[local-name() = 'li']) or ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>

					<xsl:copy-of select="@id"/>

					<xsl:if test="parent::*[local-name() = 'note']">
						<xsl:attribute name="margin-left">
							<xsl:choose>
								<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

					</xsl:if>
					<fo:block-container margin-left="0mm" role="SKIP">

						<fo:block xsl:use-attribute-sets="sourcecode-style">

							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>

							<xsl:call-template name="refine_sourcecode-style"/>

							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::*[local-name() = 'sourcecode'][@linenums = 'true'] and ancestor::*[local-name() = 'tr'][1]/following-sibling::*[local-name() = 'tr']">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>

							<xsl:apply-templates select="node()[not(local-name() = 'name' or local-name() = 'dl')]"/>
						</fo:block>

						<xsl:apply-templates select="*[local-name() = 'dl']"/> <!-- Key table -->

								<xsl:apply-templates select="*[local-name()='name']"/> <!-- show sourcecode's name AFTER content -->

					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='sourcecode']/text() | *[local-name()='sourcecode']//*[local-name()='span']/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- add sourcecode highlighting -->
	<xsl:template match="*[local-name()='sourcecode']//*[local-name()='span'][@class]" priority="2">
		<xsl:variable name="class" select="@class"/>

		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::*[local-name() = 'dt']">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::*[local-name() = 'sourcecode']//*[local-name() = 'callout'][@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates/>
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates/>
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']/*[local-name() = 'tbody']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']/*[local-name()='td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>

				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/*[local-name() = 'sourcecode']">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- second td with sourcecode -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']/*[local-name()='td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->

	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- <xsl:value-of select="$text_step2"/> -->

		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' ​')"/>

		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template> <!-- add_spaces_to_sourcecode -->

	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->

	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- insert 'char' between each character in the string -->
	<xsl:template name="interspers">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:if test="$str != ''">
			<xsl:value-of select="substring($str, 1, 1)"/>

			<xsl:variable name="next_char" select="substring($str, 2, 1)"/>
			<xsl:if test="not(contains(concat(' -.:=_— ', $char), $next_char))">
				<xsl:value-of select="$char"/>
			</xsl:if>

			<xsl:call-template name="interspers">
				<xsl:with-param name="str" select="substring($str, 2)"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>

	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>

	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"/>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"/>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"/>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"/>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"/>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"/>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"/>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"/>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"/>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"/>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"/>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"/>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"/>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"/>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"/>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"/>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"/>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"/>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"/>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"/>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"/>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"/>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"/>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"/>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"/>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"/>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"/>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"/>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"/>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"/>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"/>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"/>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"/>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"/>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"/>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"/>
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"/>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"/>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"/>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"/>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"/>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"/>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"/>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"/>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"/>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"/>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>

	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>

			<xsl:for-each select="$classes/item">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>

			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->

		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>

	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>

	<!-- end mode="syntax_highlight" -->

	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->
	<xsl:template match="*[local-name()='pre']" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:copy-of select="@id"/>
			<xsl:choose>

				<xsl:when test="ancestor::*[local-name() = 'sourcecode'][@linenums = 'true'] and ancestor::*[local-name()='td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::*[local-name() = 'tr'][1]/following-sibling::*[local-name() = 'tr']"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>

			</xsl:choose>
		</fo:block>
	</xsl:template>
	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->

	<!-- ========== -->
	<!-- permission -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement -->
<!-- ========== -->
	<xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="*[local-name()='label']"/>
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="*[local-name()='subject']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'label') and not(local-name() = 'subject')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">

				<xsl:apply-templates/>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- ========== -->

	<xsl:template match="*[local-name() = 'subject']">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'div']">
		<fo:block><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'inherit'] | *[local-name() = 'component'][@class = 'inherit'] |           *[local-name() = 'div'][@type = 'requirement-inherit'] |           *[local-name() = 'div'][@type = 'recommendation-inherit'] |           *[local-name() = 'div'][@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'description'] | *[local-name() = 'component'][@class = 'description'] |           *[local-name() = 'div'][@type = 'requirement-description'] |           *[local-name() = 'div'][@type = 'recommendation-description'] |           *[local-name() = 'div'][@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'specification'] | *[local-name() = 'component'][@class = 'specification'] |           *[local-name() = 'div'][@type = 'requirement-specification'] |           *[local-name() = 'div'][@type = 'recommendation-specification'] |           *[local-name() = 'div'][@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'measurement-target'] | *[local-name() = 'component'][@class = 'measurement-target'] |           *[local-name() = 'div'][@type = 'requirement-measurement-target'] |           *[local-name() = 'div'][@type = 'recommendation-measurement-target'] |           *[local-name() = 'div'][@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'verification'] | *[local-name() = 'component'][@class = 'verification'] |           *[local-name() = 'div'][@type = 'requirement-verification'] |           *[local-name() = 'div'][@type = 'recommendation-verification'] |           *[local-name() = 'div'][@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'import'] | *[local-name() = 'component'][@class = 'import'] |           *[local-name() = 'div'][@type = 'requirement-import'] |           *[local-name() = 'div'][@type = 'recommendation-import'] |           *[local-name() = 'div'][@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'div'][starts-with(@type, 'requirement-component')] |           *[local-name() = 'div'][starts-with(@type, 'recommendation-component')] |           *[local-name() = 'div'][starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='thead']" mode="requirement">
		<fo:table-header>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="requirement">
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">

			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>

			</xsl:if>

			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->

	<!-- ====== -->
	<!-- termexample -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:call-template name="refine_termexample-style"/>
			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:call-template name="refine_termexample-name-style"/>
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<xsl:variable name="element">inline


		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">

					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- example -->
	<!-- ====== -->

	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="*[local-name() = 'example']">

		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_example-style"/>

			<xsl:variable name="fo_element">
				<xsl:if test=".//*[local-name() = 'table'] or .//*[local-name() = 'dl'] or *[not(local-name() = 'name')][1][local-name() = 'sourcecode']">block</xsl:if>
				block
			</xsl:variable>

			<fo:block-container margin-left="0mm" role="SKIP">

				<xsl:choose>

					<xsl:when test="contains(normalize-space($fo_element), 'block')">

						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>

						<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
							<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
								<xsl:variable name="example_body">
									<xsl:apply-templates select="node()[not(local-name() = 'name')]">
										<xsl:with-param name="fo_element" select="$fo_element"/>
									</xsl:apply-templates>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="xalan:nodeset($example_body)/*">
										<xsl:copy-of select="$example_body"/>
									</xsl:when>
									<xsl:otherwise><fo:block/><!-- prevent empty block-container --></xsl:otherwise>
								</xsl:choose>
							</fo:block-container>
						</fo:block-container>
					</xsl:when> <!-- end block -->

					<xsl:when test="contains(normalize-space($fo_element), 'list')">

						<xsl:variable name="provisional_distance_between_starts">
							7
						</xsl:variable>
						<xsl:variable name="indent">
							0
						</xsl:variable>

						<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
							<fo:list-item>
								<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
									<fo:block>
										<xsl:apply-templates select="*[local-name()='name']">
											<xsl:with-param name="fo_element">block</xsl:with-param>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(local-name() = 'name')]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:when> <!-- end list -->

					<xsl:otherwise> <!-- inline -->

						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(local-name() = 'name')][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>

						<xsl:if test="*[not(local-name() = 'name')][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<xsl:apply-templates select="*[not(local-name() = 'name')][position() &gt; 1]">
										<xsl:with-param name="fo_element" select="'block'"/>
									</xsl:apply-templates>
								</fo:block-container>
							</fo:block-container>
						</xsl:if>
					</xsl:otherwise> <!-- end inline -->

				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:call-template name="refine_example-name-style"/>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'example']/*[local-name() = 'name']">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">

			<xsl:value-of select="$fo_element"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::*[local-name() = 'li'] and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">

						<xsl:call-template name="refine_example-p-style"/>

						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- example/p -->

	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- termsource -->
	<!-- origin -->
	<!-- modification -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">

			<xsl:call-template name="refine_termsource-style"/>

			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termsource']/text()[starts-with(., '[SOURCE: Adapted from: ') or     starts-with(., '[SOURCE: Quoted from: ') or     starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- text SOURCE: -->
	<xsl:template match="*[local-name() = 'termsource']/*[local-name() = 'strong'][1][following-sibling::*[1][local-name() = 'origin']]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'origin']">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

    <xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- qoute -->
	<!-- source -->
	<!-- author  -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'quote']">
		<fo:block-container margin-left="0mm" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">

					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>

	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//*[local-name() = 'bibitem'][@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//*[local-name() = 'references'][@hidden='true']//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'eref']" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/*[local-name() = 'uri'][@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>

					</xsl:if>

					<xsl:call-template name="refine_eref-style"/>

					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link fox:alt-text="{@citeas}">
								<xsl:if test="normalize-space(@citeas) = ''">
									<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@type = 'inline'">

									<xsl:call-template name="refine_basic_link_style"/>

								</xsl:if>

								<xsl:choose>
									<xsl:when test="$external-destination != ''"> <!-- external hyperlink -->
										<xsl:attribute name="external-destination"><xsl:value-of select="$external-destination"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="internal-destination"><xsl:value-of select="@bibitemid"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->

				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates/></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates/></fo:inline></xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_basic_link_style">

			<xsl:attribute name="text-decoration">underline</xsl:attribute>

	</xsl:template> <!-- refine_basic_link_style -->

	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->

	<!-- Tabulation processing -->
	<xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="padding">

				<xsl:choose>
					<xsl:when test="ancestor::un:sections and $depth = 1">12</xsl:when>
					<xsl:when test="ancestor::un:sections">8</xsl:when>
				</xsl:choose>

		</xsl:variable>

		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- tab -->

	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="*[local-name() = 'preferred']">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			inherit
		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">

			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'preferred'])"> <!-- if first preffered in term, then display term's name -->
				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">
					<xsl:apply-templates select="ancestor::*[local-name() = 'term'][1]/*[local-name() = 'name']"/>
				</fo:block>
			</xsl:if>

			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="setStyle_preferred"/>
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'deprecates']">
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:if test="*[local-name() = 'strong']">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="*[local-name() = 'preferred']/text()[contains(., ';')] | *[local-name() = 'preferred']/*[local-name() = 'strong']/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->

	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p'][1]">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block/>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->

	<!-- main sections -->
	<xsl:template match="/*/*[local-name() = 'sections']/*" name="sections_node" priority="2">

		<fo:block>
			<xsl:call-template name="setId"/>

			<xsl:call-template name="sections_element_style"/>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- note: @top-level added in mode=" update_xml_step_move_pagebreak" -->
	<xsl:template match="*[local-name() = 'sections']/*[local-name() = 'page_sequence']/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="local-name() = 'clause' and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/sections/clause -->
	<xsl:template match="*[local-name() = 'page_sequence']/*[local-name() = 'sections']/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="local-name() = 'clause' and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sections_element_style">

			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">20pt</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- sections_element_style -->

	<xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2" name="preface_node"> <!-- /*/*[local-name() = 'preface']/* -->

				<fo:block break-after="page"/>

		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- preface/ page_sequence/clause -->
	<xsl:template match="*[local-name() = 'preface']/*[local-name() = 'page_sequence']/*[not(@top-level)]" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<xsl:choose>
			<xsl:when test="local-name() = 'clause' and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/preface/clause -->
	<xsl:template match="*[local-name() = 'page_sequence']/*[local-name() = 'preface']/*[not(@top-level)]" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<xsl:choose>
			<xsl:when test="local-name() = 'clause' and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'clause'][normalize-space() != '' or *[local-name() = 'figure'] or @id]" name="template_clause"> <!-- if clause isn't empty -->
		<fo:block>
			<xsl:if test="parent::*[local-name() = 'copyright-statement']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setId"/>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_clause_style"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_clause_style">

	</xsl:template> <!-- refine_clause_style -->

	<xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annex'][normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>

				<fo:block break-after="page"/>
				<fo:block id="{@id}">

					<xsl:call-template name="setBlockSpanAll"/>

					<xsl:call-template name="refine_annex_style"/>

				</fo:block>

				<xsl:apply-templates select="*[local-name() = 'title'][@columns = 1]"/>

				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'title' and @columns = 1)]"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_annex_style">

			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">3pt</xsl:attribute>
			</xsl:if>

	</xsl:template>

	<xsl:template match="*[local-name() = 'review']"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->

		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>

		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::*[contains(local-name(), '-standard')] and not(ancestor::*[contains(local-name(), '-standard')]//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="*[local-name() = 'review'][@type = 'other']"/>

	<xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>

	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">

				<label>•</label>

	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level__">
			<xsl:value-of select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])"/>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 3"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 2 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 2]" mode="ul_labels"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="label" mode="ul_labels">
		<xsl:copy-of select="@*[not(local-name() = 'level')]"/>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="getListItemFormat">
		<!-- Example: for BSI <?list-type loweralpha?> -->
		<xsl:variable name="processing_instruction_type" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-type'))"/>
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">
				<xsl:choose>
					<xsl:when test="normalize-space($processing_instruction_type) = 'simple'"/>
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->

				<xsl:variable name="label">

					<xsl:variable name="type" select="../@type"/>

					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'">
							 <!-- Example: (i) -->
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="style_prefix" select="normalize-space($style_prefix_)"/>

					<xsl:variable name="style_suffix_">
						<xsl:choose>
							<xsl:when test="$type = 'arabic'">
								.
							</xsl:when>
							<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">
								)
							</xsl:when>
							<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">
								.
							</xsl:when>
							<xsl:when test="$type = 'roman'">
								)
							</xsl:when>
							<xsl:when test="$type = 'roman_upper'">.</xsl:when> <!-- Example: I. -->
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="style_suffix" select="normalize-space($style_suffix_)"/>

					<xsl:if test="$style_prefix != '' and not(starts-with(@label, $style_prefix))">
						<xsl:value-of select="$style_prefix"/>
					</xsl:if>
					<xsl:value-of select="@label"/>
					<xsl:if test="not(java:endsWith(java:java.lang.String.new(@label),$style_suffix))">
						<xsl:value-of select="$style_suffix"/>
					</xsl:if>
				</xsl:variable>

				<xsl:value-of select="normalize-space($label)"/>

			</xsl:when>
			<xsl:otherwise> <!-- for ordered lists 'ol' -->

				<!-- Example: for BSI <?list-start 2?> -->
				<xsl:variable name="processing_instruction_start" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-start'))"/>

				<xsl:variable name="start_value">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_start) != ''">
							<xsl:value-of select="number($processing_instruction_start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:when test="normalize-space(../@start) != ''">
							<xsl:value-of select="number(../@start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="curr_value"><xsl:number/></xsl:variable>

				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_type) != ''"><xsl:value-of select="$processing_instruction_type"/></xsl:when>
						<xsl:when test="normalize-space(../@type) != ''"><xsl:value-of select="../@type"/></xsl:when>

						<xsl:otherwise> <!-- if no @type or @class = 'steps' -->

							<xsl:variable name="list_level_" select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])"/>
							<xsl:variable name="list_level">
								<xsl:choose>
									<xsl:when test="$list_level_ &lt;= 5"><xsl:value-of select="$list_level_"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$list_level_ mod 5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$list_level mod 5 = 0">roman_upper</xsl:when> <!-- level 5 -->
								<xsl:when test="$list_level mod 4 = 0">alphabet_upper</xsl:when> <!-- level 4 -->
								<xsl:when test="$list_level mod 3 = 0">roman</xsl:when> <!-- level 3 -->
								<xsl:when test="$list_level mod 2 = 0 and ancestor::*/@class = 'steps'">alphabet</xsl:when> <!-- level 2 and @class = 'steps'-->
								<xsl:when test="$list_level mod 2 = 0">arabic</xsl:when> <!-- level 2 -->
								<xsl:otherwise> <!-- level 1 -->
									<xsl:choose>
										<xsl:when test="ancestor::*/@class = 'steps'">arabic</xsl:when>
										<xsl:otherwise>alphabet</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="$type = 'arabic'">
							1.
						</xsl:when>
						<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">
							a)
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">
							A.
						</xsl:when>
						<xsl:when test="$type = 'roman'">
							i)
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>

				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:param name="indent">0</xsl:param>
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="refine_list_container_style"/>

					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>

						<fo:block role="SKIP">
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_list_container_style">

	</xsl:template> <!-- refine_list_container_style -->

	<xsl:template match="*[local-name()='ul'] | *[local-name()='ol']" mode="list" name="list">

		<xsl:apply-templates select="*[local-name() = 'name']">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>

		<fo:list-block xsl:use-attribute-sets="list-style">

			<xsl:variable name="provisional_distance_between_starts_">
				<attributes xsl:use-attribute-sets="list-style">
					<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
				</attributes>
			</xsl:variable>
			<xsl:variable name="provisional_distance_between_starts" select="normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts)"/>
			<xsl:if test="$provisional_distance_between_starts != ''">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="provisional_distance_between_starts_value" select="substring-before($provisional_distance_between_starts, 'mm')"/>

			<!-- increase provisional-distance-between-starts for long lists -->
			<xsl:if test="local-name() = 'ol'">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="*[local-name() = 'li']">
						<item><xsl:call-template name="getListItemFormat"/></item>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="max_length">
					<xsl:for-each select="xalan:nodeset($item_numbers)/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position() = 1"><xsl:value-of select="string-length(.)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<!-- base width (provisional-distance-between-starts) for 4 chars -->
				<xsl:variable name="addon" select="$max_length - 4"/>
				<xsl:if test="$addon &gt; 0">
					<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts_value + $addon * 2"/>mm</xsl:attribute>
				</xsl:if>
				<!-- DEBUG -->
				<!-- <xsl:copy-of select="$item_numbers"/>
				<max_length><xsl:value-of select="$max_length"/></max_length>
				<addon><xsl:value-of select="$addon"/></addon> -->
			</xsl:if>

			<xsl:call-template name="refine_list-style"/>

			<xsl:if test="*[local-name() = 'name']">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()[not(local-name() = 'note')]"/>
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./*[local-name() = 'note']"/>
	</xsl:template>

	<xsl:template name="refine_list-style_provisional-distance-between-starts">

			<xsl:if test="local-name() = 'ol'">
				<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			</xsl:if>

	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->

	<xsl:template match="*[local-name() = 'ol' or local-name() = 'ul']/*[local-name() = 'name']">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='li']">
		<xsl:param name="indent">0</xsl:param>
		<!-- <fo:list-item xsl:use-attribute-sets="list-item-style">
			<fo:list-item-label end-indent="label-end()"><fo:block>x</fo:block></fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>debug li indent=<xsl:value-of select="$indent"/></fo:block>
			</fo:list-item-body>
		</fo:list-item> -->
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_list-item-style"/>

			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">

					<xsl:call-template name="refine_list-item-label-style"/>

					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>

					<xsl:call-template name="getListItemFormat"/>

				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">

					<xsl:call-template name="refine_list-item-body-style"/>

					<xsl:apply-templates>
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>

					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./bsi:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>

	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>

				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>

				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>

				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>

				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->

						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:param name="docid"/>

		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>

		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'title']" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<!-- Index -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']/*[local-name() = 'title']" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
			<xsl:if test="following-sibling::*[local-name() = 'clause']">
				<fo:block> </fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'bookmark']" priority="2"/>

	<xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
		<fo:inline id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:inline>
		<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
		<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt"> </fo:inline></xsl:if>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="*[local-name() = 'errata']">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">

					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block role="SKIP"><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->

	<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/>
	<xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][local-name() = 'bibitem'] and 1 = 1)"/>

	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="*[local-name() = 'bibitem'][starts-with(@id, 'hidden_bibitem_')]" priority="3"/>

	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']" priority="2">

		<fo:block id="{@id}">
			<xsl:apply-templates/>

		</fo:block>
	</xsl:template>

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="*[local-name() = 'references']">
		<xsl:if test="not(ancestor::*[local-name() = 'annex'])">

		</xsl:if>

		<!-- <xsl:if test="ancestor::*[local-name() = 'annex']">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->

		<fo:block id="{@id}"/>

		<xsl:apply-templates select="*[local-name() = 'title'][@columns = 1]"/>

		<fo:block xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates select="node()[not(local-name() = 'title' and @columns = 1)]"/>

		</fo:block>

	</xsl:template> <!-- references -->

	<xsl:template match="*[local-name() = 'bibitem']">
		<xsl:call-template name="bibitem"/>
	</xsl:template>

	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']/*[local-name() = 'bibitem']" name="bibitem" priority="2">

				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">

					<xsl:call-template name="processBibitem"/>
				</fo:block>

	</xsl:template> <!-- bibitem -->

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="*[local-name() = 'references'][not(@normative='true')]/*[local-name() = 'bibitem']" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][local-name() = 'bibitem'] and 1 = 1)"/> <!-- current bibiitem is non-first -->

				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
					<xsl:call-template name="processBibitem"/>
				</fo:block>

	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->

	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">

					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style" role="SKIP">
							<xsl:call-template name="processBibitem">
								<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
							</xsl:call-template>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[1][local-name() = 'bibitem']">
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>

				<!-- start UNECE bibitem processing -->
				<fo:inline padding-right="5mm">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</fo:inline>
				<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
					<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates select="un:formattedref"/>
				<!-- END UNECE bibitem processing -->

	</xsl:template> <!-- processBibitem (bibitem) -->

	<xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'docidentifier']"/>

	<xsl:template match="*[local-name() = 'formattedref']">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'biblio-tag']">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and *[local-name() = 'tab']">
				<xsl:apply-templates select="./*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'biblio-tag']/*[local-name() = 'tab']" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->

	<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->

	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'PDF TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->
				3
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="*[local-name() = 'toc']">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<tbody>
							<xsl:apply-templates mode="toc_table_width"/>
						</tbody>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/tr[1]/td)"/>
					<xsl:call-template name="calculate-column-widths-proportional">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']/*[local-name() = 'p']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'xref']" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:variable name="target" select="@target"/>
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'clause'][@type = 'toc']/*[local-name() = 'title']" mode="toc_table_width"/>
	<xsl:template match="*[local-name() = 'clause'][not(@type = 'toc')]/*[local-name() = 'title']" mode="toc_table_width"/>

	<xsl:template match="*[local-name() = 'li']" mode="toc_table_width">
		<tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</tr>
	</xsl:template>

	<xsl:template match="*[local-name() = 'xref']" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<td>
				<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</td>
		</xsl:for-each>
		<td>333</td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

	<!-- insert fo:basic-link, if external-destination or internal-destination is non-empty, otherwise insert fo:inline -->
	<xsl:template name="insert_basic_link">
		<xsl:param name="element"/>
		<xsl:variable name="element_node" select="xalan:nodeset($element)"/>
		<xsl:variable name="external-destination" select="normalize-space(count($element_node/fo:basic-link/@external-destination[. != '']) = 1)"/>
		<xsl:variable name="internal-destination" select="normalize-space(count($element_node/fo:basic-link/@internal-destination[. != '']) = 1)"/>
		<xsl:choose>
			<xsl:when test="$external-destination = 'true' or $internal-destination = 'true'">
				<xsl:copy-of select="$element_node"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline>
					<xsl:for-each select="$element_node/fo:basic-link/@*[local-name() != 'external-destination' and local-name() != 'internal-destination' and local-name() != 'alt-text']">
						<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$element_node/fo:basic-link/node()"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'variant-title']"/> <!-- [@type = 'sub'] -->
	<xsl:template match="*[local-name() = 'variant-title'][@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm"> </fo:inline>
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'blacksquare']" name="blacksquare">
		<fo:inline padding-right="2.5mm" baseline-shift="5%">
			<fo:instream-foreign-object content-height="2mm" content-width="2mm" fox:alt-text="Quad">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 2 2">
						<rect x="0" y="0" width="2" height="2" fill="black"/>
					</svg>
				</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="@language">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>

	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="*[local-name() = 'admonition']">

		 <!-- display name before box -->
			<fo:block xsl:use-attribute-sets="admonition-name-style">
				<xsl:call-template name="displayAdmonitionName"/>
			</fo:block>

		 <!-- text in the box -->
				<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">

					<xsl:call-template name="setBlockSpanAll"/>

							<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">

										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<fo:block>
												<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
											</fo:block>
										</fo:block-container>

							</fo:block-container>

				</fo:block-container>

	</xsl:template>

	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*[local-name() = 'name']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*[local-name() = 'name']"/>
				<xsl:if test="not(*[local-name() = 'name'])">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="*[local-name() = 'name']"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'name']">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="*[local-name() = 'admonition']/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->

	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'p']">

				<fo:block xsl:use-attribute-sets="admonition-p-style">

					<xsl:apply-templates/>
				</fo:block>

	</xsl:template>

	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->

	<xsl:template name="updateXML">
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step1</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
		<xsl:variable name="updated_xml_step1">
			<xsl:if test="$table_if = 'false'">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step1</xsl:message>
			<!-- <redirect:write file="updated_xml_step1_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step2</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<xsl:variable name="updated_xml_step2">

					<xsl:if test="$table_if = 'false'">
						<xsl:copy-of select="$updated_xml_step1"/>
					</xsl:if>

		</xsl:variable>

		<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step2</xsl:message>
			<!-- <redirect:write file="updated_xml_step2_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/>

		<xsl:variable name="updated_xml_step3">
			<xsl:choose>
				<xsl:when test="$table_if = 'false'">
					<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step3</xsl:message>
			<!-- <redirect:write file="updated_xml_step3_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step3"/>
			</redirect:write> -->
		</xsl:if>

		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START copying updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime4" select="java:getTime(java:java.util.Date.new())"/>  -->
		<xsl:copy-of select="$updated_xml_step3"/>
		<!-- <xsl:variable name="endTime4" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime4 - $startTime4"/> msec.</xsl:message>
			<xsl:message>END copying updated_xml_step3</xsl:message>
		</xsl:if> -->

	</xsl:template>

	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Put Section title in the correct position -->
	<!--   - Ignore 'span' without style -->
	<!--   - Remove semantic xml part -->
	<!--   - Remove image/emf (EMF vector image for Word) -->
	<!--   - add @id, redundant for table auto-layout algorithm -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- change section's order based on @displayorder value -->
	<xsl:template match="*[local-name() = 'preface']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'sections']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* |      ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |     ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibliography']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="*[local-name() = 'span'][@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'sections']/*[local-name() = 'p'][starts-with(@class, 'zzSTDTitle')]/*[local-name() = 'span'][@class] | *[local-name() = 'sourcecode']//*[local-name() = 'span'][@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- remove semantic xml -->
	<xsl:template match="*[local-name() = 'metanorma-extension']/*[local-name() = 'metanorma']/*[local-name() = 'source']" mode="update_xml_step1"/>

	<!-- remove image/emf -->
	<xsl:template match="*[local-name() = 'image']/*[local-name() = 'emf']" mode="update_xml_step1"/>

	<!-- remove preprocess-xslt -->
	<xsl:template match="*[local-name() = 'preprocess-xslt']" mode="update_xml_step1"/>

	<xsl:template match="*[local-name() = 'stem'] |        *[local-name() = 'image'] |        *[local-name() = 'sourcecode'] |        *[local-name() = 'bibdata'] |        *[local-name() = 'localized-strings']" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- add @id, mandatory for table auto-layout algorithm -->
	<xsl:template match="*[local-name() = 'dl' or local-name() = 'table'][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'thead'][count(*) = 0]" mode="update_xml_step1"/>

	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:attribute name="id"><xsl:value-of select="(.//*[@id])[1]/@id"/>_<xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- optimization: remove clause if table_only_with_id isn't empty and clause doesn't contain table or dl with table_only_with_id -->
	<xsl:template match="*[local-name() = 'clause' or local-name() = 'p' or local-name() = 'definitions' or local-name() = 'annex']" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="($table_only_with_id != '' or $table_only_with_ids != '') and local-name() = 'p' and (ancestor::*[local-name() = 'table' or local-name() = 'dl' or local-name() = 'toc'])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_id != '' and not(.//*[local-name() = 'table' or local-name() = 'dl'][@id = $table_only_with_id])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_ids != '' and not(.//*[local-name() = 'table' or local-name() = 'dl'][contains($table_only_with_ids, concat(@id, ' '))])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step_move_pagebreak">
				<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!-- replace 'pagebreak' by closing tags + page_sequence and  opening page_sequence + tags -->
	<xsl:template match="*[local-name() = 'pagebreak'][not(following-sibling::*[1][local-name() = 'pagebreak'])]" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top"/>
		<!-- <xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'sections']">
			
			</xsl:when>
			<xsl:when test="ancestor::*[local-name() = 'annex']">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose> -->

		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::*[local-name() = 'preface'] or ancestor::*[local-name() = 'sections'] or ancestor-or-self::*[local-name() = 'annex']]">
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="contains($isLast, 'false')">

			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>

			<xsl:variable name="tree_">
				<xsl:call-template name="makeAncestorsElementsTree">
					<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:call-template name="insertClosingElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

			<xsl:text disable-output-escaping="yes">&lt;/page_sequence&gt;</xsl:text>

			<!-- create a new page_sequence (opening elements) -->
			<xsl:text disable-output-escaping="yes">&lt;page_sequence xmlns="</xsl:text><xsl:value-of select="$namespace_full"/>"<xsl:if test="$orientation != ''"> orientation="<xsl:value-of select="$orientation"/>"</xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			<xsl:call-template name="insertOpeningElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

		</xsl:if>
	</xsl:template>

	<xsl:template name="makeAncestorsElementsTree">
		<xsl:param name="page_sequence_at_top"/>

		<xsl:choose>
			<xsl:when test="$page_sequence_at_top = 'true'">
				<xsl:for-each select="ancestor::*[ancestor::*[contains(local-name(), '-standard')]]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[ancestor::*[local-name() = 'preface'] or ancestor::*[local-name() = 'sections'] or ancestor-or-self::*[local-name() = 'annex']]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertClosingElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:sort data-type="number" order="descending" select="@pos"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;/<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertOpeningElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="."/>
				<xsl:for-each select="@*[local-name() != 'pos']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>="</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:if test="position() = 1"> continue="true"</xsl:if>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- move full page width figures, tables at top level -->
	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table'][normalize-space(@width) != 'text-width']" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layout_columns != 1">

				<xsl:variable name="tree_">
					<xsl:call-template name="makeAncestorsElementsTree">
						<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

				<xsl:call-template name="insertClosingElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="top-level">true</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:copy>

				<xsl:call-template name="insertOpeningElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
	<xsl:variable name="regex_express_reference">(^([A-Za-z0-9_.\\]+)$)</xsl:variable>

	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>

	<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
	<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
	<!-- add &lt; and &gt; to \S -->
	<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>

	<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>

	<xsl:template match="text()[not(ancestor::*[local-name() = 'bibdata'] or      ancestor::*[local-name() = 'link'][not(contains(.,' '))] or      ancestor::*[local-name() = 'sourcecode'] or      ancestor::*[local-name() = 'math'] or     ancestor::*[local-name() = 'svg'] or     starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') or normalize-space() = '' )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">

		<xsl:variable name="parent" select="local-name(..)"/>

		<xsl:if test="1 = 2"> <!-- alternative variant -->

			<xsl:variable name="regexs">
				<!-- enclose standard's number into tag 'keep-together_within-line' -->
				<xsl:if test="not(ancestor::*[local-name() = 'table'])"><regex><xsl:value-of select="$regex_standard_reference"/></regex></xsl:if>
				<!-- if EXPRESS reference -->

				<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
				<regex><xsl:value-of select="$regex_solidus_units"/></regex>
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
					<regex><xsl:value-of select="$regex_dots_units"/></regex>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="regex_replacement"><xsl:text>(</xsl:text>
				<xsl:for-each select="xalan:nodeset($regexs)/regex">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>

			<!-- regex_replacement='<xsl:value-of select="$regex_replacement"/>' -->

			<xsl:variable name="text_replaced" select="java:replaceAll(java:java.lang.String.new(.), $regex_replacement, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>

			<!-- text_replaced='<xsl:value-of select="$text_replaced"/>' -->

			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_replaced"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="1 = 1">

		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="text">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
					<xsl:otherwise>
						<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<!-- <xsl:value-of select="$text__"/> -->

						<xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="text2">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text)/*[local-name() = 'text']/node()">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<xsl:variable name="text3">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text2)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_units" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_units">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_units"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_units)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:for-each select="xalan:nodeset($text3)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_dots">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_dots"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/*[local-name() = 'text']/node()"/></xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem'] | *[local-name() = 'image']" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>

				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}" namespace="{$namespace_full}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>

				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Make linear XML (need for landscape orientation) -->
	<!-- ===================================== -->
	<!-- ===================================== -->
	<xsl:template match="@*|node()" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="processing-instruction()" mode="linear_xml">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- From:
		<clause>
			<title>...</title>
			<p>...</p>
		</clause>
		To:
			<clause/>
			<title>...</title>
			<p>...</p>
		-->
	<xsl:template match="*[local-name() = 'foreword'] |            *[local-name() = 'foreword']//*[local-name() = 'clause'] |            *[local-name() = 'preface']//*[local-name() = 'clause'][not(@type = 'corrigenda') and not(@type = 'policy') and not(@type = 'related-refs')] |            *[local-name() = 'introduction'] |            *[local-name() = 'introduction']//*[local-name() = 'clause'] |            *[local-name() = 'sections']//*[local-name() = 'clause'] |             *[local-name() = 'annex'] |             *[local-name() = 'annex']//*[local-name() = 'clause'] |             *[local-name() = 'references'][not(@hidden = 'true')] |            *[local-name() = 'bibliography']/*[local-name() = 'clause'] |             *[local-name() = 'colophon'] |             *[local-name() = 'colophon']//*[local-name() = 'clause'] |             *[local-name()='sections']//*[local-name()='terms'] |             *[local-name()='sections']//*[local-name()='definitions'] |            *[local-name()='annex']//*[local-name()='definitions']" mode="linear_xml" name="clause_linear">

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>

			<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:if test="local-name() = 'foreword' or local-name() = 'introduction' or    local-name(..) = 'preface' or local-name(..) = 'sections' or     (local-name() = 'references' and parent::*[local-name() = 'bibliography']) or    (local-name() = 'clause' and parent::*[local-name() = 'bibliography']) or    local-name() = 'annex' or     local-name(..) = 'annex' or    local-name(..) = 'colophon'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
		</xsl:copy>

		<xsl:apply-templates mode="linear_xml"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'term']" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>
			<xsl:attribute name="ancestor">sections</xsl:attribute>
			<xsl:apply-templates select="node()[not(local-name() = 'term')]" mode="linear_xml"/>
		</xsl:copy>
		<xsl:apply-templates select="*[local-name() = 'term']" mode="linear_xml"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'introduction']//*[local-name() = 'title'] |     *[local-name() = 'foreword']//*[local-name() = 'title'] |     *[local-name() = 'preface']//*[local-name() = 'title'] |     *[local-name() = 'sections']//*[local-name() = 'title'] |     *[local-name() = 'annex']//*[local-name() = 'title'] |     *[local-name() = 'bibliography']/*[local-name() = 'clause']/*[local-name() = 'title'] |     *[local-name() = 'references']/*[local-name() = 'title'] |     *[local-name() = 'colophon']//*[local-name() = 'title']" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>

			<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>

			<xsl:if test="parent::*[local-name() = 'annex']">
				<xsl:attribute name="depth">1</xsl:attribute>
			</xsl:if>

			<xsl:if test="../@inline-header = 'true' and following-sibling::*[1][local-name() = 'p']">
				<xsl:copy-of select="../@inline-header"/>
			</xsl:if>

			<xsl:variable name="ancestor">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'foreword']">foreword</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'introduction']">introduction</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'sections']">sections</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'annex']">annex</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'bibliography']">bibliography</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="ancestor">
				<xsl:value-of select="$ancestor"/>
			</xsl:attribute>

			<xsl:attribute name="parent">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'preface']">preface</xsl:when>
					<xsl:otherwise><xsl:value-of select="$ancestor"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'li']" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>

			<xsl:variable name="ancestor">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'preface']">preface</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'sections']">sections</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'annex']">annex</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="ancestor">
				<xsl:value-of select="$ancestor"/>
			</xsl:attribute>

			<xsl:apply-templates mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>

	<!-- add @to = figure, table, clause -->
	<!-- add @depth = from  -->
	<xsl:template match="*[local-name() = 'xref']" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:variable name="target" select="@target"/>
			<xsl:attribute name="to">
				<xsl:value-of select="local-name(//*[@id = current()/@target][1])"/>
			</xsl:attribute>
			<xsl:attribute name="depth">
				<xsl:value-of select="//*[@id = current()/@target][1]/*[local-name() = 'title']/@depth"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[not(ancestor::*[local-name() = 'sourcecode'])]/*[local-name() = 'p' or local-name() = 'strong' or local-name() = 'em']/text()" mode="linear_xml">
		<xsl:choose>
			<xsl:when test="contains(., $non_breaking_hyphen)">
				<xsl:call-template name="replaceChar">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="replace" select="$non_breaking_hyphen"/>
					<xsl:with-param name="by" select="'-'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replaceChar">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:element name="inlineChar" namespace="https://www.metanorma.org/ns/jis"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)"/>
						<xsl:with-param name="replace" select="$replace"/>
						<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'inlineChar']">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<!-- change @reference to actual value, and add skip_footnote_body="true" for repeatable (2nd, 3rd, ...) -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))]" mode="linear_xml" name="linear_xml_fn">
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
			<!-- <xsl:choose>
				<xsl:when test="$namespace = 'jis'">
					<xsl:call-template name="get_fn_list_for_element"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_fn_list"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference" select="@reference"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<!-- put actual reference number -->
			<xsl:attribute name="current_fn_number">
				<xsl:value-of select="$current_fn_number"/>
			</xsl:attribute>
			<xsl:variable name="skip_footnote_body_" select="not($p_fn//fn[@gen_id = $gen_id] and (1 = 1))"/>
			<xsl:attribute name="skip_footnote_body"> <!-- false for repeatable footnote -->

						<xsl:value-of select="$skip_footnote_body_"/>

			</xsl:attribute>
			<xsl:attribute name="ref_id">
				<xsl:value-of select="concat('footnote_', $lang, '_', $reference, '_', $current_fn_number)"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p'][@type = 'section-title']" priority="3" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:if test="@depth = '1'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Make linear XML (need for landscape orientation) -->
	<!-- ===================================== -->
	<!-- ===================================== -->

	<!-- for correct rendering combining chars -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'][normalize-space(@language) != ''])"/>

		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'])"/>
				<xsl:if test="$edition != ''"> <!-- Example: 1.3 -->
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">edition</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$edition"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lowercase" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="monthStr_localized">
			<xsl:if test="normalize-space($monthStr) != ''"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param></xsl:call-template></xsl:if>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'"> <!-- convert date from format 2007-04-01 to 1 April 2007 -->
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr_localized"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $day, ', ' , $year))"/> <!-- January 01, 2022 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template> <!-- convertDate -->

	<!-- return Month's name by number -->
	<xsl:template name="getMonthByNum">
		<xsl:param name="num"/>
		<xsl:param name="lang">en</xsl:param>
		<xsl:param name="lowercase">false</xsl:param> <!-- return 'january' instead of 'January' -->
		<xsl:variable name="monthStr_">
			<xsl:choose>
				<xsl:when test="$lang = 'fr'">
					<xsl:choose>
						<xsl:when test="$num = '01'">Janvier</xsl:when>
						<xsl:when test="$num = '02'">Février</xsl:when>
						<xsl:when test="$num = '03'">Mars</xsl:when>
						<xsl:when test="$num = '04'">Avril</xsl:when>
						<xsl:when test="$num = '05'">Mai</xsl:when>
						<xsl:when test="$num = '06'">Juin</xsl:when>
						<xsl:when test="$num = '07'">Juillet</xsl:when>
						<xsl:when test="$num = '08'">Août</xsl:when>
						<xsl:when test="$num = '09'">Septembre</xsl:when>
						<xsl:when test="$num = '10'">Octobre</xsl:when>
						<xsl:when test="$num = '11'">Novembre</xsl:when>
						<xsl:when test="$num = '12'">Décembre</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$num = '01'">January</xsl:when>
						<xsl:when test="$num = '02'">February</xsl:when>
						<xsl:when test="$num = '03'">March</xsl:when>
						<xsl:when test="$num = '04'">April</xsl:when>
						<xsl:when test="$num = '05'">May</xsl:when>
						<xsl:when test="$num = '06'">June</xsl:when>
						<xsl:when test="$num = '07'">July</xsl:when>
						<xsl:when test="$num = '08'">August</xsl:when>
						<xsl:when test="$num = '09'">September</xsl:when>
						<xsl:when test="$num = '10'">October</xsl:when>
						<xsl:when test="$num = '11'">November</xsl:when>
						<xsl:when test="$num = '12'">December</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($lowercase) = 'true'">
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($monthStr_))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthStr_"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getMonthByNum -->

	<!-- return Month's name by number from localized strings -->
	<xsl:template name="getMonthLocalizedByNum">
		<xsl:param name="num"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$num = '01'">january</xsl:when>
				<xsl:when test="$num = '02'">february</xsl:when>
				<xsl:when test="$num = '03'">march</xsl:when>
				<xsl:when test="$num = '04'">april</xsl:when>
				<xsl:when test="$num = '05'">may</xsl:when>
				<xsl:when test="$num = '06'">june</xsl:when>
				<xsl:when test="$num = '07'">july</xsl:when>
				<xsl:when test="$num = '08'">august</xsl:when>
				<xsl:when test="$num = '09'">september</xsl:when>
				<xsl:when test="$num = '10'">october</xsl:when>
				<xsl:when test="$num = '11'">november</xsl:when>
				<xsl:when test="$num = '12'">december</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- getMonthLocalizedByNum -->

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="meta" select="'false'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:param name="meta"/>
		<xsl:choose>
			<xsl:when test="$meta = 'true'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
			<pdf:dictionary type="normal" key="ViewerPreferences">
				<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
			</pdf:dictionary>
		</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">

										<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'main']"/>

							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="normalize-space($title) != ''">
								<xsl:value-of select="$title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</dc:title>
					<dc:creator>
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">

									<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
										<xsl:if test="position() != last()">; </xsl:if>
									</xsl:for-each>

						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">

									<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()[not(ancestor::*[local-name() = 'title'])]"/>

						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords">
							<xsl:with-param name="meta">true</xsl:with-param>
						</xsl:call-template>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
		<!-- add attachments -->
		<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'attachment']">
			<xsl:choose>
				<xsl:when test="normalize-space() != ''">
					<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{.}" filename="{@name}"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- _{filename}_attachments -->
					<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath, '_', $inputxml_filename_prefix, '_attachments', '/', @name, ')')"/>
					<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{$url}" filename="{@name}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- references to external attachments (no binary-encoded within the Metanorma XML file) -->
		<xsl:if test="not(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'attachment'])">
			<xsl:for-each select="//*[local-name() = 'bibitem'][@hidden = 'true'][*[local-name() = 'uri'][@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="*[local-name() = 'uri'][@type = 'attachment']"/>
				<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath, $attachment_path, ')')"/>
				<xsl:variable name="filename_embedded" select="substring-after($attachment_path, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
				<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{$url}" filename="{$filename_embedded}"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template> <!-- addPDFUAmeta -->

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get or calculate depth of the element -->
	<xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*[local-name() != 'page_sequence'])"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface'] and not(ancestor::*[local-name() = 'foreword']) and not(ancestor::*[local-name() = 'introduction'])"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevel -->

	<!-- Get or calculate depth of term's name -->
	<xsl:template name="getLevelTermName">
		<xsl:choose>
			<xsl:when test="normalize-space(../@depth) != ''">
				<xsl:value-of select="../@depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title_level_">
					<xsl:for-each select="../preceding-sibling::*[local-name() = 'title'][1]">
						<xsl:call-template name="getLevel"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="title_level" select="normalize-space($title_level_)"/>
				<xsl:choose>
					<xsl:when test="$title_level != ''"><xsl:value-of select="$title_level + 1"/></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLevel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevelTermName -->

	<!-- split string by separator -->
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:param name="keep_sep" select="'false'"/>
		<xsl:if test="string-length($pText) &gt;0">
			<item>
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</item>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><item><xsl:value-of select="$sep"/></item></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->

	<xsl:template name="getDocumentId">
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>

	<xsl:template name="getDocumentId_fromCurrentNode">
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>

	<xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">

				<xsl:value-of select="document('')//*/namespace::un"/>

		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template> <!-- namespaceCheck -->

	<xsl:template name="getLanguage">
		<xsl:param name="lang"/>
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setId">
		<xsl:param name="prefix"/>
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="concat($prefix, @id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prefix, generate-id())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		<xsl:param name="lang"/>
		<xsl:param name="returnEmptyIfNotFound">false</xsl:param>

		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="$lang != ''"><xsl:value-of select="$lang"/></xsl:when>
				<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLocalizedString -->

	<xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- setTrackChangesStyles -->

	<!--  see https://xmlgraphics.apache.org/fop/2.5/complexscripts.html#bidi_controls-->
	<xsl:variable name="LRM" select="'‎'"/> <!-- U+200E - LEFT-TO-RIGHT MARK (LRM) -->
	<xsl:variable name="RLM" select="'‏'"/> <!-- U+200F - RIGHT-TO-LEFT MARK (RLM) -->
	<xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:variable name="align" select="normalize-space(@align)"/>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
				<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
				<xsl:when test="$align = 'justified'">justify</xsl:when>
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setBlockAttributes">
		<xsl:param name="text_align_default">left</xsl:param>
		<xsl:call-template name="setTextAlignment">
			<xsl:with-param name="default" select="$text_align_default"/>
		</xsl:call-template>
		<xsl:call-template name="setKeepAttributes"/>
	</xsl:template>

	<xsl:template name="setKeepAttributes">
		<!-- https://www.metanorma.org/author/topics/document-format/text/#avoiding-page-breaks -->
		<!-- Example: keep-lines-together="true" -->
		<xsl:if test="@keep-lines-together = 'true'">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<!-- Example: keep-with-next="true" -->
		<xsl:if test="@keep-with-next =  'true'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- insert cover page image -->
		<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = $name][1]/*[local-name() = 'value']/*[local-name() = 'image'][$num]">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
							<fo:instream-foreign-object fox:alt-text="Image Front">
								<xsl:attribute name="content-height"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
								<xsl:call-template name="getSVG"/>
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
							<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
						</xsl:when>
						<xsl:otherwise> <!-- bitmap image -->
							<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
							<xsl:if test="$coverimage_src != ''">
								<xsl:variable name="coverpage">
									<xsl:call-template name="getImageURL">
										<xsl:with-param name="src" select="$coverimage_src"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:variable name="coverpage" select="concat('url(file:',$basepath, 'coverpage1.png', ')')"/> --> <!-- for DEBUG -->
								<fo:external-graphic src="{$coverpage}" width="{$pageWidth}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('url(file:///',$basepath, $src, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END: insert cover page image -->

	<xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'"> <!-- https://en.wiktionary.org/wiki/Appendix:French_numbers -->
							<word cardinal="1">Une-</word>
							<word ordinal="1">Première </word>
							<word cardinal="2">Deux-</word>
							<word ordinal="2">Seconde </word>
							<word cardinal="3">Trois-</word>
							<word ordinal="3">Tierce </word>
							<word cardinal="4">Quatre-</word>
							<word ordinal="4">Quatrième </word>
							<word cardinal="5">Cinq-</word>
							<word ordinal="5">Cinquième </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixième </word>
							<word cardinal="7">Sept-</word>
							<word ordinal="7">Septième </word>
							<word cardinal="8">Huit-</word>
							<word ordinal="8">Huitième </word>
							<word cardinal="9">Neuf-</word>
							<word ordinal="9">Neuvième </word>
							<word ordinal="10">Dixième </word>
							<word ordinal="11">Onzième </word>
							<word ordinal="12">Douzième </word>
							<word ordinal="13">Treizième </word>
							<word ordinal="14">Quatorzième </word>
							<word ordinal="15">Quinzième </word>
							<word ordinal="16">Seizième </word>
							<word ordinal="17">Dix-septième </word>
							<word ordinal="18">Dix-huitième </word>
							<word ordinal="19">Dix-neuvième </word>
							<word cardinal="20">Vingt-</word>
							<word ordinal="20">Vingtième </word>
							<word cardinal="30">Trente-</word>
							<word ordinal="30">Trentième </word>
							<word cardinal="40">Quarante-</word>
							<word ordinal="40">Quarantième </word>
							<word cardinal="50">Cinquante-</word>
							<word ordinal="50">Cinquantième </word>
							<word cardinal="60">Soixante-</word>
							<word ordinal="60">Soixantième </word>
							<word cardinal="70">Septante-</word>
							<word ordinal="70">Septantième </word>
							<word cardinal="80">Huitante-</word>
							<word ordinal="80">Huitantième </word>
							<word cardinal="90">Nonante-</word>
							<word ordinal="90">Nonantième </word>
							<word cardinal="100">Cent-</word>
							<word ordinal="100">Centième </word>
						</xsl:when>
						<xsl:when test="$lang = 'ru'">
							<word cardinal="1">Одна-</word>
							<word ordinal="1">Первое </word>
							<word cardinal="2">Две-</word>
							<word ordinal="2">Второе </word>
							<word cardinal="3">Три-</word>
							<word ordinal="3">Третье </word>
							<word cardinal="4">Четыре-</word>
							<word ordinal="4">Четвертое </word>
							<word cardinal="5">Пять-</word>
							<word ordinal="5">Пятое </word>
							<word cardinal="6">Шесть-</word>
							<word ordinal="6">Шестое </word>
							<word cardinal="7">Семь-</word>
							<word ordinal="7">Седьмое </word>
							<word cardinal="8">Восемь-</word>
							<word ordinal="8">Восьмое </word>
							<word cardinal="9">Девять-</word>
							<word ordinal="9">Девятое </word>
							<word ordinal="10">Десятое </word>
							<word ordinal="11">Одиннадцатое </word>
							<word ordinal="12">Двенадцатое </word>
							<word ordinal="13">Тринадцатое </word>
							<word ordinal="14">Четырнадцатое </word>
							<word ordinal="15">Пятнадцатое </word>
							<word ordinal="16">Шестнадцатое </word>
							<word ordinal="17">Семнадцатое </word>
							<word ordinal="18">Восемнадцатое </word>
							<word ordinal="19">Девятнадцатое </word>
							<word cardinal="20">Двадцать-</word>
							<word ordinal="20">Двадцатое </word>
							<word cardinal="30">Тридцать-</word>
							<word ordinal="30">Тридцатое </word>
							<word cardinal="40">Сорок-</word>
							<word ordinal="40">Сороковое </word>
							<word cardinal="50">Пятьдесят-</word>
							<word ordinal="50">Пятидесятое </word>
							<word cardinal="60">Шестьдесят-</word>
							<word ordinal="60">Шестидесятое </word>
							<word cardinal="70">Семьдесят-</word>
							<word ordinal="70">Семидесятое </word>
							<word cardinal="80">Восемьдесят-</word>
							<word ordinal="80">Восьмидесятое </word>
							<word cardinal="90">Девяносто-</word>
							<word ordinal="90">Девяностое </word>
							<word cardinal="100">Сто-</word>
							<word ordinal="100">Сотое </word>
						</xsl:when>
						<xsl:otherwise> <!-- default english -->
							<word cardinal="1">One-</word>
							<word ordinal="1">First </word>
							<word cardinal="2">Two-</word>
							<word ordinal="2">Second </word>
							<word cardinal="3">Three-</word>
							<word ordinal="3">Third </word>
							<word cardinal="4">Four-</word>
							<word ordinal="4">Fourth </word>
							<word cardinal="5">Five-</word>
							<word ordinal="5">Fifth </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixth </word>
							<word cardinal="7">Seven-</word>
							<word ordinal="7">Seventh </word>
							<word cardinal="8">Eight-</word>
							<word ordinal="8">Eighth </word>
							<word cardinal="9">Nine-</word>
							<word ordinal="9">Ninth </word>
							<word ordinal="10">Tenth </word>
							<word ordinal="11">Eleventh </word>
							<word ordinal="12">Twelfth </word>
							<word ordinal="13">Thirteenth </word>
							<word ordinal="14">Fourteenth </word>
							<word ordinal="15">Fifteenth </word>
							<word ordinal="16">Sixteenth </word>
							<word ordinal="17">Seventeenth </word>
							<word ordinal="18">Eighteenth </word>
							<word ordinal="19">Nineteenth </word>
							<word cardinal="20">Twenty-</word>
							<word ordinal="20">Twentieth </word>
							<word cardinal="30">Thirty-</word>
							<word ordinal="30">Thirtieth </word>
							<word cardinal="40">Forty-</word>
							<word ordinal="40">Fortieth </word>
							<word cardinal="50">Fifty-</word>
							<word ordinal="50">Fiftieth </word>
							<word cardinal="60">Sixty-</word>
							<word ordinal="60">Sixtieth </word>
							<word cardinal="70">Seventy-</word>
							<word ordinal="70">Seventieth </word>
							<word cardinal="80">Eighty-</word>
							<word ordinal="80">Eightieth </word>
							<word cardinal="90">Ninety-</word>
							<word ordinal="90">Ninetieth </word>
							<word cardinal="100">Hundred-</word>
							<word ordinal="100">Hundredth </word>
						</xsl:otherwise>
					</xsl:choose>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>

			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template> <!-- number-to-words -->

	<!-- st for 1, nd for 2, rd for 3, th for 4, 5, 6, ... -->
	<xsl:template name="number-to-ordinal">
		<xsl:param name="number"/>
		<xsl:param name="curr_lang"/>
		<xsl:choose>
			<xsl:when test="$curr_lang = 'fr'">
				<xsl:choose>
					<xsl:when test="$number = '1'">re</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number = 1">st</xsl:when>
					<xsl:when test="$number = 2">nd</xsl:when>
					<xsl:when test="$number = 3">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- number-to-ordinal -->

	<!-- add the attribute fox:alt-text, required for PDF/UA -->
	<xsl:template name="setAltText">
		<xsl:param name="value"/>
		<xsl:attribute name="fox:alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space($value) != ''">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>_</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="print_as_xml">
		<xsl:param name="level">0</xsl:param>

		<fo:block margin-left="{2*$level}mm">
			<xsl:text>
&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>

			<xsl:if test="not(*)">
				<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>&gt;</xsl:text>
			</xsl:if>
		</fo:block>

		<xsl:if test="*">
			<fo:block>
				<xsl:apply-templates mode="print_as_xml">
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</fo:block>
			<fo:block margin-left="{2*$level}mm">
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>&gt;</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>