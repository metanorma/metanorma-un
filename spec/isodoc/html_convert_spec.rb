require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__),
                                     "..", "..", "lib", "isodoc", "un", "html"))

RSpec.describe IsoDoc::UN do
  it "processes default metadata, recommendation" do
    csdc = IsoDoc::UN::HtmlConvert.new({ toc: true })
    input = <<~"INPUT"
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title type="main" language="en" format="plain">Main Title</title>
        <title type="subtitle" language="en" format="plain">Subtitle</title>
        <docidentifier>1000A</docidentifier>
        <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
            <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
                <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
          </organization>
        </contributor>
        <edition>2</edition>
        <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
      <note type="title-footnote"><p>ABC</p></note>
        <language>en</language>
        <language>fr</language>
        <script>Latn</script>
        <status><stage>working-draft</stage></status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
                <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>recommendation</doctype>
        <editorialgroup>
          <committee type="A">TC</committee>
        </editorialgroup>
        <security>Client Confidential</security>
        <submissionlanguage>de</submissionlanguage>
        <submissionlanguage>jp</submissionlanguage>
        </ext>
      </bibdata>
      <sections/>
      </un-standard>
    INPUT

    output = <<~"OUTPUT"
{accesseddate: "XXX", adapteddate: "XXX", agency: "UN", announceddate: "XXX", bibdata: {id: "1000A", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Main Title", type: "main", format: "plain"}, {language: "en", content: "Subtitle", type: "subtitle", format: "plain"}], docidentifier: [{content: "1000A"}], docnumber: "1000", contributor: [{role: [{type: "author"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}, {role: [{type: "publisher"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}], edition: {content: "2"}, version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], note: [{content: "<p>ABC</p>", type: "title-footnote"}], language: ["en", "fr"], script: ["Latn"], status: {stage: {content: "working-draft"}}, copyright: [{from: "2001", owner: [{organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}]}], ext: {doctype: {content: "recommendation"}, editorialgroup: {committee: {type: "A", content: "TC"}}, security: {content: "Client Confidential"}, submissionlanguage: [{content: "de"}, {content: "jp"}]}}, circulateddate: "XXX", confirmeddate: "XXX", copieddate: "XXX", correcteddate: "XXX", createddate: "XXX", docnumber: "1000A", docnumeric: "1000", docsubtitle: "Subtitle", doctitle: "Main Title", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2001", draft: "3.4", draftinfo: " (draft 3.4, 2000-01-01)", edition: "2", formatted_docnumber: "UN/CEFACT Recommendation 1000A", implementeddate: "XXX", issueddate: "XXX", lang: "en", logo: "#{File.join(logoloc, 'logo.jpg')}", obsoleteddate: "XXX", publisheddate: "XXX", publisher: "United Nations", receiveddate: "XXX", revdate: "2000-01-01", revdate_monthyear: "January 2000", script: "Latn", stable_untildate: "XXX", stage: "Working Draft", stage_display: "Working Draft", submissionlanguage: ["German"], tc: "TC", title_footnote: ["ABC"], transmitteddate: "XXX", unchangeddate: "XXX", unpublished: false, updateddate: "XXX", vote_endeddate: "XXX", vote_starteddate: "XXX"}
    OUTPUT

    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(", :", ",\n:"))
      .to be_equivalent_to output
  end

  it "processes default metadata, plenary; six official UN languages" do
    csdc = IsoDoc::UN::HtmlConvert.new({ toc: true })
    input = <<~"INPUT"
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title type="main" language="en" format="plain">Main Title</title>
        <title type="subtitle" language="en" format="plain">Subtitle</title>
        <docidentifier>1000(wd)</docidentifier>
        <contributor>
          <role type="author"/>
          <organization>
                <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
                <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
          </organization>
        </contributor>
        <language>en</language>
        <language>ru</language>
        <language>ar</language>
        <language>es</language>
        <language>fr</language>
        <language>zh</language>
        <script>Latn</script>
        <status><stage>working-draft</stage></status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
                <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
            <abbreviation>#{Metanorma::UN::ORGANIZATION_NAME_SHORT}</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>plenary</doctype>
        <editorialgroup>
          <committee type="A">TC</committee>
        </editorialgroup>
        <security>Client Confidential</security>
        <session>
        <number>3</number>
        <date>2001-01-01</date>
        <item-number>5</item-number>
        <item-number>6</item-number>
        <item-name>ABC</item-name>
        <item-name>DEF</item-name>
        <subitem-name>GHI</subitem-name>
        <subitem-name>JKL</subitem-name>
        <collaborator>WHO</collaborator>
        <id>ECE/WHO-UNECE-01</id>
        <distribution>public</distribution>
        </session>
        </ext>
      </bibdata>
      <sections/>
      </un-standard>
    INPUT

    output = <<~"OUTPUT"
{accesseddate: "XXX", adapteddate: "XXX", agency: "UN", announceddate: "XXX", bibdata: {id: "1000wd", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Main Title", type: "main", format: "plain"}, {language: "en", content: "Subtitle", type: "subtitle", format: "plain"}], docidentifier: [{content: "1000(wd)"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}, {role: [{type: "publisher"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}], language: ["en", "ru", "ar", "es", "fr", "zh"], script: ["Latn"], status: {stage: {content: "working-draft"}}, copyright: [{from: "2001", owner: [{organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}]}], ext: {doctype: {content: "plenary"}, editorialgroup: {committee: {type: "A", content: "TC"}}, security: {content: "Client Confidential"}, session: {number: {content: "3"}, date: {content: "2001-01-01"}, item_number: [{content: "5"}, {content: "6"}], item_name: [{content: "ABC"}, {content: "DEF"}], subitem_name: [{content: "GHI"}, {content: "JKL"}], collaborator: {content: "WHO"}, id: {content: "ECE/WHO-UNECE-01"}, distribution: {content: "public"}}}}, circulateddate: "XXX", confirmeddate: "XXX", copieddate: "XXX", correcteddate: "XXX", createddate: "XXX", docnumber: "1000(wd)", docsubtitle: "Subtitle", doctitle: "Main Title", doctype: "Plenary", doctype_display: "Plenary", docyear: "2001", formatted_docnumber: "1000(wd)", implementeddate: "XXX", issueddate: "XXX", lang: "en", logo: "#{File.join(logoloc, 'logo.jpg')}", obsoleteddate: "XXX", publisheddate: "XXX", publisher: "United Nations", receiveddate: "XXX", script: "Latn", session_collaborator: "WHO", session_date: "2001-01-01", session_id: "ECE/WHO-UNECE-01", session_id_head: "ECE", session_id_tail: "/WHO-UNECE-01", session_itemname: ["ABC", "DEF"], session_itemnumber: ["5", "6"], session_number: "Third", session_subitemname: ["GHI", "JKL"], stable_untildate: "XXX", stage: "Working Draft", stage_display: "Working Draft", tc: "TC", transmitteddate: "XXX", unchangeddate: "XXX", unpublished: false, updateddate: "XXX", vote_endeddate: "XXX", vote_starteddate: "XXX"}
    OUTPUT

    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(", :", ",\n:")).to be_equivalent_to output
  end

  it "processes section names without paragraph content" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative">
         <title>Summary</title>
         </abstract>
         <acknowledgements obligation="informative">
         <title>Acknowledgements</title>
         </acknowledgements>
         </preface>
         <sections>
         <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <clause id="D" obligation="normative">
           <title>Scope</title>
         </clause>

         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
           <clause id="O1" inline-header="false" obligation="normative">
           <title>Clause 4.2.1</title>
           <clause id="O11" inline-header="false" obligation="normative">
           <title>Clause 4 Leaf</title>
           </clause>
           </clause>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           <clause id="Q11" inline-header="false" obligation="normative">
           <title>Annex A Leaf</title>
           </clause>
           </clause>
         </clause>
         </annex>
         <annex id="U"  inline-header="false" obligation="normative">
         <title>Terminal annex</title>
         </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </un-standard>
    INPUT

    presxml = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <abstract obligation="informative" id="_" displayorder="1">
         <title id="_">Summary</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Summary</semx>
         </fmt-title>
      </abstract>
      <foreword obligation="informative" id="_" displayorder="2">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
      </foreword>
      <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
         <title id="_">Introduction</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Introduction</semx>
         </fmt-title>
         <clause id="C" inline-header="false" obligation="informative" semx-id="C">
            <title id="_">Introduction Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction Subsection</semx>
            </fmt-title>
         </clause>
      </introduction>
      <acknowledgements obligation="informative" id="_" displayorder="4">
         <title id="_">Acknowledgements</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Acknowledgements</semx>
         </fmt-title>
      </acknowledgements>
   </preface>
   <sections>
      <clause id="H" obligation="normative" semx-id="H" displayorder="5">
         <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <terms id="I" obligation="normative" semx-id="I">
            <title id="_">Normal Terms</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Normal Terms</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.A</fmt-xref-label>
            <term id="J" semx-id="J">
               <fmt-name id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
               </fmt-name>
               <fmt-xref-label>Clause I.A.1</fmt-xref-label>
               <preferred id="_">Term2</preferred>
            </term>
         </terms>
         <definitions id="K" semx-id="K">
            <title id="_">Symbols</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  B
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Symbols</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.B</fmt-xref-label>
            <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
            </dl>
         </definitions>
      </clause>
      <clause id="D" obligation="normative" semx-id="D" displayorder="6">
         <title id="_">Scope</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               II
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Scope</semx>
         </fmt-title>
         <fmt-xref-label>Clause II</fmt-xref-label>
      </clause>
      <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="7">
         <title id="_">Clause 4</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               III
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Clause 4</semx>
         </fmt-title>
         <fmt-xref-label>Clause III</fmt-xref-label>
         <clause id="N" inline-header="false" obligation="normative" semx-id="N">
            <title id="_">Introduction</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Introduction</semx>
            </fmt-title>
            <fmt-xref-label>Clause III.A</fmt-xref-label>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" semx-id="O">
            <title id="_">Clause 4.2</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  B
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Clause 4.2</semx>
            </fmt-title>
            <fmt-xref-label>Clause III.B</fmt-xref-label>
            <clause id="O1" inline-header="false" obligation="normative" semx-id="O1">
               <title id="_">Clause 4.2.1</title>
               <fmt-title depth="3" id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Clause 4.2.1</semx>
               </fmt-title>
               <fmt-xref-label>Clause III.B.1</fmt-xref-label>
               <clause id="O11" inline-header="false" obligation="normative" semx-id="O11">
                  <title id="_">Clause 4 Leaf</title>
                  <fmt-title depth="4" id="_">
                     <span class="fmt-caption-label">
                        I
                        <span class="fmt-clause-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Clause 4 Leaf</semx>
                  </fmt-title>
                  <fmt-xref-label>Clause III.B.1.I</fmt-xref-label>
               </clause>
            </clause>
         </clause>
      </clause>
   </sections>
   <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="I" displayorder="8">
      <title id="_">Annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex I</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex I</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex I</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Annex</semx>
      </variant-title>
      <clause id="Q" inline-header="false" obligation="normative" semx-id="Q">
         <title id="_">Annex A.1</title>
         <fmt-title depth="2" id="_">
            <span class="fmt-caption-label">
               1
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Annex A.1</semx>
         </fmt-title>
         <fmt-xref-label>Annex I.1</fmt-xref-label>
         <clause id="Q1" inline-header="false" obligation="normative" semx-id="Q1">
            <title id="_">Annex A.1a</title>
            <fmt-title depth="3" id="_">
               <span class="fmt-caption-label">
                  I
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Annex A.1a</semx>
            </fmt-title>
            <fmt-xref-label>Annex I.1.I</fmt-xref-label>
            <clause id="Q11" inline-header="false" obligation="normative" semx-id="Q11">
               <title id="_">Annex A Leaf</title>
               <fmt-title depth="4" id="_">
                  <span class="fmt-caption-label">
                     A
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Annex A Leaf</semx>
               </fmt-title>
               <fmt-xref-label>Annex I.1.I.A</fmt-xref-label>
            </clause>
         </clause>
      </clause>
   </annex>
   <annex id="U" inline-header="false" obligation="normative" semx-id="U" autonum="II" displayorder="9">
      <title id="_">Terminal annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex II</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Terminal annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex II</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex II</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Terminal annex</semx>
      </variant-title>
   </annex>
   <bibliography>
      <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="10">
         <title id="_">Normative References</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Normative References</semx>
         </fmt-title>
      </references>
      <clause id="S" obligation="informative" semx-id="S" displayorder="11">
         <title id="_">Bibliography</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Bibliography</semx>
         </fmt-title>
         <references id="T" obligation="informative" normative="false" semx-id="T">
            <title id="_">Bibliography Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Bibliography Subsection</semx>
            </fmt-title>
         </references>
      </clause>
   </bibliography>
</un-standard>
    OUTPUT

    html = Xml::C14n.format(<<~"OUTPUT")
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <br/>
         <div id="_">
            <h1 class="AbstractTitle">
            Summary
         </h1>
         </div>
         <br/>
         <div id="_">
            <h1 class="ForewordTitle">
            Foreword
         </h1>
         </div>
         <br/>
         <div class="Section3" id="B">
            <h1 class="IntroTitle">
            Introduction
         </h1>
            <div id="C">
               <h2>
               Introduction Subsection
            </h2>
            </div>
         </div>
         <br/>
         <div class="Section3" id="_">
            <h1 class="IntroTitle">
            Acknowledgements
         </h1>
         </div>
         <div id="H">
            <h1>
               I
               <span class="fmt-clause-delim">.</span>
                 Terms, Definitions, Symbols and Abbreviated Terms
            </h1>
            <div id="I">
               <h2>
                  A
                  <span class="fmt-clause-delim">.</span>
                    Normal Terms
               </h2>
               <p class="TermNum" id="J">
                  1
                  <span class="fmt-clause-delim">.</span>
               </p>
            </div>
            <div id="K">
               <h2>
                  B
                  <span class="fmt-clause-delim">.</span>
                    Symbols
               </h2>
               <div class="figdl">
                  <dl>
                     <dt>
                        <p>Symbol</p>
                     </dt>
                     <dd>Definition</dd>
                  </dl>
               </div>
            </div>
         </div>
         <div id="D">
            <h1>
               II
               <span class="fmt-clause-delim">.</span>
                 Scope
            </h1>
         </div>
         <div id="M">
            <h1>
               III
               <span class="fmt-clause-delim">.</span>
                 Clause 4
            </h1>
            <div id="N">
               <h2>
                  A
                  <span class="fmt-clause-delim">.</span>
                    Introduction
               </h2>
            </div>
            <div id="O">
               <h2>
                  B
                  <span class="fmt-clause-delim">.</span>
                    Clause 4.2
               </h2>
               <div id="O1">
                  <h3>
                     1
                     <span class="fmt-clause-delim">.</span>
                       Clause 4.2.1
                  </h3>
                  <div id="O11">
                     <h4>
                        I
                        <span class="fmt-clause-delim">.</span>
                          Clause 4 Leaf
                     </h4>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="P" class="Section3">
            <h1 class="Annex">
               <b>Annex I</b>
               <br/>
               <br/>
               <b>Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex I

             

         Annex
      </p>
            <div id="Q">
               <h2>
                  1
                  <span class="fmt-clause-delim">.</span>
                    Annex A.1
               </h2>
               <div id="Q1">
                  <h3>
                     I
                     <span class="fmt-clause-delim">.</span>
                       Annex A.1a
                  </h3>
                  <div id="Q11">
                     <h4>
                        A
                        <span class="fmt-clause-delim">.</span>
                          Annex A Leaf
                     </h4>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="U" class="Section3">
            <h1 class="Annex">
               <b>Annex II</b>
               <br/>
               <br/>
               <b>Terminal annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex II

             

         Terminal annex
      </p>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Normative References
         </h1>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Bibliography
         </h1>
            <div>
               <h2 class="Section3">
               Bibliography Subsection
            </h2>
            </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert.new({})
      .convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes unnumbered section names without paragraph content" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative" unnumbered="true">
           <title>Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative"><title>Summary</title>
         </abstract>
         <acknowledgements obligation="informative">
         <title>Acknowledgements</title>
         </acknowledgements>
         </preface>
         <sections>
         <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <definitions id="K" unnumbered="true">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <clause id="D" obligation="normative">
           <title>Scope</title>
         </clause>

         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative" unnumbered="true">
           <title>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" unnumbered="true">
           <title>Clause 4.2</title>
           <clause id="O1" inline-header="false" obligation="normative" unnumbered="true">
           <title>Clause 4.2.1</title>
           <clause id="O11" inline-header="false" obligation="normative">
           <title>Clause 4 Leaf</title>
           </clause>
           <clause id="O12" inline-header="false" obligation="normative" unnumbered="true">
           <title>Clause 4 Leaf 2</title>
           </clause>
           </clause>
         </clause>


         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative" unnumbered="true">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative" unnumbered="true">
           <title>Annex A.1a</title>
           <clause id="Q11" inline-header="false" obligation="normative" unnumbered="true">
           <title>Annex A Leaf</title>
           </clause>
           </clause>
         </clause>
         </annex>
         <annex id="U"  inline-header="false" obligation="normative">
         <title>Terminal annex</title>
         </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </un-standard>
    INPUT

    presxml = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <abstract obligation="informative" id="_" displayorder="1">
         <title id="_">Summary</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Summary</semx>
         </fmt-title>
      </abstract>
      <foreword obligation="informative" id="_" displayorder="2">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
      </foreword>
      <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
         <title id="_">Introduction</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Introduction</semx>
         </fmt-title>
         <clause id="C" inline-header="false" obligation="informative" unnumbered="true" semx-id="C">
            <title id="_">Introduction Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction Subsection</semx>
            </fmt-title>
         </clause>
      </introduction>
      <acknowledgements obligation="informative" id="_" displayorder="4">
         <title id="_">Acknowledgements</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Acknowledgements</semx>
         </fmt-title>
      </acknowledgements>
   </preface>
   <sections>
      <clause id="H" obligation="normative" semx-id="H" displayorder="5">
         <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <definitions id="K" unnumbered="true" semx-id="K">
            <title id="_">Symbols</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Symbols</semx>
            </fmt-title>
            <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
            </dl>
         </definitions>
      </clause>
      <clause id="D" obligation="normative" semx-id="D" displayorder="6">
         <title id="_">Scope</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               II
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Scope</semx>
         </fmt-title>
         <fmt-xref-label>Clause II</fmt-xref-label>
      </clause>
      <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="7">
         <title id="_">Clause 4</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               III
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Clause 4</semx>
         </fmt-title>
         <fmt-xref-label>Clause III</fmt-xref-label>
         <clause id="N" inline-header="false" obligation="normative" unnumbered="true" semx-id="N">
            <title id="_">Introduction</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction</semx>
            </fmt-title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" unnumbered="true" semx-id="O">
            <title id="_">Clause 4.2</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Clause 4.2</semx>
            </fmt-title>
            <clause id="O1" inline-header="false" obligation="normative" unnumbered="true" semx-id="O1">
               <title id="_">Clause 4.2.1</title>
               <fmt-title depth="3" id="_">
                  <semx element="title" source="_">Clause 4.2.1</semx>
               </fmt-title>
               <clause id="O11" inline-header="false" obligation="normative" semx-id="O11">
                  <title id="_">Clause 4 Leaf</title>
                  <fmt-title depth="4" id="_">
                     <semx element="title" source="_">Clause 4 Leaf</semx>
                  </fmt-title>
               </clause>
               <clause id="O12" inline-header="false" obligation="normative" unnumbered="true" semx-id="O12">
                  <title id="_">Clause 4 Leaf 2</title>
                  <fmt-title depth="4" id="_">
                     <semx element="title" source="_">Clause 4 Leaf 2</semx>
                  </fmt-title>
               </clause>
            </clause>
         </clause>
      </clause>
      <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="I" displayorder="8">
         <title id="_">Annex</title>
         <fmt-title id="_">
            <span class="fmt-caption-label">
               <strong>Annex I</strong>
            </span>
            <span class="fmt-caption-delim">
               <br/>
               <br/>
            </span>
            <semx element="title" source="_">
               <strong>Annex</strong>
            </semx>
         </fmt-title>
         <fmt-xref-label>Annex I</fmt-xref-label>
         <variant-title type="toc">
            <span class="fmt-caption-label">Annex I</span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Annex</semx>
         </variant-title>
         <clause id="Q" inline-header="false" obligation="normative" unnumbered="true" semx-id="Q">
            <title id="_">Annex A.1</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Annex A.1</semx>
            </fmt-title>
            <clause id="Q1" inline-header="false" obligation="normative" unnumbered="true" semx-id="Q1">
               <title id="_">Annex A.1a</title>
               <fmt-title depth="3" id="_">
                  <semx element="title" source="_">Annex A.1a</semx>
               </fmt-title>
               <clause id="Q11" inline-header="false" obligation="normative" unnumbered="true" semx-id="Q11">
                  <title id="_">Annex A Leaf</title>
                  <fmt-title depth="4" id="_">
                     <semx element="title" source="_">Annex A Leaf</semx>
                  </fmt-title>
               </clause>
            </clause>
         </clause>
      </annex>
      <annex id="U" inline-header="false" obligation="normative" semx-id="U" autonum="II" displayorder="9">
         <title id="_">Terminal annex</title>
         <fmt-title id="_">
            <span class="fmt-caption-label">
               <strong>Annex II</strong>
            </span>
            <span class="fmt-caption-delim">
               <br/>
               <br/>
            </span>
            <semx element="title" source="_">
               <strong>Terminal annex</strong>
            </semx>
         </fmt-title>
         <fmt-xref-label>Annex II</fmt-xref-label>
         <variant-title type="toc">
            <span class="fmt-caption-label">Annex II</span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Terminal annex</semx>
         </variant-title>
      </annex>
      <bibliography>
         <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="10">
            <title id="_">Normative References</title>
            <fmt-title depth="1" id="_">
               <semx element="title" source="_">Normative References</semx>
            </fmt-title>
         </references>
         <clause id="S" obligation="informative" semx-id="S" displayorder="11">
            <title id="_">Bibliography</title>
            <fmt-title depth="1" id="_">
               <semx element="title" source="_">Bibliography</semx>
            </fmt-title>
            <references id="T" obligation="informative" normative="false" semx-id="T">
               <title id="_">Bibliography Subsection</title>
               <fmt-title depth="2" id="_">
                  <semx element="title" source="_">Bibliography Subsection</semx>
               </fmt-title>
            </references>
         </clause>
      </bibliography>
   </sections>
</un-standard>
    OUTPUT

    html = <<~"OUTPUT"
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <br/>
         <div id="_">
            <h1 class="AbstractTitle">
            Summary
         </h1>
         </div>
         <br/>
         <div id="_">
            <h1 class="ForewordTitle">
            Foreword
         </h1>
         </div>
         <br/>
         <div class="Section3" id="B">
            <h1 class="IntroTitle">
            Introduction
         </h1>
            <div id="C">
               <h2>
               Introduction Subsection
            </h2>
            </div>
         </div>
         <br/>
         <div class="Section3" id="_">
            <h1 class="IntroTitle">
            Acknowledgements
         </h1>
         </div>
         <div id="H">
            <h1>
               I
               <span class="fmt-clause-delim">.</span>
                 Terms, Definitions, Symbols and Abbreviated Terms
            </h1>
            <div id="K">
               <h2>
               Symbols
            </h2>
               <div class="figdl">
                  <dl>
                     <dt>
                        <p>Symbol</p>
                     </dt>
                     <dd>Definition</dd>
                  </dl>
               </div>
            </div>
         </div>
         <div id="D">
            <h1>
               II
               <span class="fmt-clause-delim">.</span>
                 Scope
            </h1>
         </div>
         <div id="M">
            <h1>
               III
               <span class="fmt-clause-delim">.</span>
                 Clause 4
            </h1>
            <div id="N">
               <h2>
               Introduction
            </h2>
            </div>
            <div id="O">
               <h2>
               Clause 4.2
            </h2>
               <div id="O1">
                  <h3>
                  Clause 4.2.1
               </h3>
                  <div id="O11">
                     <h4>
                     Clause 4 Leaf
                  </h4>
                  </div>
                  <div id="O12">
                     <h4>
                     Clause 4 Leaf 2
                  </h4>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="P" class="Section3">
            <h1 class="Annex">
               <b>Annex I</b>
               <br/>
               <br/>
               <b>Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
            Annex I

                

            Annex
         </p>
            <div id="Q">
               <h2>
               Annex A.1
            </h2>
               <div id="Q1">
                  <h3>
                  Annex A.1a
               </h3>
                  <div id="Q11">
                     <h4>
                     Annex A Leaf
                  </h4>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="U" class="Section3">
            <h1 class="Annex">
               <b>Annex II</b>
               <br/>
               <br/>
               <b>Terminal annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
            Annex II

                

            Terminal annex
         </p>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
               Normative References
            </h1>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
               Bibliography
            </h1>
            <div>
               <h2 class="Section3">
                  Bibliography Subsection
               </h2>
            </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert.new({})
      .convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes section names with paragraph content" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
           <p id="A1">Text</p>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
           <p id="A2">Text</p>
         </clause>
         </introduction>
         <abstract obligation="informative">
         <title>Summary</title>
           <p id="A3">Text</p>
         </abstract>
         </preface>
         <sections>
         <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <clause id="D" obligation="normative" type="scope">
           <title>Scope</title>
           <p id="A4">Text</p>
         </clause>

         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
           <p id="A5">Text</p>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
           <clause id="O1" inline-header="false" obligation="normative">
           <title>Clause 4.2.1</title>
           <clause id="O11" inline-header="false" obligation="normative">
           <title>Clause 4 Leaf</title>
           <p id="A6">Text</p>
           </clause>
           </clause>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           <clause id="Q11" inline-header="false" obligation="normative">
           <title>Annex A Leaf</title>
           <p id="A7">Text</p>
           </clause>
           </clause>
         </clause>
         </annex>
         <annex id="U"  inline-header="false" obligation="normative">
         <title>Terminal annex</title>
           <p id="A8">Text</p>
         </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </un-standard>
    INPUT

    presxml = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <abstract obligation="informative" id="_" displayorder="1">
         <title id="_">Summary</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Summary</semx>
         </fmt-title>
         <p id="A3" semx-id="A3">Text</p>
      </abstract>
      <foreword obligation="informative" id="_" displayorder="2">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
         <p id="A1" semx-id="A1">Text</p>
      </foreword>
      <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
         <title id="_">Introduction</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Introduction</semx>
         </fmt-title>
         <clause id="C" inline-header="false" obligation="informative" semx-id="C">
            <title id="_">Introduction Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction Subsection</semx>
            </fmt-title>
            <p id="A2" semx-id="A2">Text</p>
         </clause>
      </introduction>
   </preface>
   <sections>
      <clause id="H" obligation="normative" semx-id="H" displayorder="4">
         <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <terms id="I" obligation="normative" semx-id="I">
            <title id="_">Normal Terms</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Normal Terms</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.A</fmt-xref-label>
            <term id="J" semx-id="J">
               <fmt-name id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
               </fmt-name>
               <fmt-xref-label>Clause I.A.1</fmt-xref-label>
               <preferred id="_">Term2</preferred>
            </term>
         </terms>
         <definitions id="K" semx-id="K">
            <title id="_">Symbols</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  B
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Symbols</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.B</fmt-xref-label>
            <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
            </dl>
         </definitions>
      </clause>
      <clause id="D" obligation="normative" type="scope" semx-id="D" displayorder="5">
         <title id="_">Scope</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               1
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Scope</semx>
         </fmt-title>
         <fmt-xref-label>paragraph 1</fmt-xref-label>
         <p id="A4" semx-id="A4">Text</p>
      </clause>
      <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="6">
         <title id="_">Clause 4</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               II
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Clause 4</semx>
         </fmt-title>
         <fmt-xref-label>Clause II</fmt-xref-label>
         <clause id="N" inline-header="false" obligation="normative" semx-id="N">
            <title id="_">Introduction</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  2
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Introduction</semx>
            </fmt-title>
            <fmt-xref-label>paragraph 2</fmt-xref-label>
            <p id="A5" semx-id="A5">Text</p>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" semx-id="O">
            <title id="_">Clause 4.2</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Clause 4.2</semx>
            </fmt-title>
            <fmt-xref-label>Clause II.A</fmt-xref-label>
            <clause id="O1" inline-header="false" obligation="normative" semx-id="O1">
               <title id="_">Clause 4.2.1</title>
               <fmt-title depth="3" id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Clause 4.2.1</semx>
               </fmt-title>
               <fmt-xref-label>Clause II.A.1</fmt-xref-label>
               <clause id="O11" inline-header="false" obligation="normative" semx-id="O11">
                  <title id="_">Clause 4 Leaf</title>
                  <fmt-title depth="4" id="_">
                     <span class="fmt-caption-label">
                        3
                        <span class="fmt-clause-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Clause 4 Leaf</semx>
                  </fmt-title>
                  <fmt-xref-label>paragraph 3</fmt-xref-label>
                  <p id="A6" semx-id="A6">Text</p>
               </clause>
            </clause>
         </clause>
      </clause>
   </sections>
   <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="I" displayorder="7">
      <title id="_">Annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex I</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex I</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex I</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Annex</semx>
      </variant-title>
      <clause id="Q" inline-header="false" obligation="normative" semx-id="Q">
         <title id="_">Annex A.1</title>
         <fmt-title depth="2" id="_">
            <span class="fmt-caption-label">
               1
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Annex A.1</semx>
         </fmt-title>
         <fmt-xref-label>Annex I.1</fmt-xref-label>
         <clause id="Q1" inline-header="false" obligation="normative" semx-id="Q1">
            <title id="_">Annex A.1a</title>
            <fmt-title depth="3" id="_">
               <span class="fmt-caption-label">
                  I
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Annex A.1a</semx>
            </fmt-title>
            <fmt-xref-label>Annex I.1.I</fmt-xref-label>
            <clause id="Q11" inline-header="false" obligation="normative" semx-id="Q11">
               <title id="_">Annex A Leaf</title>
               <fmt-title depth="4" id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Annex A Leaf</semx>
               </fmt-title>
               <fmt-xref-label>paragraph I.1.I.A.1</fmt-xref-label>
               <p id="A7" semx-id="A7">Text</p>
            </clause>
         </clause>
      </clause>
   </annex>
   <annex id="U" inline-header="false" obligation="normative" semx-id="U" autonum="II" displayorder="8">
      <title id="_">Terminal annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex II</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Terminal annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex II</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex II</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Terminal annex</semx>
      </variant-title>
      <p id="A8" semx-id="A8">Text</p>
   </annex>
   <bibliography>
      <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="9">
         <title id="_">Normative References</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Normative References</semx>
         </fmt-title>
      </references>
      <clause id="S" obligation="informative" semx-id="S" displayorder="10">
         <title id="_">Bibliography</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Bibliography</semx>
         </fmt-title>
         <references id="T" obligation="informative" normative="false" semx-id="T">
            <title id="_">Bibliography Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Bibliography Subsection</semx>
            </fmt-title>
         </references>
      </clause>
   </bibliography>
</un-standard>
    OUTPUT

    html = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <br/>
         <div id="_">
            <h1 class="AbstractTitle">
            Summary
         </h1>
            <p id="A3">Text</p>
         </div>
         <br/>
         <div id="_">
            <h1 class="ForewordTitle">
            Foreword
         </h1>
            <p id="A1">Text</p>
         </div>
         <br/>
         <div class="Section3" id="B">
            <h1 class="IntroTitle">
            Introduction
         </h1>
            <div id="C">
               <h2>
               Introduction Subsection
            </h2>
               <p id="A2">Text</p>
            </div>
         </div>
         <div id="H">
            <h1>
               I
               <span class="fmt-clause-delim">.</span>
                 Terms, Definitions, Symbols and Abbreviated Terms
            </h1>
            <div id="I">
               <h2>
                  A
                  <span class="fmt-clause-delim">.</span>
                    Normal Terms
               </h2>
               <p class="TermNum" id="J">
                  1
                  <span class="fmt-clause-delim">.</span>
               </p>
            </div>
            <div id="K">
               <h2>
                  B
                  <span class="fmt-clause-delim">.</span>
                    Symbols
               </h2>
               <div class="figdl">
                  <dl>
                     <dt>
                        <p>Symbol</p>
                     </dt>
                     <dd>Definition</dd>
                  </dl>
               </div>
            </div>
         </div>
         <div id="D">
            <h1>
               1
               <span class="fmt-clause-delim">.</span>
                 Scope
            </h1>
            <p id="A4">Text</p>
         </div>
         <div id="M">
            <h1>
               II
               <span class="fmt-clause-delim">.</span>
                 Clause 4
            </h1>
            <div id="N">
               <h2>
                  2
                  <span class="fmt-clause-delim">.</span>
                    Introduction
               </h2>
               <p id="A5">Text</p>
            </div>
            <div id="O">
               <h2>
                  A
                  <span class="fmt-clause-delim">.</span>
                    Clause 4.2
               </h2>
               <div id="O1">
                  <h3>
                     1
                     <span class="fmt-clause-delim">.</span>
                       Clause 4.2.1
                  </h3>
                  <div id="O11">
                     <h4>
                        3
                        <span class="fmt-clause-delim">.</span>
                          Clause 4 Leaf
                     </h4>
                     <p id="A6">Text</p>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="P" class="Section3">
            <h1 class="Annex">
               <b>Annex I</b>
               <br/>
               <br/>
               <b>Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex I

             

         Annex
      </p>
            <div id="Q">
               <h2>
                  1
                  <span class="fmt-clause-delim">.</span>
                    Annex A.1
               </h2>
               <div id="Q1">
                  <h3>
                     I
                     <span class="fmt-clause-delim">.</span>
                       Annex A.1a
                  </h3>
                  <div id="Q11">
                     <h4>
                        1
                        <span class="fmt-clause-delim">.</span>
                          Annex A Leaf
                     </h4>
                     <p id="A7">Text</p>
                  </div>
               </div>
            </div>
         </div>
         <br/>
         <div id="U" class="Section3">
            <h1 class="Annex">
               <b>Annex II</b>
               <br/>
               <br/>
               <b>Terminal annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex II

             

         Terminal annex
      </p>
            <p id="A8">Text</p>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Normative References
         </h1>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Bibliography
         </h1>
            <div>
               <h2 class="Section3">
               Bibliography Subsection
            </h2>
            </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT

    word = Xml::C14n.format(<<~OUTPUT)
<?xml version="1.0" encoding="UTF-8"?>


<div>
   <div class="WordSection2">
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="_">
         <h1 class="AbstractTitle">
            Summary
         </h1>
         <p id="A3">Text</p>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="_">
         <h1 class="ForewordTitle">
            Foreword
         </h1>
         <p id="A1">Text</p>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div class="Section3" id="B">
         <h1 class="IntroTitle">
            Introduction
         </h1>
         <div id="C">
            <h2>
               Introduction Subsection
            </h2>
            <p id="A2">Text</p>
         </div>
      </div>
      <p> </p>
   </div>
   <p class="section-break">
      <br clear="all" class="section"/>
   </p>
   <div class="WordSection3">
      <div id="H">
         <h1>
            I
            <span class="fmt-clause-delim">.</span>
            <span style="mso-tab-count:1">  </span>
            Terms, Definitions, Symbols and Abbreviated Terms
         </h1>
         <div id="I">
            <h2>
               A
               <span class="fmt-clause-delim">.</span>
               <span style="mso-tab-count:1">  </span>
               Normal Terms
            </h2>
            <p class="TermNum" id="J">
               1
               <span class="fmt-clause-delim">.</span>
            </p>
         </div>
         <div id="K">
            <h2>
               B
               <span class="fmt-clause-delim">.</span>
               <span style="mso-tab-count:1">  </span>
               Symbols
            </h2>
            <div align="left">
               <table class="dl">
                  <tr>
                     <td valign="top" align="left">
                        <p align="left" style="margin-left:0pt;text-align:left;">Symbol</p>
                     </td>
                     <td valign="top">Definition</td>
                  </tr>
               </table>
            </div>
         </div>
      </div>
      <div id="D">
         <h1>
            1
            <span class="fmt-clause-delim">.</span>
            <span style="mso-tab-count:1">  </span>
            Scope
         </h1>
         <p id="A4">Text</p>
      </div>
      <div id="M">
         <h1>
            II
            <span class="fmt-clause-delim">.</span>
            <span style="mso-tab-count:1">  </span>
            Clause 4
         </h1>
         <div id="N">
            <h2>
               2
               <span class="fmt-clause-delim">.</span>
               <span style="mso-tab-count:1">  </span>
               Introduction
            </h2>
            <p id="A5">Text</p>
         </div>
         <div id="O">
            <h2>
               A
               <span class="fmt-clause-delim">.</span>
               <span style="mso-tab-count:1">  </span>
               Clause 4.2
            </h2>
            <div id="O1">
               <h3>
                  1
                  <span class="fmt-clause-delim">.</span>
                  <span style="mso-tab-count:1">  </span>
                  Clause 4.2.1
               </h3>
               <div id="O11">
                  <h4>
                     3
                     <span class="fmt-clause-delim">.</span>
                     <span style="mso-tab-count:1">  </span>
                     Clause 4 Leaf
                  </h4>
                  <p id="A6">Text</p>
               </div>
            </div>
         </div>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="P" class="Section3">
         <h1 class="Annex">
            <b>Annex I</b>
            <br/>
            <br/>
            <b>Annex</b>
         </h1>
         <p style="display:none;" class="variant-title-toc">
            Annex I
            <span style="mso-tab-count:1">  </span>
            Annex
         </p>
         <div id="Q">
            <h2>
               1
               <span class="fmt-clause-delim">.</span>
               <span style="mso-tab-count:1">  </span>
               Annex A.1
            </h2>
            <div id="Q1">
               <h3>
                  I
                  <span class="fmt-clause-delim">.</span>
                  <span style="mso-tab-count:1">  </span>
                  Annex A.1a
               </h3>
               <div id="Q11">
                  <h4>
                     1
                     <span class="fmt-clause-delim">.</span>
                     <span style="mso-tab-count:1">  </span>
                     Annex A Leaf
                  </h4>
                  <p id="A7">Text</p>
               </div>
            </div>
         </div>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="U" class="Section3">
         <h1 class="Annex">
            <b>Annex II</b>
            <br/>
            <br/>
            <b>Terminal annex</b>
         </h1>
         <p style="display:none;" class="variant-title-toc">
            Annex II
            <span style="mso-tab-count:1">  </span>
            Terminal annex
         </p>
         <p id="A8">Text</p>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div>
         <h1 class="Section3">
            Normative References
         </h1>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div>
         <h1 class="Section3">
            Bibliography
         </h1>
         <div>
            <h2 class="Section3">
               Bibliography Subsection
            </h2>
         </div>
      </div>
   </div>
</div>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert.new({})
      .convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(IsoDoc::UN::WordConvert.new({})
       .convert("test", presxml, true)
       .sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">')
       .sub(%r{<v:line.*$}m, "</div></div>")))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes cross-references to section names" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword id="A" obligation="informative">
           <title>Foreword</title>
           <p>
           <xref target="A"/>
           <xref target="B"/>
           <xref target="C"/>
           <xref target="AA"/>
           <xref target="H"/>
           <xref target="I"/>
           <xref target="J"/>
           <xref target="K"/>
           <xref target="D"/>
           <xref target="M"/>
           <xref target="N"/>
           <xref target="O"/>
           <xref target="O1"/>
           <xref target="O11"/>
           <xref target="P"/>
           <xref target="Q"/>
           <xref target="Q1"/>
           <xref target="Q11"/>
           <xref target="U"/>
           <xref target="R"/>
           <xref target="S"/>
           <xref target="T"/>
          </p>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
           <p id="X1"/>
           <p id="X2"/>
         </clause>
         </introduction>
         <abstract id="AA" obligation="informative">
           <p id="X3"/>
           <p id="X4"/>
         </abstract>
         </preface>
         <sections>
         <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <clause id="D" obligation="normative">
           <title>Scope</title>
           <p id="X5"/>
           <p id="X6"/>
         </clause>

         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><p id="X6a"/><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
           <p id="X7"/>
           <p id="X8"/>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
           <p id="X9"/>
           <p id="X10"/>
           <clause id="O1" inline-header="false" obligation="normative">
           <title>Clause 4.2.1</title>
           <p id="X11"/>
           <p id="X12"/>
           <clause id="O11" inline-header="false" obligation="normative">
           <title>Clause 4 Leaf</title>
           <p id="X13"/>
           <p id="X14"/>
           </clause>
           </clause>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <p id="X15"/>
           <p id="X16"/>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <p id="X17"/>
           <p id="X18"/>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           <p id="X19"/>
           <p id="X20"/>
           <clause id="Q11" inline-header="false" obligation="normative">
           <title>Annex A Leaf</title>
           <p id="X21"/>
           <p id="X22"/>
           </clause>
           </clause>
         </clause>
         </annex>
         <annex id="U"  inline-header="false" obligation="normative">
         <title>Terminal annex</title>
           <p id="X23"/>
           <p id="X24"/>
         </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </un-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <abstract id="AA" obligation="informative" semx-id="AA" displayorder="1">
         <p id="X3" semx-id="X3"/>
         <p id="X4" semx-id="X4"/>
      </abstract>
      <foreword id="A" obligation="informative" semx-id="A" displayorder="2">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
         <p>
            <xref target="A" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="A">
                  <semx element="foreword" source="A">Foreword</semx>
               </fmt-xref>
            </semx>
            <xref target="B" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="B">
                  <semx element="introduction" source="B">Introduction</semx>
               </fmt-xref>
            </semx>
            <xref target="C" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="C">
                  <semx element="clause" source="C">Introduction Subsection</semx>
               </fmt-xref>
            </semx>
            <xref target="AA" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="AA">
                  <semx element="abstract" source="AA">Summary</semx>
               </fmt-xref>
            </semx>
            <xref target="H" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="H">Clause I</fmt-xref>
            </semx>
            <xref target="I" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="I">Clause I.A</fmt-xref>
            </semx>
            <xref target="J" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="J">Clause I.A.1</fmt-xref>
            </semx>
            <xref target="K" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="K">Clause I.B</fmt-xref>
            </semx>
            <xref target="D" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="D">paragraph 1</fmt-xref>
            </semx>
            <xref target="M" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="M">Clause II</fmt-xref>
            </semx>
            <xref target="N" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="N">paragraph 2</fmt-xref>
            </semx>
            <xref target="O" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="O">Clause II.A</fmt-xref>
            </semx>
            <xref target="O1" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="O1">Clause II.A.1</fmt-xref>
            </semx>
            <xref target="O11" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="O11">paragraph 3</fmt-xref>
            </semx>
            <xref target="P" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="P">Annex I</fmt-xref>
            </semx>
            <xref target="Q" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="Q">Annex I.1</fmt-xref>
            </semx>
            <xref target="Q1" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="Q1">Annex I.1.I</fmt-xref>
            </semx>
            <xref target="Q11" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="Q11">paragraph I.1.I.A.1</fmt-xref>
            </semx>
            <xref target="U" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="U">Annex II</fmt-xref>
            </semx>
            <xref target="R" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="R">
                  <semx element="references" source="R">Normative References</semx>
               </fmt-xref>
            </semx>
            <xref target="S" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="S">
                  <semx element="clause" source="S">Bibliography</semx>
               </fmt-xref>
            </semx>
            <xref target="T" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="T">
                  <semx element="references" source="T">Bibliography Subsection</semx>
               </fmt-xref>
            </semx>
         </p>
      </foreword>
      <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
         <title id="_">Introduction</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Introduction</semx>
         </fmt-title>
         <clause id="C" inline-header="false" obligation="informative" semx-id="C">
            <title id="_">Introduction Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction Subsection</semx>
            </fmt-title>
            <p id="X1" semx-id="X1"/>
            <p id="X2" semx-id="X2"/>
         </clause>
      </introduction>
   </preface>
   <sections>
      <clause id="H" obligation="normative" semx-id="H" displayorder="4">
         <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <terms id="I" obligation="normative" semx-id="I">
            <title id="_">Normal Terms</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Normal Terms</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.A</fmt-xref-label>
            <term id="J" semx-id="J">
               <fmt-name id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
               </fmt-name>
               <fmt-xref-label>Clause I.A.1</fmt-xref-label>
               <preferred id="_">Term2</preferred>
            </term>
         </terms>
         <definitions id="K" semx-id="K">
            <title id="_">Symbols</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  B
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Symbols</semx>
            </fmt-title>
            <fmt-xref-label>Clause I.B</fmt-xref-label>
            <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
            </dl>
         </definitions>
      </clause>
      <clause id="D" obligation="normative" semx-id="D" displayorder="5">
         <title id="_">Scope</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               1
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Scope</semx>
         </fmt-title>
         <fmt-xref-label>paragraph 1</fmt-xref-label>
         <p id="X5" semx-id="X5"/>
         <p id="X6" semx-id="X6"/>
      </clause>
      <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="6">
         <title id="_">Clause 4</title>
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               II
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Clause 4</semx>
         </fmt-title>
         <fmt-xref-label>Clause II</fmt-xref-label>
         <p id="X6a" semx-id="X6a"/>
         <clause id="N" inline-header="false" obligation="normative" semx-id="N">
            <title id="_">Introduction</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  2
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Introduction</semx>
            </fmt-title>
            <fmt-xref-label>paragraph 2</fmt-xref-label>
            <p id="X7" semx-id="X7"/>
            <p id="X8" semx-id="X8"/>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" semx-id="O">
            <title id="_">Clause 4.2</title>
            <fmt-title depth="2" id="_">
               <span class="fmt-caption-label">
                  A
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Clause 4.2</semx>
            </fmt-title>
            <fmt-xref-label>Clause II.A</fmt-xref-label>
            <p id="X9" semx-id="X9"/>
            <p id="X10" semx-id="X10"/>
            <clause id="O1" inline-header="false" obligation="normative" semx-id="O1">
               <title id="_">Clause 4.2.1</title>
               <fmt-title depth="3" id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Clause 4.2.1</semx>
               </fmt-title>
               <fmt-xref-label>Clause II.A.1</fmt-xref-label>
               <p id="X11" semx-id="X11"/>
               <p id="X12" semx-id="X12"/>
               <clause id="O11" inline-header="false" obligation="normative" semx-id="O11">
                  <title id="_">Clause 4 Leaf</title>
                  <fmt-title depth="4" id="_">
                     <span class="fmt-caption-label">
                        3
                        <span class="fmt-clause-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Clause 4 Leaf</semx>
                  </fmt-title>
                  <fmt-xref-label>paragraph 3</fmt-xref-label>
                  <p id="X13" semx-id="X13"/>
                  <p id="X14" semx-id="X14"/>
               </clause>
            </clause>
         </clause>
      </clause>
   </sections>
   <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="I" displayorder="7">
      <title id="_">Annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex I</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex I</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex I</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Annex</semx>
      </variant-title>
      <p id="X15" semx-id="X15"/>
      <p id="X16" semx-id="X16"/>
      <clause id="Q" inline-header="false" obligation="normative" semx-id="Q">
         <title id="_">Annex A.1</title>
         <fmt-title depth="2" id="_">
            <span class="fmt-caption-label">
               1
               <span class="fmt-clause-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Annex A.1</semx>
         </fmt-title>
         <fmt-xref-label>Annex I.1</fmt-xref-label>
         <p id="X17" semx-id="X17"/>
         <p id="X18" semx-id="X18"/>
         <clause id="Q1" inline-header="false" obligation="normative" semx-id="Q1">
            <title id="_">Annex A.1a</title>
            <fmt-title depth="3" id="_">
               <span class="fmt-caption-label">
                  I
                  <span class="fmt-clause-delim">.</span>
               </span>
               <span class="fmt-caption-delim">
                  <tab/>
               </span>
               <semx element="title" source="_">Annex A.1a</semx>
            </fmt-title>
            <fmt-xref-label>Annex I.1.I</fmt-xref-label>
            <p id="X19" semx-id="X19"/>
            <p id="X20" semx-id="X20"/>
            <clause id="Q11" inline-header="false" obligation="normative" semx-id="Q11">
               <title id="_">Annex A Leaf</title>
               <fmt-title depth="4" id="_">
                  <span class="fmt-caption-label">
                     1
                     <span class="fmt-clause-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Annex A Leaf</semx>
               </fmt-title>
               <fmt-xref-label>paragraph I.1.I.A.1</fmt-xref-label>
               <p id="X21" semx-id="X21"/>
               <p id="X22" semx-id="X22"/>
            </clause>
         </clause>
      </clause>
   </annex>
   <annex id="U" inline-header="false" obligation="normative" semx-id="U" autonum="II" displayorder="8">
      <title id="_">Terminal annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex II</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Terminal annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex II</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex II</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Terminal annex</semx>
      </variant-title>
      <p id="X23" semx-id="X23"/>
      <p id="X24" semx-id="X24"/>
   </annex>
   <bibliography>
      <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="9">
         <title id="_">Normative References</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Normative References</semx>
         </fmt-title>
      </references>
      <clause id="S" obligation="informative" semx-id="S" displayorder="10">
         <title id="_">Bibliography</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Bibliography</semx>
         </fmt-title>
         <references id="T" obligation="informative" normative="false" semx-id="T">
            <title id="_">Bibliography Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Bibliography Subsection</semx>
            </fmt-title>
         </references>
      </clause>
   </bibliography>
