require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib",
                                     "isodoc", "un", "html"))

RSpec.describe IsoDoc::UN do
  it "processes default metadata, recommendation" do
    csdc = IsoDoc::UN::WordConvert.new({ toc: true })
    input = <<~"INPUT"
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title type="main" language="en" format="plain">Main Title</title>
        <title type="subtitle" language="en" format="plain">Subtitle</title>
        <docidentifier>1000</docidentifier>
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
        <ext><doctype>recommendation</doctype>
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
{accesseddate: "XXX", adapteddate: "XXX", agency: "UN", announceddate: "XXX", bibdata: {id: "1000", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Main Title", type: "main", format: "plain"}, {language: "en", content: "Subtitle", type: "subtitle", format: "plain"}], docidentifier: [{content: "1000"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}, {role: [{type: "publisher"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}], edition: {content: "2"}, version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], language: ["en", "fr"], script: ["Latn"], status: {stage: {content: "working-draft"}}, copyright: [{from: "2001", owner: [{organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}]}], ext: {doctype: {content: "recommendation"}, editorialgroup: {committee: {type: "A", content: "TC"}}, security: {content: "Client Confidential"}, submissionlanguage: [{content: "de"}, {content: "jp"}]}}, circulateddate: "XXX", confirmeddate: "XXX", copieddate: "XXX", correcteddate: "XXX", createddate: "XXX", docnumber: "1000", docsubtitle: "Subtitle", doctitle: "Main Title", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2001", draft: "3.4", draftinfo: " (draft 3.4, 2000-01-01)", edition: "2", formatted_docnumber: "UN/CEFACT Recommendation 1000", implementeddate: "XXX", issueddate: "XXX", lang: "en", logo: "#{File.join(logoloc, 'logo.jpg')}", obsoleteddate: "XXX", publisheddate: "XXX", publisher: "United Nations", receiveddate: "XXX", revdate: "2000-01-01", revdate_monthyear: "January 2000", script: "Latn", stable_untildate: "XXX", stage: "Working Draft", stage_display: "Working Draft", submissionlanguage: ["German"], tc: "TC", toc: true, transmitteddate: "XXX", unchangeddate: "XXX", unpublished: false, updateddate: "XXX", vote_endeddate: "XXX", vote_starteddate: "XXX"}
    OUTPUT

    docxml, _filename, _dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata_str(csdc.info(docxml, nil)))
      .gsub(", :", ",\n:"))
      .to eq output.strip
  end

  it "processes default metadata, plenary" do
    csdc = IsoDoc::UN::WordConvert.new({ toc: true })
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
        <doctype>plenary</doctype>
        <editorialgroup>
          <committee type="A">TC</committee>
        </editorialgroup>
        <security>Client Confidential</security>
        <session>
        <number>3</number>
        <date>2001-01-01</date>
        <agenda_item>5</agenda_item>
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
{accesseddate: "XXX", adapteddate: "XXX", agency: "UN", announceddate: "XXX", bibdata: {id: "1000wd", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Main Title", type: "main", format: "plain"}, {language: "en", content: "Subtitle", type: "subtitle", format: "plain"}], docidentifier: [{content: "1000(wd)"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}, {role: [{type: "publisher"}], organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}], language: ["en", "fr"], script: ["Latn"], status: {stage: {content: "working-draft"}}, copyright: [{from: "2001", owner: [{organization: {name: [{content: "United Nations"}], abbreviation: {content: "UN"}}}]}], ext: {doctype: {content: "plenary"}, editorialgroup: {committee: {type: "A", content: "TC"}}, security: {content: "Client Confidential"}, session: {number: {content: "3"}, date: {content: "2001-01-01"}, agenda_item: {content: "5"}, collaborator: {content: "WHO"}, id: {content: "ECE/WHO-UNECE-01"}, distribution: {content: "public"}}}}, circulateddate: "XXX", confirmeddate: "XXX", copieddate: "XXX", correcteddate: "XXX", createddate: "XXX", doclanguage: ["English", "French"], docnumber: "1000(wd)", docsubtitle: "Subtitle", doctitle: "Main Title", doctype: "Plenary", doctype_display: "Plenary", docyear: "2001", formatted_docnumber: "1000(wd)", implementeddate: "XXX", issueddate: "XXX", lang: "en", logo: "#{File.join(logoloc, 'logo.jpg')}", obsoleteddate: "XXX", publisheddate: "XXX", publisher: "United Nations", receiveddate: "XXX", script: "Latn", session_collaborator: "WHO", session_date: "2001-01-01", session_id: "ECE/WHO-UNECE-01", session_id_head: "ECE", session_id_tail: "/WHO-UNECE-01", session_number: "Third", stable_untildate: "XXX", stage: "Working Draft", stage_display: "Working Draft", tc: "TC", toc: true, transmitteddate: "XXX", unchangeddate: "XXX", unpublished: false, updateddate: "XXX", vote_endeddate: "XXX", vote_starteddate: "XXX"}
    OUTPUT

    docxml, _filename, _dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata_str(csdc.info(docxml, nil)))
      .gsub(", :", ",\n:"))
      .to eq output.strip
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


<div class="WordSection3">
   <div id="M">
      <h1/>
      <div id="N">

 </div>
      <div id="O">

 </div>
   </div>
</div>
    OUTPUT
    expect(Xml::C14n.format(IsoDoc::UN::WordConvert.new({})
      .convert("test", input, true)
      .sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">')
      .sub(%r{<v:line.*$}m, "</div>")))
      .to be_xml_equivalent_to Xml::C14n.format(output)
  end

  it "uses plenary title page in DOC for plenaries" do
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
    presxml = IsoDoc::UN::PresentationXMLConvert.new({ toc: true })
      .convert("test", input, true)
    IsoDoc::UN::WordConvert.new({ toc: true }).convert("test", presxml, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include("This is a plenary page")
    expect(html).to include('class="zzContents"')
  end

  it "removes intro page page in DOC for plenaries with no ToC" do
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
    IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include("This is a plenary page")
    expect(html).not_to include('class="zzContents"')
  end

  it "populates abstract box if there is an abstract" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="https://www.metanorma.org/ns/un">
      <bibdata type="standard">
        <title language="en" format="plain">Main Title</title>
        <ext><doctype>plenary</doctype></ext>
        </bibdata>
        <preface><abstract displayorder="1"><title>Abstract</title><p>123</p></abstract></preface>
        <sections/>
        </un-standard>
    INPUT
    IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include('<a name="abstractbox" id="abstractbox">')
  end

  it "does not populate abstract box if there is no abstract" do
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
    IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).not_to include('<a name="abstractbox" id="abstractbox">')
  end

  it "does not used plenary title page in DOC for recommendations" do
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
    IsoDoc::UN::WordConvert.new(toc: true).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).not_to include('<a name="abstractbox" id="abstractbox">')
    expect(html).not_to include("<v:shapetype")
  end

  it "processes plenary preface" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
      <ext><doctype>plenary</doctype></ext>
      </bibdata>
        <preface>
        <foreword obligation="informative" displayorder="1">
           <title>Foreword</title>
           <p id="A">This is a preamble</p>
         </foreword>
          <introduction id="B" obligation="informative" displayorder="2"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative" displayorder="3">
         <p id="AA">This is an abstract</o>
         </abstract>
         <clause id="H" obligation="normative" displayorder="4"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
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
    INPUT
    IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    section1 = html
      .sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">')
      .sub(%r{<div class="WordSection2">.*$}m, "")
    section2 = html
      .sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">')
      .sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
    expect(html).to include("<v:shapetype")
    expect(section1).to include("This is an abstract")
    expect(Xml::C14n.format(section2)).to be_xml_equivalent_to Xml::C14n.format(<<~OUTPUT)
<?xml version="1.0" encoding="UTF-8"?>


<div class="WordSection2">
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div>
      <h1 class="ForewordTitle"/>
      <p class="MsoNormal">
         <a name="A" id="A"/>
         This is a preamble
      </p>
   </div>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div class="Section3">
      <a name="B" id="B"/>
      <h1 class="IntroTitle"/>
      <div>
         <a name="C" id="C"/>
      </div>
   </div>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div class="Section3">
      <a name="H" id="H"/>
      <h1 class="IntroTitle"/>
      <div>
         <a name="I" id="I"/>
         <p class="TermNum">
            <a name="J" id="J"/>
         </p>
      </div>
      <div>
         <a name="K" id="K"/>
         <div align="left">
            <table class="dl">
               <tr>
                  <td valign="top" align="left">
                     <p align="left" style="margin-left:0pt;text-align:left;" class="MsoNormal">Symbol</p>
                  </td>
                  <td valign="top">Definition</td>
               </tr>
            </table>
         </div>
      </div>
   </div>
   <p class="MsoNormal"> </p>