</un-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes section names, suppressing section numbering" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
           <p id="A">This is a preamble</p>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative">
         <title>Summary</title>
         <p id="AA">This is an abstract</p>
         </abstract>
         <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
          </preface><sections>
         <clause id="D" obligation="normative">
           <title>Scope</title>
           <p id="E">Text</p>
         </clause>

         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           </clause>
         </clause>
         </annex><bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </un-standard>
    INPUT

    presxml = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <abstract obligation="informative" id="_" displayorder="1">
         <title id="_">Summary</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Summary</semx>
         </fmt-title>
         <p id="AA" semx-id="AA">This is an abstract</p>
      </abstract>
      <foreword obligation="informative" id="_" displayorder="2">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
         <p id="A" semx-id="A">This is a preamble</p>
      </foreword>
      <introduction id="B" obligation="informative" semx-id="B" displayorder="3">
         <title id="_">Introduction</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Introduction</semx>
         </fmt-title>
         <clause id="C" inline-header="false" obligation="informative" semx-id="C">
            <title id="_">Introduction Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction Subsection</semx>
            </fmt-title>
         </clause>
      </introduction>
      <clause id="H" obligation="normative" semx-id="H" displayorder="4">
         <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
         </fmt-title>
         <terms id="I" obligation="normative" semx-id="I">
            <title id="_">Normal Terms</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Normal Terms</semx>
            </fmt-title>
            <term id="J" semx-id="J">
               <preferred id="_">Term2</preferred>
            </term>
         </terms>
         <definitions id="K" semx-id="K">
            <title id="_">Symbols</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Symbols</semx>
            </fmt-title>
            <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
            </dl>
         </definitions>
      </clause>
   </preface>
   <sections>
      <clause id="D" obligation="normative" semx-id="D" displayorder="5">
         <title id="_">Scope</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Scope</semx>
         </fmt-title>
         <p id="E" semx-id="E">Text</p>
      </clause>
      <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="6">
         <title id="_">Clause 4</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Clause 4</semx>
         </fmt-title>
         <clause id="N" inline-header="false" obligation="normative" semx-id="N">
            <title id="_">Introduction</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Introduction</semx>
            </fmt-title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" semx-id="O">
            <title id="_">Clause 4.2</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Clause 4.2</semx>
            </fmt-title>
         </clause>
      </clause>
   </sections>
   <annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="I" displayorder="7">
      <title id="_">Annex</title>
      <fmt-title id="_">
         <semx element="title" source="_">
            <strong>Annex</strong>
         </semx>
      </fmt-title>
      <variant-title type="toc">
         <semx element="title" source="_">Annex</semx>
      </variant-title>
      <clause id="Q" inline-header="false" obligation="normative" semx-id="Q">
         <title id="_">Annex A.1</title>
         <fmt-title depth="2" id="_">
            <semx element="title" source="_">Annex A.1</semx>
         </fmt-title>
         <clause id="Q1" inline-header="false" obligation="normative" semx-id="Q1">
            <title id="_">Annex A.1a</title>
            <fmt-title depth="3" id="_">
               <semx element="title" source="_">Annex A.1a</semx>
            </fmt-title>
         </clause>
      </clause>
   </annex>
   <bibliography>
      <references id="R" obligation="informative" normative="true" semx-id="R" displayorder="8">
         <title id="_">Normative References</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Normative References</semx>
         </fmt-title>
      </references>
      <clause id="S" obligation="informative" semx-id="S" displayorder="9">
         <title id="_">Bibliography</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Bibliography</semx>
         </fmt-title>
         <references id="T" obligation="informative" normative="false" semx-id="T">
            <title id="_">Bibliography Subsection</title>
            <fmt-title depth="2" id="_">
               <semx element="title" source="_">Bibliography Subsection</semx>
            </fmt-title>
         </references>
      </clause>
   </bibliography>
</un-standard>
    OUTPUT

    html = Xml::C14n.format(<<~"OUTPUT")
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <br/>
         <div id="_">
            <h1 class="AbstractTitle">
            Summary
         </h1>
            <p id="AA">This is an abstract</p>
         </div>
         <br/>
         <div id="_">
            <h1 class="ForewordTitle">
            Foreword
         </h1>
            <p id="A">This is a preamble</p>
         </div>
         <br/>
         <div class="Section3" id="B">
            <h1 class="IntroTitle">
            Introduction
         </h1>
            <div id="C">
               <h2>
               Introduction Subsection
            </h2>
            </div>
         </div>
         <br/>
         <div id="H" class="Section3">
            <h1 class="IntroTitle">
            Terms, Definitions, Symbols and Abbreviated Terms
         </h1>
            <div id="I">
               <h2>
               Normal Terms
            </h2>
               <p class="TermNum" id="J"/>
            </div>
            <div id="K">
               <h2>
               Symbols
            </h2>
               <div class="figdl">
                  <dl>
                     <dt>
                        <p>Symbol</p>
                     </dt>
                     <dd>Definition</dd>
                  </dl>
               </div>
            </div>
         </div>
         <div id="D">
            <h1>
            Scope
         </h1>
            <p id="E">Text</p>
         </div>
         <div id="M">
            <h1>
            Clause 4
         </h1>
            <div id="N">
               <h2>
               Introduction
            </h2>
            </div>
            <div id="O">
               <h2>
               Clause 4.2
            </h2>
            </div>
         </div>
         <br/>
         <div id="P" class="Section3">
            <h1 class="Annex">
               <b>Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex
      </p>
            <div id="Q">
               <h2>
            Annex A.1
         </h2>
               <div id="Q1">
                  <h3>
               Annex A.1a
            </h3>
               </div>
            </div>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Normative References
         </h1>
         </div>
         <br/>
         <div>
            <h1 class="Section3">
            Bibliography
         </h1>
            <div>
               <h2 class="Section3">
               Bibliography Subsection
            </h2>
            </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT

    word = Xml::C14n.format(<<~OUTPUT)