</div>
    OUTPUT
  end

  it "removes WordSection2 if empty" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
      <ext><doctype>plenary</doctype></ext>
      </bibdata>
        <preface>
          </preface><sections/>
          </un-standard>
    INPUT
    presxml = IsoDoc::UN::PresentationXMLConvert.new({ toc: true })
      .convert("test", input, true)
    IsoDoc::UN::WordConvert.new({}).convert("test", presxml, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).not_to include('<div class="WordSection2"')
  end

  it "does not removes WordSection2 if no preface but ToC" do
    FileUtils.rm_f("test.doc")
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
      <ext><doctype>recommendation</doctype></ext>
      </bibdata>
      <metanorma-extension><presentation-metadata><name>TOC Heading Levels</name><value>2</value></presentation-metadata><presentation-metadata><name>HTML TOC Heading Levels</name><value>2</value></presentation-metadata><presentation-metadata><name>DOC TOC Heading Levels</name><value>2</value></presentation-metadata><presentation-metadata><name>PDF TOC Heading Levels</name><value>2</value></presentation-metadata></metanorma-extension>
          <sections><clause id="A"><title depth="1">A</title></clause></sections>
          </un-standard>
    INPUT
    presxml = IsoDoc::UN::PresentationXMLConvert.new({ toc: true })
      .convert("test", input, true)
    IsoDoc::UN::WordConvert.new({ toc: true }).convert("test", presxml, false)
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to include('<div class="WordSection2"')
  end

  it "processes recommendation preface" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
      <ext><doctype>recommendation</doctype></ext>
      </bibdata>
      #{boilerplate(Nokogiri::XML("#{BLANK_HDR}</un-standard>"))}
        <preface>
        <foreword obligation="informative" displayorder="1">
           <title>Foreword</title>
           <p id="A">This is a preamble</p>
         </foreword>
          <introduction id="B" obligation="informative" displayorder="1">
           <title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative" displayorder="3">
         <title>Summary</title>
         <p id="AA">This is an abstract</o>
         </abstract>
         <clause id="H" obligation="normative" displayorder="4"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
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
          </preface><sections/>
          </un-standard>
    INPUT
    IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
    html = File.read("test.doc", encoding: "utf-8")
    section1 = html
      .sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">')
      .sub(%r{<div class="WordSection2">.*$}m, "")
    section2 = html
      .sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">')
      .sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
    expect(section1).not_to include("This is an abstract")
    expect(Xml::C14n.format(section2))
      .to be_xml_equivalent_to Xml::C14n.format(<<~OUTPUT)
<?xml version="1.0" encoding="UTF-8"?>


<div class="WordSection2">
   <div>
      <div class="boilerplate-legal">
         <div>
            <a name="_" id="_"/>
            <div>
               <a name="_" id="_"/>
               <p class="MsoNormal">
                  <a name="_" id="_"/>
                  The designations employed and the presentation of the material in this publication do not imply the expression of any opinion whatsoever on the part of the Secretariat of the United Nations concerning the legal status of any country, territory, city or area, or of its authorities, or concerning the delimitation of its frontiers or boundaries.
               </p>
            </div>
         </div>
      </div>
      <div class="boilerplate-copyright">
         <div>
            <a name="_" id="_"/>
            <p class="MsoNormal">
               <a name="_" id="_"/>
               ECE/TRADE/437
            </p>
            <p class="MsoNormal">
               <a name="_" id="_"/>
               Copyright © United Nations #{Date.today.year}
               <br/>
               All rights reserved worldwide
               <br/>
               United Nations publication issued by the Economic Commission for Europe
            </p>
         </div>
      </div>
   </div>
   <div>
      <a name="preface_container" id="preface_container"/>
      <div>
         <h1 class="AbstractTitle"/>
         <p class="MsoNormal">
            <a name="AA" id="AA"/>
            This is an abstract
         </p>
      </div>
      <div>
         <h1 class="ForewordTitle"/>
         <p class="MsoNormal">
            <a name="A" id="A"/>
            This is a preamble
         </p>
      </div>
      <div class="Section3">
         <a name="B" id="B"/>
         <h1 class="IntroTitle"/>
         <div>
            <a name="C" id="C"/>
         </div>
      </div>
   </div>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <p class="MsoNormal">
      <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
   </p>
   <div class="Section3">
      <a name="H" id="H"/>
      <h1 class="IntroTitle"/>
      <div>
         <a name="I" id="I"/>
         <p class="TermNum">
            <a name="J" id="J"/>
         </p>
      </div>
      <div>
         <a name="K" id="K"/>
         <div align="left">
            <table class="dl">
               <tr>
                  <td valign="top" align="left">
                     <p align="left" style="margin-left:0pt;text-align:left;" class="MsoNormal">Symbol</p>
                  </td>
                  <td valign="top">Definition</td>
               </tr>
            </table>
         </div>
      </div>
   </div>
   <p class="MsoNormal"> </p>
</div>
      OUTPUT
  end
end