<?xml version="1.0" encoding="UTF-8"?>


<div>
   <div class="WordSection2">
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="_">
         <h1 class="AbstractTitle">
            Summary
         </h1>
         <p id="AA">This is an abstract</p>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="_">
         <h1 class="ForewordTitle">
            Foreword
         </h1>
         <p id="A">This is a preamble</p>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div class="Section3" id="B">
         <h1 class="IntroTitle">
            Introduction
         </h1>
         <div id="C">
            <h2>
               Introduction Subsection
            </h2>
         </div>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="H" class="Section3">
         <h1 class="IntroTitle">
            Terms, Definitions, Symbols and Abbreviated Terms
         </h1>
         <div id="I">
            <h2>
               Normal Terms
            </h2>
            <p class="TermNum" id="J"/>
         </div>
         <div id="K">
            <h2>
               Symbols
            </h2>
            <div align="left">
               <table class="dl">
                  <tr>
                     <td valign="top" align="left">
                        <p align="left" style="margin-left:0pt;text-align:left;">Symbol</p>
                     </td>
                     <td valign="top">Definition</td>
                  </tr>
               </table>
            </div>
         </div>
      </div>
      <p> </p>
   </div>
   <p class="section-break">
      <br clear="all" class="section"/>
   </p>
   <div class="WordSection3">
      <div id="D">
         <h1>
            Scope
         </h1>
         <p id="E">Text</p>
      </div>
      <div id="M">
         <h1>
            Clause 4
         </h1>
         <div id="N">
            <h2>
               Introduction
            </h2>
         </div>
         <div id="O">
            <h2>
               Clause 4.2
            </h2>
         </div>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div id="P" class="Section3">
         <h1 class="Annex">
            <b>Annex</b>
         </h1>
         <p style="display:none;" class="variant-title-toc">
         Annex
      </p>
         <div id="Q">
            <h2>
            Annex A.1
         </h2>
            <div id="Q1">
               <h3>
               Annex A.1a
            </h3>
            </div>
         </div>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div>
         <h1 class="Section3">
            Normative References
         </h1>
      </div>
      <p class="page-break">
         <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
      <div>
         <h1 class="Section3">
            Bibliography
         </h1>
         <div>
            <h2 class="Section3">
               Bibliography Subsection
            </h2>
         </div>
      </div>
   </div>
</div>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert
.new({ suppressheadingnumbers: true }.merge(presxml_options))
.convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert
.new({ suppressheadingnumbers: true })
.convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(IsoDoc::UN::WordConvert
.new({ suppressheadingnumbers: true })
.convert("test", presxml, true)
.sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">')
.sub(%r{<v:line.*$}m, "</div></div>")))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
<?xml version="1.0" encoding="UTF-8"?>


<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="0.12.19" flavor="un">
   <bibdata type="standard">
      <title type="main" language="en" format="text/plain">Document title</title>
      <contributor>
         <role type="author"/>
         <organization>
            <name>United Nations</name>
         </organization>
      </contributor>
      <contributor>
         <role type="publisher"/>
         <organization>
            <name>United Nations</name>
         </organization>
      </contributor>
      <language>ar</language>
      <language>ru</language>
      <language>en</language>
      <language>fr</language>
      <language>zh</language>
      <language>es</language>
      <script>Latn</script>
      <status>
         <stage>published</stage>
      </status>
      <copyright>
         <from>#{Date.today.year}</from>
         <owner>
            <organization>
               <name>United Nations</name>
            </organization>
         </owner>
      </copyright>
      <ext>
         <doctype>standard</doctype>
         <flavor>un</flavor>
         <session/>
      </ext>
   </bibdata>
   <metanorma-extension>
      <semantic-metadata>
         <stage-published>true</stage-published>
      </semantic-metadata>
      <presentation-metadata>
         <toc-heading-levels>2</toc-heading-levels>
         <html-toc-heading-levels>2</html-toc-heading-levels>
         <doc-toc-heading-levels>2</doc-toc-heading-levels>
         <pdf-toc-heading-levels>2</pdf-toc-heading-levels>
      </presentation-metadata>
   </metanorma-extension>
   <boilerplate>
      <copyright-statement>
         <clause id="_" inline-header="false" obligation="normative">
            <p id="_" anchor="boilerplate-ECEhdr">ECE/TRADE/437</p>
            <p id="_">
               Copyright © United Nations #{Date.today.year}
               <br/>
               All rights reserved worldwide
               <br/>
               United Nations publication issued by the Economic Commission for Europe
            </p>
         </clause>
      </copyright-statement>
      <license-statement>
         <clause id="_" inline-header="false" obligation="normative">
            <p id="_">None of the materials provided on this web site may be used, reproduced or transmitted, in whole or in part, in any form or by any means, electronic or mechanical, including photocopying, recording or the use of any information storage and retrieval system, except as provided for in the Terms and Conditions of Use of United Nations Web Sites, without permission in writing from the publisher.</p>
            <p id="_">News-related material can be used as long as the appropriate credit is given and the United Nations is advised.</p>
            <p id="_">
               To request such permission or for further enquires, please visit:
               <link target="https://shop.un.org/rights-permissions">United Nations Publications: Rights and Permissions.</link>
            </p>
         </clause>
      </license-statement>
      <legal-statement>
         <clause id="_" inline-header="false" obligation="normative">
            <clause id="_" inline-header="false" obligation="normative">
               <title id="_">Note</title>
               <p id="_">The designations employed and the presentation of the material in this publication do not imply the expression of any opinion whatsoever on the part of the Secretariat of the United Nations concerning the legal status of any country, territory, city or area, or of its authorities, or concerning the delimitation of its frontiers or boundaries.</p>
            </clause>
         </clause>
      </legal-statement>
      <feedback-statement>
         <p id="_" anchor="boilerplate-feedback-name">UN Economic Commission for Europe: Information Service</p>
         <p id="_" anchor="boilerplate-feedback-address">
            Palais des Nations
            <br/>
            CH-1211 Geneva 10
            <br/>
            Switzerland
            <br/>
            <br/>
            <link target="tel:+41(0)229171234">+41 (0) 22 917 12 34 (switchboard)</link>
            <br/>
         </p>
         <p id="_">
            <link target="mailto:unece_info@un.org">
               unece_info@un.org
               <br/>
               <link target="link:++https://www.unece.org/">www.unece.org/</link>
               ++[]
            </link>
         </p>
      </feedback-statement>
   </boilerplate>
   <sections> </sections>
</metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, backend: :un, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Roboto})
  end

  it "processes admonitions" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword id="FF" displayorder="1">
        <p>
        <xref target="B"/>
        <xref target="B1"/>
        <xref target="E"/>
        <xref target="E1"/>
        </p>
        </foreword>
        </preface>
        <sections>
          <clause id="A" displayorder="2">
          <admonition id="B" unnumbered="true">
            <name>First Box</name>
            <p id="C">paragraph</p>
          </admonition>
          </clause>
          <clause id="A1" displayorder="3">
          <admonition id="B1">
            <name>Second Box</name>
            <p id="C1">paragraph</p>
          </admonition>
          </clause>
        </sections>
        <annex id="D" displayorder="4"><title>First Annex</title>
          <admonition id="E">
            <name>Third Box</name>
            <p id="F">paragraph</p>
          </admonition>
        </annex>
        <annex id="D1" displayorder="5"><title>Second Annex</title>
          <admonition id="E1">
            <name>Fourth Box</name>
            <p id="F1">paragraph</p>
          </admonition>
        </annex>
      </un-standard>
    INPUT

    presxml = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <preface>
      <foreword id="FF" displayorder="1" semx-id="FF">
         <title id="_">Foreword</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Foreword</semx>
         </fmt-title>
         <p>
            <xref target="B" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="B">
                  <span class="fmt-element-name">Box</span>
                  <semx element="autonum" source="B">(??)</semx>
               </fmt-xref>
            </semx>
            <xref target="B1" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="B1">
                  <span class="fmt-element-name">Box</span>
                  <semx element="autonum" source="B1">1</semx>
               </fmt-xref>
            </semx>
            <xref target="E" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="E">
                  <span class="fmt-element-name">Box</span>
                  <semx element="autonum" source="E">I.1</semx>
               </fmt-xref>
            </semx>
            <xref target="E1" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="E1">
                  <span class="fmt-element-name">Box</span>
                  <semx element="autonum" source="E1">II.1</semx>
               </fmt-xref>
            </semx>
         </p>
      </foreword>
   </preface>
   <sections>
      <clause id="A" displayorder="2" semx-id="A">
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <admonition id="B" unnumbered="true" semx-id="B">
            <name id="_">First Box</name>
            <fmt-name id="_">
               <semx element="name" source="_">First Box</semx>
            </fmt-name>
            <p id="C" semx-id="C">paragraph</p>
         </admonition>
      </clause>
      <clause id="A1" displayorder="3" semx-id="A1">
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               II
               <span class="fmt-clause-delim">.</span>
            </span>
         </fmt-title>
         <fmt-xref-label>Clause II</fmt-xref-label>
         <admonition id="B1" semx-id="B1" autonum="1">
            <name id="_">Second Box</name>
            <fmt-name id="_">
               <span class="fmt-caption-label">Box 1</span>
               <span class="fmt-caption-delim"> — </span>
               <semx element="name" source="_">Second Box</semx>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Box</span>
               <semx element="autonum" source="B1">1</semx>
            </fmt-xref-label>
            <p id="C1" semx-id="C1">paragraph</p>
         </admonition>
      </clause>
   </sections>
   <annex id="D" displayorder="4" semx-id="D" autonum="I">
      <title id="_">First Annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex I</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>First Annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex I</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex I</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">First Annex</semx>
      </variant-title>
      <admonition id="E" semx-id="E" autonum="I.1">
         <name id="_">Third Box</name>
         <fmt-name id="_">
            <span class="fmt-caption-label">Box I.1</span>
            <span class="fmt-caption-delim"> — </span>
            <semx element="name" source="_">Third Box</semx>
         </fmt-name>
         <fmt-xref-label>
            <span class="fmt-element-name">Box</span>
            <semx element="autonum" source="E">I.1</semx>
         </fmt-xref-label>
         <p id="F" semx-id="F">paragraph</p>
      </admonition>
   </annex>
   <annex id="D1" displayorder="5" semx-id="D1" autonum="II">
      <title id="_">Second Annex</title>
      <fmt-title id="_">
         <span class="fmt-caption-label">
            <strong>Annex II</strong>
         </span>
         <span class="fmt-caption-delim">
            <br/>
            <br/>
         </span>
         <semx element="title" source="_">
            <strong>Second Annex</strong>
         </semx>
      </fmt-title>
      <fmt-xref-label>Annex II</fmt-xref-label>
      <variant-title type="toc">
         <span class="fmt-caption-label">Annex II</span>
         <span class="fmt-caption-delim">
            <tab/>
         </span>
         <semx element="title" source="_">Second Annex</semx>
      </variant-title>
      <admonition id="E1" semx-id="E1" autonum="II.1">
         <name id="_">Fourth Box</name>
         <fmt-name id="_">
            <span class="fmt-caption-label">Box II.1</span>
            <span class="fmt-caption-delim"> — </span>
            <semx element="name" source="_">Fourth Box</semx>
         </fmt-name>
         <fmt-xref-label>
            <span class="fmt-element-name">Box</span>
            <semx element="autonum" source="E1">II.1</semx>
         </fmt-xref-label>
         <p id="F1" semx-id="F1">paragraph</p>
      </admonition>
   </annex>
</un-standard>
    OUTPUT

    html = <<~"OUTPUT"
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <br/>
         <div id="FF">
            <h1 class="ForewordTitle">
            Foreword
         </h1>
            <p>
               <a href="#B">
                  Box
                  (??)
               </a>
               <a href="#B1">
                  Box
                  1
               </a>
               <a href="#E">
                  Box
                  I.1
               </a>
               <a href="#E1">
                  Box
                  II.1
               </a>
            </p>
         </div>
         <div id="A">
            <h1>
               I
               <span class="fmt-clause-delim">.</span>
            </h1>
            <div id="B" class="Admonition AdmonitionOther">
               <p class="AdmonitionTitle AdmonitionOther" style="text-align:center;">
               First Box
            </p>
               <p id="C">paragraph</p>
            </div>
         </div>
         <div id="A1">
            <h1>
               II
               <span class="fmt-clause-delim">.</span>
            </h1>
            <div id="B1" class="Admonition AdmonitionOther">
               <p class="AdmonitionTitle AdmonitionOther" style="text-align:center;">
               Box 1
                —
               Second Box
            </p>
               <p id="C1">paragraph</p>
            </div>
         </div>
         <br/>
         <div id="D" class="Section3">
            <h1 class="Annex">
               <b>Annex I</b>
               <br/>
               <br/>
               <b>First Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex I

             

         First Annex
      </p>
            <div id="E" class="Admonition AdmonitionOther">
               <p class="AdmonitionTitle AdmonitionOther" style="text-align:center;">
            Box I.1
             —
            Third Box
         </p>
               <p id="F">paragraph</p>
            </div>
         </div>
         <br/>
         <div id="D1" class="Section3">
            <h1 class="Annex">
               <b>Annex II</b>
               <br/>
               <br/>
               <b>Second Annex</b>
            </h1>
            <p style="display:none;" class="variant-title-toc">
         Annex II

             

         Second Annex
      </p>
            <div id="E1" class="Admonition AdmonitionOther">
               <p class="AdmonitionTitle AdmonitionOther" style="text-align:center;">
            Box II.1
             —
            Fourth Box
         </p>
               <p id="F1">paragraph</p>
            </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT
    word = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<div class="WordSection3">
   <div id="A">
      <h1>
         I
         <span class="fmt-clause-delim">.</span>
      </h1>
      <div id="B" class="Admonition">
         <p class="AdmonitionTitle" style="text-align:center;">
               First Box
            </p>
         <p id="C">paragraph</p>
      </div>
   </div>
   <div id="A1">
      <h1>
         II
         <span class="fmt-clause-delim">.</span>
      </h1>
      <div id="B1" class="Admonition">
         <p class="AdmonitionTitle" style="text-align:center;">
               Box 1
                —
               Second Box
            </p>
         <p id="C1">paragraph</p>
      </div>
   </div>
   <p class="page-break">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div id="D" class="Section3">
      <h1 class="Annex">
         <b>Annex I</b>
         <br/>
         <br/>
         <b>First Annex</b>
      </h1>
      <p style="display:none;" class="variant-title-toc">
         Annex I
         <span style="mso-tab-count:1">  </span>
         First Annex
      </p>
      <div id="E" class="Admonition">
         <p class="AdmonitionTitle" style="text-align:center;">
            Box I.1
             —
            Third Box
         </p>
         <p id="F">paragraph</p>
      </div>
   </div>
   <p class="page-break">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div id="D1" class="Section3">
      <h1 class="Annex">
         <b>Annex II</b>
         <br/>
         <br/>
         <b>Second Annex</b>
      </h1>
      <p style="display:none;" class="variant-title-toc">
         Annex II
         <span style="mso-tab-count:1">  </span>
         Second Annex
      </p>
      <div id="E1" class="Admonition">
         <p class="AdmonitionTitle" style="text-align:center;">
            Box II.1
             —
            Fourth Box
         </p>
         <p id="F1">paragraph</p>
      </div>
   </div>
</div>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
.convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert.new({})
.convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(IsoDoc::UN::WordConvert.new({})
  .convert("test", presxml, true)
  .sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">')
  .sub(%r{<v:line.*$}m, "</div>")))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes inline section headers" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
       <clause id="M" inline-header="false" obligation="normative" displayorder="1">
          <title>I.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>A.<tab/>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>B.<tab/>Clause 4.2</title>
       </clause></clause>

       </sections>
      </un-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<html lang="en">
   <head/>
   <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
      <div class="title-section">
         <p> </p>
      </div>
      <br/>
      <div class="prefatory-section">
         <p> </p>
      </div>
      <br/>
      <div class="main-section">
         <div id="M">
            <h1/>
            <div id="N">

 </div>
            <div id="O">

 </div>
         </div>
      </div>
   </body>
</html>
    OUTPUT
    expect(Xml::C14n.format(IsoDoc::UN::HtmlConvert.new({})
  .convert("test", input, true)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "does not switch plenary title page in HTML" do
    FileUtils.rm_f("test.html")
    input = <<~INPUT
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title language="en" format="plain">Main Title</title>
        <ext><doctype>plenary</doctype></ext>
        </bibdata>
        <sections/>
        </un-standard>
    INPUT
    IsoDoc::UN::HtmlConvert.new({}).convert("test", input, false)
    html = File.read("test.html", encoding: "utf-8")
    expect(html).not_to include("<div id='abstractbox'")
  end

  it "switch to plenary title page in DOC" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title language="en" format="plain">Main Title</title>
        <ext><doctype>plenary</doctype></ext>
        </bibdata>
        <sections/>
        </un-standard>
    INPUT
    IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include("This is a plenary page")
  end

  it "switch to plenary title page in DOC if any bibdata/ext/section" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title language="en" format="plain">Main Title</title>
        <ext><doctype>recommendation</doctype>
        <session><element/></session>
              </ext>
        </bibdata>
        <sections/>
        </un-standard>
    INPUT
    IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include("This is a plenary page")
  end

  it "does not switch plenary title page in DOC if no bibdata/ext/section" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title language="en" format="plain">Main Title</title>
        <ext><doctype>recommendation</doctype></ext>
        </bibdata>
        <sections/>
        </un-standard>
    INPUT
    IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).not_to include("This is a plenary page")
  end

  it "processes bibliography" do
    input = <<~INPUT
          <un-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <clause displayorder="1">
          <eref bibitemid="ISO712"/>
          </clause>
          </sections>
          <bibliography><references id="R" obligation="informative" normative="true" displayorder="2">
               <title>Normative References</title>
               <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
             </references>
             </bibliography>
      </un-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <sections>
      <clause displayorder="1" id="_">
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <eref bibitemid="ISO712" id="_"/>
         <semx element="eref" source="_">
            <fmt-xref target="ISO712">ISO 712</fmt-xref>
         </semx>
      </clause>
   </sections>
   <bibliography>
      <references id="R" obligation="informative" normative="true" displayorder="2" semx-id="R">
         <title id="_">Normative References</title>
         <fmt-title depth="1" id="_">
            <semx element="title" source="_">Normative References</semx>
         </fmt-title>
         <bibitem id="ISO712" type="standard" semx-id="ISO712">
            <biblio-tag>ISO 712, </biblio-tag>
            <formattedref>
               <em>Cereals and cereal products</em>
               . International Organization for Standardization.
            </formattedref>
            <title format="text/plain">Cereals and cereal products</title>
            <docidentifier type="ISO">ISO 712</docidentifier>
            <docidentifier scope="biblio-tag">ISO 712</docidentifier>
            <contributor>
               <role type="publisher"/>
               <organization>
                  <name>International Organization for Standardization</name>
               </organization>
            </contributor>
         </bibitem>
      </references>
   </bibliography>
</un-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes note types" do
    input = <<~INPUT
          <un-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <note type="title-footnote"><p>ABC</p></note>
          </bibdata>
          <sections>
          <clause displayorder="2">
          <note type="source" id="A">
          <p>Source</p>
          </note>
          <note type="abbreviation" id="B">
          <p>Source</p>
          </note>
          <note type="source" id="C">
          <p>Source</p>
          </note>
          <note type="abbreviation" id="D">
          <p>Source</p>
          </note>
          <note id="E">
          <p>Source</p>
          </note>
          </clause>
          </sections>
      </un-standard>
    INPUT
    output = <<~OUTPUT
<?xml version="1.0" encoding="UTF-8"?>


<un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
   <bibdata>
      <note type="title-footnote">
         <p>ABC</p>
      </note>
   </bibdata>
   <sections>
      <clause displayorder="1" id="_">
         <fmt-title depth="1" id="_">
            <span class="fmt-caption-label">
               I
               <span class="fmt-clause-delim">.</span>
            </span>
         </fmt-title>
         <fmt-xref-label>Clause I</fmt-xref-label>
         <note type="source" id="A" semx-id="A" autonum="1">
            <fmt-name id="_">
               <span class="fmt-caption-label">Source</span>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="A">1</semx>
            </fmt-xref-label>
            <fmt-xref-label container="_">
               <span class="fmt-xref-container">Clause I</span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="A">1</semx>
            </fmt-xref-label>
            <p>Source</p>
         </note>
         <note type="abbreviation" id="B" semx-id="B" autonum="2">
            <fmt-name id="_">
               <span class="fmt-caption-label">Abbreviations</span>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="B">2</semx>
            </fmt-xref-label>
            <fmt-xref-label container="_">
               <span class="fmt-xref-container">Clause I</span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="B">2</semx>
            </fmt-xref-label>
            <p>Source</p>
         </note>
         <note type="source" id="C" semx-id="C" autonum="3">
            <fmt-name id="_">
               <span class="fmt-caption-label">Source</span>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="C">3</semx>
            </fmt-xref-label>
            <fmt-xref-label container="_">
               <span class="fmt-xref-container">Clause I</span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="C">3</semx>
            </fmt-xref-label>
            <p>Source</p>
         </note>
         <note type="abbreviation" id="D" semx-id="D" autonum="4">
            <fmt-name id="_">
               <span class="fmt-caption-label">Abbreviations</span>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="D">4</semx>
            </fmt-xref-label>
            <fmt-xref-label container="_">
               <span class="fmt-xref-container">Clause I</span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="D">4</semx>
            </fmt-xref-label>
            <p>Source</p>
         </note>
         <note id="E" semx-id="E" autonum="5">
            <fmt-name id="_">
               <span class="fmt-caption-label">NOTE</span>
            </fmt-name>
            <fmt-xref-label>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="E">5</semx>
            </fmt-xref-label>
            <fmt-xref-label container="_">
               <span class="fmt-xref-container">Clause I</span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Note</span>
               <semx element="autonum" source="E">5</semx>
            </fmt-xref-label>
            <p>Source</p>
         </note>
      </clause>
   </sections>
</un-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::UN::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
