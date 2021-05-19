require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "un", "html"))

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
      {:accesseddate=>"XXX",
      :agency=>"UN",
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
      :createddate=>"XXX",
      :docnumber=>"1000A",
      :docnumeric=>"1000",
      :docsubtitle=>"Subtitle",
      :doctitle=>"Main Title",
      :doctype=>"Recommendation",
      :doctype_display=>"Recommendation",
      :docyear=>"2001",
      :draft=>"3.4",
      :draftinfo=>" (draft 3.4, 2000-01-01)",
      :edition=>"2",
      :formatted_docnumber=>"UN/CEFACT Recommendation 1000A",
      :implementeddate=>"XXX",
      :issueddate=>"XXX",
      :lang=>"en",
      :logo=>"#{File.join(logoloc, 'logo.jpg')}",
      :obsoleteddate=>"XXX",
      :publisheddate=>"XXX",
      :publisher=>"United Nations",
      :receiveddate=>"XXX",
      :revdate=>"2000-01-01",
      :revdate_monthyear=>"January 2000",
      :script=>"Latn",
      :stage=>"Working Draft",
      :stage_display=>"Working Draft",
      :stageabbr=>"wd",
      :submissionlanguage=>["German"],
      :tc=>"TC",
      :title_footnote=>["ABC"],
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s).gsub(/, :/, ",\n:")).to be_equivalent_to output
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
      {:accesseddate=>"XXX",
      :agency=>"UN",
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
      :createddate=>"XXX",
      :docnumber=>"1000(wd)",
      :docsubtitle=>"Subtitle",
      :doctitle=>"Main Title",
      :doctype=>"Plenary",
      :doctype_display=>"Plenary",
      :docyear=>"2001",
      :formatted_docnumber=>"1000(wd)",
      :implementeddate=>"XXX",
      :issueddate=>"XXX",
      :lang=>"en",
      :logo=>"#{File.join(logoloc, 'logo.jpg')}",
      :obsoleteddate=>"XXX",
      :publisheddate=>"XXX",
      :publisher=>"United Nations",
      :receiveddate=>"XXX",
      :script=>"Latn",
      :session_collaborator=>"WHO",
      :session_date=>"2001-01-01",
      :session_id=>"ECE/WHO-UNECE-01",
      :session_id_head=>"ECE",
      :session_id_tail=>"/WHO-UNECE-01",
      :session_itemname=>["ABC", "DEF"],
      :session_itemnumber=>["5", "6"],
      :session_number=>"Third",
      :session_subitemname=>["GHI", "JKL"],
      :stage=>"Working Draft",
      :stage_display=>"Working Draft",
      :stageabbr=>"wd",
      :tc=>"TC",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s).gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes section names without paragraph content" do
    input = <<~"INPUT"
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
      <un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
           <foreword obligation="informative">
              <title>Foreword</title>
            </foreword>
             <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
              <title depth="2">Introduction Subsection</title>
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
            <clause id="H" obligation="normative"><title depth="1">I.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
              <title depth="2">A.<tab/>Normal Terms</title>
              <term id="J"><name>1.</name>
              <preferred>Term2</preferred>
            </term>
            </terms>
            <definitions id="K"><title>B.</title>
              <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
              </dl>
            </definitions>
            </clause>
            <clause id="D" obligation="normative">
              <title depth="1">II.<tab/>Scope</title>
            </clause>

            <clause id="M" inline-header="false" obligation="normative"><title depth="1">III.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
              <title depth="2">A.<tab/>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">B.<tab/>Clause 4.2</title>
              <clause id="O1" inline-header="false" obligation="normative">
              <title depth="3">1.<tab/>Clause 4.2.1</title>
              <clause id="O11" inline-header="false" obligation="normative">
              <title depth="4">I.<tab/>Clause 4 Leaf</title>
              </clause>
              </clause>
            </clause></clause>

            </sections><annex id="P" inline-header="false" obligation="normative">
              <title><strong>Annex I</strong><br/><strong>Annex</strong></title>
              <clause id="Q" inline-header="false" obligation="normative">
              <title depth="2">1.<tab/>Annex A.1</title>
              <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">I.<tab/>Annex A.1a</title>
              <clause id="Q11" inline-header="false" obligation="normative">
              <title depth="4">A.<tab/>Annex A Leaf</title>
              </clause>
              </clause>
            </clause>
            </annex>
            <annex id="U" inline-header="false" obligation="normative">
            <title><strong>Annex II</strong><br/><strong>Terminal annex</strong></title>
            </annex>
             <bibliography><references id="R" obligation="informative" normative="true">
              <title depth="1">Normative References</title>
            </references><clause id="S" obligation="informative">
              <title depth="1">Bibliography</title>
              <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
            </clause>
            </bibliography>
            </un-standard>
    OUTPUT

    html = xmlpp(<<~"OUTPUT")
              #{HTML_HDR}
                           <br/>
                   <div>
                     <h1 class="AbstractTitle">Summary</h1>
                   </div>
                   <br/>
                   <div>
                     <h1 class="ForewordTitle">Foreword</h1>
                   </div>
                   <br/>
                   <div class="Section3" id="B">
                     <h1 class="IntroTitle">Introduction</h1>
                     <div id="C"><h2>Introduction Subsection</h2>
                </div>
                   </div>
                   <br/>
      <div class='Section3' id=''>
        <h1 class='IntroTitle'>Acknowledgements</h1>
      </div>
                   <div id="H">
                     <h1>I.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
                     <div id="I"><h2>A.&#160; Normal Terms</h2>
                  <p class="TermNum" id="J">1.</p>
                  <p class="Terms" style="text-align:left;">Term2</p>
                </div>
                     <div id="K"><h2>B.</h2>
                  <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
                </div>
                   </div>
                   <div id="D">
                     <h1>II.&#160; Scope</h1>
                   </div>
                   <div id="M">
                     <h1>III.&#160; Clause 4</h1>
                     <div id="N"><h2>A.&#160; Introduction</h2>
                </div>
                     <div id="O"><h2>B.&#160; Clause 4.2</h2>
                  <div id="O1"><h3>1.&#160; Clause 4.2.1</h3>
                  <div id="O11"><h4>I.&#160; Clause 4 Leaf</h4>
                  </div>
                  </div>
                </div>
                   </div>
                   <br/>
                   <div id="P" class="Section3">
                     <h1 class="Annex">
                       <b>Annex I</b>
                       <br/>
                       <b>Annex</b>
                     </h1>
                     <div id="Q"><h2>1.&#160; Annex A.1</h2>
                  <div id="Q1"><h3>I.&#160; Annex A.1a</h3>
                  <div id="Q11"><h4>A.&#160; Annex A Leaf</h4>
                  </div>
                  </div>
                </div>
                   </div>
                   <br/>
                   <div id="U" class="Section3">
                     <h1 class="Annex"><b>Annex II</b><br/><b>Terminal annex</b></h1>
                   </div>
                   <br/>
                   <div>
                     <h1 class="Section3">Bibliography</h1>
                     <div>
                       <h2 class="Section3">Bibliography Subsection</h2>
                     </div>
                   </div>
                 </div>
               </body>
             </html>
    OUTPUT

    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({}).convert("test", presxml, true))).to be_equivalent_to xmlpp(html)
  end

  it "processes unnumbered section names without paragraph content" do
    input = <<~"INPUT"
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
         <un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
         </foreword>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative" unnumbered="true">
           <title depth="2">Introduction Subsection</title>
         </clause>
         </introduction>
         <abstract obligation="informative"><title>Summary</title>
         </abstract>
         <acknowledgements obligation="informative">
         <title>Acknowledgements</title>
         </acknowledgements>
         </preface>
         <sections>
         <clause id="H" obligation="normative"><title depth="1">I.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <definitions id="K" unnumbered="true">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <clause id="D" obligation="normative">
           <title depth="1">II.<tab/>Scope</title>
         </clause>
         <clause id="M" inline-header="false" obligation="normative"><title depth="1">III.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Clause 4.2</title>
           <clause id="O1" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Clause 4.2.1</title>
           <clause id="O11" inline-header="false" obligation="normative">
           <title depth="4">I.<tab/>Clause 4 Leaf</title>
           </clause>
           <clause id="O12" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Clause 4 Leaf 2</title>
           </clause>
           </clause>
         </clause>
         </clause><annex id="P" inline-header="false" obligation="normative">
           <title><strong>Annex I</strong><br/><strong>Annex</strong></title>
           <clause id="Q" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Annex A.1a</title>
           <clause id="Q11" inline-header="false" obligation="normative" unnumbered="true">
           <title depth="1">Annex A Leaf</title>
           </clause>
           </clause>
         </clause>
         </annex>
         <annex id="U" inline-header="false" obligation="normative">
         <title><strong>Annex II</strong><br/><strong>Terminal annex</strong></title>
         </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title depth="1">Normative References</title>
         </references><clause id="S" obligation="informative">
           <title depth="1">Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title depth="2">Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </sections>
      </un-standard>
    OUTPUT

    html = <<~"OUTPUT"
                 #{HTML_HDR}
                   <br/>
                   <div>
                     <h1 class='AbstractTitle'>Summary</h1>
                   </div>
                   <br/>
                   <div>
                     <h1 class='ForewordTitle'>Foreword</h1>
                   </div>
                   <br/>
                   <div class='Section3' id='B'>
                     <h1 class='IntroTitle'>Introduction</h1>
                     <div id='C'>
                       <h2>Introduction Subsection</h2>
                     </div>
                   </div>
                   <br/>
                   <div class='Section3' id=''>
                     <h1 class='IntroTitle'>Acknowledgements</h1>
                   </div>
                   <div id='H'>
                     <h1>I.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
                     <div id='K'>
                       <h2>Symbols</h2>
                       <dl>
                         <dt>
                           <p>Symbol</p>
                         </dt>
                         <dd>Definition</dd>
                       </dl>
                     </div>
                   </div>
                   <div id='D'>
                     <h1>II.&#160; Scope</h1>
                   </div>
                   <div id='M'>
                     <h1>III.&#160; Clause 4</h1>
                     <div id='N'>
                       <h1>Introduction</h1>
                     </div>
                     <div id='O'>
                       <h1>Clause 4.2</h1>
                       <div id='O1'>
                         <h1>Clause 4.2.1</h1>
                         <div id='O11'>
        <h4>I.&#160; Clause 4 Leaf</h4>
      </div>
      <div id='O12'>
        <h1>Clause 4 Leaf 2</h1>
      </div>
                       </div>
                     </div>
                   </div>
                   <br/>
                   <div id='P' class='Section3'>
                     <h1 class='Annex'>
                       <b>Annex I</b>
                       <br/>
                       <b>Annex</b>
                     </h1>
                     <div id='Q'>
                       <h1>Annex A.1</h1>
                       <div id='Q1'>
                         <h1>Annex A.1a</h1>
                         <div id='Q11'>
                           <h1>Annex A Leaf</h1>
                         </div>
                       </div>
                     </div>
                   </div>
                   <br/>
                   <div id='U' class='Section3'>
                     <h1 class='Annex'>
                       <b>Annex II</b>
                       <br/>
                       <b>Terminal annex</b>
                     </h1>
                   </div>
                   <br/>
                   <div>
                     <h1 class='Section3'>Bibliography</h1>
                     <div>
                       <h2 class='Section3'>Bibliography Subsection</h2>
                     </div>
                   </div>
                 </div>
               </body>
             </html>
    OUTPUT
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({}).convert("test", presxml, true))).to be_equivalent_to xmlpp(html)
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
      <un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
               <preface>
               <foreword obligation="informative">
                  <title>Foreword</title>
                  <p id="A1">Text</p>
                </foreword>
                 <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
                  <title depth="2">Introduction Subsection</title>
                  <p id="A2">Text</p>
                </clause>
                </introduction>
                <abstract obligation="informative">
             <title>Summary</title>
                  <p id="A3">Text</p>
                </abstract>
                </preface>
                <sections>
                <clause id="H" obligation="normative"><title depth="1">I.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
                  <title depth="2">A.<tab/>Normal Terms</title>
                  <term id="J"><name>1.</name>
                  <preferred>Term2</preferred>
                </term>
                </terms>
                <definitions id="K"><title>B.</title>
                  <dl>
                  <dt>Symbol</dt>
                  <dd>Definition</dd>
                  </dl>
                </definitions>
                </clause>
                <clause id="D" obligation="normative" type="scope">
                  <title depth="1">1.<tab/>Scope</title>
                  <p id="A4">Text</p>
                </clause>
                <clause id="M" inline-header="false" obligation="normative"><title depth="1">III.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
                  <title depth="2">2.<tab/>Introduction</title>
                  <p id="A5">Text</p>
                </clause>
                <clause id="O" inline-header="false" obligation="normative">
                  <title depth="2">A.<tab/>Clause 4.2</title>
                  <clause id="O1" inline-header="false" obligation="normative">
                  <title depth="3">1.<tab/>Clause 4.2.1</title>
                  <clause id="O11" inline-header="false" obligation="normative">
                  <title depth="4">3.<tab/>Clause 4 Leaf</title>
                  <p id="A6">Text</p>
                  </clause>
                  </clause>
                </clause></clause>
                </sections><annex id="P" inline-header="false" obligation="normative">
                  <title><strong>Annex I</strong><br/><strong>Annex</strong></title>
                  <clause id="Q" inline-header="false" obligation="normative">
                  <title depth="2">1.<tab/>Annex A.1</title>
                  <clause id="Q1" inline-header="false" obligation="normative">
                  <title depth="3">I.<tab/>Annex A.1a</title>
                  <clause id="Q11" inline-header="false" obligation="normative">
                  <title depth="4">1.<tab/>Annex A Leaf</title>
                  <p id="A7">Text</p>
                  </clause>
                  </clause>
                </clause>
                </annex>
                <annex id="U" inline-header="false" obligation="normative">
                <title><strong>Annex II</strong><br/><strong>Terminal annex</strong></title>
                  <p id="A8">Text</p>
                </annex>
                 <bibliography><references id="R" obligation="informative" normative="true">
                  <title depth="1">Normative References</title>
                </references><clause id="S" obligation="informative">
                  <title depth="1">Bibliography</title>
                  <references id="T" obligation="informative" normative="false">
                  <title depth="2">Bibliography Subsection</title>
                </references>
                </clause>
                </bibliography>
                </un-standard>
    OUTPUT

    html = <<~OUTPUT
                  #{HTML_HDR}
                  <br/>
            <div>
              <h1 class='AbstractTitle'>Summary</h1>
              <p id='A3'>Text</p>
            </div>
            <br/>
            <div>
              <h1 class='ForewordTitle'>Foreword</h1>
              <p id='A1'>Text</p>
            </div>
            <br/>
            <div class='Section3' id='B'>
              <h1 class='IntroTitle'>Introduction</h1>
              <div id='C'>
                <h2>Introduction Subsection</h2>
                <p id='A2'>Text</p>
              </div>
            </div>
            <div id='H'>
              <h1>I.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
              <div id='I'>
                <h2>A.&#160; Normal Terms</h2>
                <p class='TermNum' id='J'>1.</p>
                <p class='Terms' style='text-align:left;'>Term2</p>
              </div>
              <div id='K'>
                <h2>B.</h2>
                <dl>
                  <dt>
                    <p>Symbol</p>
                  </dt>
                  <dd>Definition</dd>
                </dl>
              </div>
            </div>
            <div id='D'>
              <h1>1.&#160; Scope</h1>
              <p id='A4'>Text</p>
            </div>
            <div id='M'>
              <h1>III.&#160; Clause 4</h1>
              <div id='N'>
                <h2>2.&#160; Introduction</h2>
                <p id='A5'>Text</p>
              </div>
              <div id='O'>
                <h2>A.&#160; Clause 4.2</h2>
                <div id='O1'>
                  <h3>1.&#160; Clause 4.2.1</h3>
                  <div id='O11'>
                    <h4>3.&#160; Clause 4 Leaf</h4>
                    <p id='A6'>Text</p>
                  </div>
                </div>
              </div>
            </div>
            <br/>
            <div id='P' class='Section3'>
              <h1 class='Annex'>
                <b>Annex I</b>
                <br/>
                <b>Annex</b>
              </h1>
              <div id='Q'>
                <h2>1.&#160; Annex A.1</h2>
                <div id='Q1'>
                  <h3>I.&#160; Annex A.1a</h3>
                  <div id='Q11'>
                    <h4>1.&#160; Annex A Leaf</h4>
                    <p id='A7'>Text</p>
                  </div>
                </div>
              </div>
            </div>
            <br/>
            <div id='U' class='Section3'>
              <h1 class='Annex'>
                <b>Annex II</b>
                <br/>
                <b>Terminal annex</b>
              </h1>
              <p id='A8'>Text</p>
            </div>
            <br/>
            <div>
              <h1 class='Section3'>Bibliography</h1>
              <div>
                <h2 class='Section3'>Bibliography Subsection</h2>
              </div>
            </div>
          </div>
        </body>
      </html>
    OUTPUT

    word = xmlpp(<<~"OUTPUT")
      <div>
           <div class='WordSection2'>
             <div>
               <p>
                 <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
               </p>
               <p class='AbstractTitle'>Summary</p>
               <p id='A3'>Text</p>
             </div>
             <div>
               <p>
                 <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
               </p>
               <p class='ForewordTitle'>Foreword</p>
               <p id='A1'>Text</p>
             </div>
             <div class='Section3' id='B'>
               <p>
                 <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
               </p>
               <p class='IntroTitle'>Introduction</p>
               <div id='C'>
                 <h2>Introduction Subsection</h2>
                 <p id='A2'>Text</p>
               </div>
             </div>
             <p>&#160;</p>
           </div>
           <p>
             <br clear='all' class='section'/>
           </p>
           <div class='WordSection3'>
             <div id='H'>
               <h1>
                 I.
                 <span style='mso-tab-count:1'>&#160; </span>
                 Terms, Definitions, Symbols and Abbreviated Terms
               </h1>
               <div id='I'>
                 <h2>
                   A.
                   <span style='mso-tab-count:1'>&#160; </span>
                   Normal Terms
                 </h2>
                 <p class='TermNum' id='J'>1.</p>
                 <p class='Terms' style='text-align:left;'>Term2</p>
               </div>
               <div id='K'>
                 <h2>B.</h2>
                 <table class='dl'>
                   <tr>
                     <td valign='top' align='left'>
                       <p align='left' style='margin-left:0pt;text-align:left;'>Symbol</p>
                     </td>
                     <td valign='top'>Definition</td>
                   </tr>
                 </table>
               </div>
             </div>
             <div id='D'>
               <h1>
                 1.
                 <span style='mso-tab-count:1'>&#160; </span>
                 Scope
               </h1>
               <p id='A4'>Text</p>
             </div>
             <div id='M'>
               <h1>
                 III.
                 <span style='mso-tab-count:1'>&#160; </span>
                 Clause 4
               </h1>
               <div id='N'>
                 <h2>
                   2.
                   <span style='mso-tab-count:1'>&#160; </span>
                   Introduction
                 </h2>
                 <p id='A5'>Text</p>
               </div>
               <div id='O'>
                 <h2>
                   A.
                   <span style='mso-tab-count:1'>&#160; </span>
                   Clause 4.2
                 </h2>
                 <div id='O1'>
                   <h3>
                     1.
                     <span style='mso-tab-count:1'>&#160; </span>
                     Clause 4.2.1
                   </h3>
                   <div id='O11'>
                     <h4>
                       3.
                       <span style='mso-tab-count:1'>&#160; </span>
                       Clause 4 Leaf
                     </h4>
                     <p id='A6'>Text</p>
                   </div>
                 </div>
               </div>
             </div>
             <p>
               <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
             </p>
             <div id='P' class='Section3'>
               <h1 class='Annex'>
                 <b>Annex I</b>
                 <br/>
                 <b>Annex</b>
               </h1>
               <div id='Q'>
                 <h2>
                   1.
                   <span style='mso-tab-count:1'>&#160; </span>
                   Annex A.1
                 </h2>
                 <div id='Q1'>
                   <h3>
                     I.
                     <span style='mso-tab-count:1'>&#160; </span>
                     Annex A.1a
                   </h3>
                   <div id='Q11'>
                     <h4>
                       1.
                       <span style='mso-tab-count:1'>&#160; </span>
                       Annex A Leaf
                     </h4>
                     <p id='A7'>Text</p>
                   </div>
                 </div>
               </div>
             </div>
             <p>
               <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
             </p>
             <div id='U' class='Section3'>
               <h1 class='Annex'>
                 <b>Annex II</b>
                 <br/>
                 <b>Terminal annex</b>
               </h1>
               <p id='A8'>Text</p>
             </div>
             <p>
               <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
             </p>
             <div>
               <h1 class='Section3'>Bibliography</h1>
               <div>
                 <h2 class='Section3'>Bibliography Subsection</h2>
               </div>
             </div>
           </div>
         </div>
    OUTPUT
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({}).convert("test", presxml, true))).to be_equivalent_to xmlpp(html)
    expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", presxml, true).sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">').sub(%r{<v:line.*$}m, "</div></div>"))).to be_equivalent_to xmlpp(word)
  end

  it "processes cross-references to section names" do
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", <<~INPUT, true))).to be_equivalent_to <<~OUTPUT
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
      <un-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
             <preface>
               <foreword id='A' obligation='informative'>
                 <title>Foreword</title>
                 <p>
                   <xref target='A'>Foreword</xref>
                   <xref target='B'>Introduction</xref>
                   <xref target='C'>Introduction Subsection</xref>
                   <xref target='AA'>Abstract</xref>
                   <xref target='H'>Clause I</xref>
                   <xref target='I'>Clause I.A</xref>
                   <xref target='J'>Clause I.A.1</xref>
                   <xref target='K'>Clause I.B</xref>
                   <xref target='D'>paragraph 1</xref>
                   <xref target='M'>Clause III</xref>
                   <xref target='N'>paragraph 2</xref>
                   <xref target='O'>Clause III.A</xref>
                   <xref target='O1'>Clause III.A.1</xref>
                   <xref target='O11'>paragraph 3</xref>
                   <xref target='P'>Annex I</xref>
                   <xref target='Q'>Annex I.1</xref>
                   <xref target='Q1'>Annex I.1.I</xref>
                   <xref target='Q11'>paragraph I.1.I.A.1</xref>
                   <xref target='U'>Annex II</xref>
                   <xref target='R'>Normative References</xref>
                   <xref target='S'>Bibliography</xref>
                   <xref target='T'>Bibliography Subsection</xref>
                 </p>
               </foreword>
               <introduction id='B' obligation='informative'>
                 <title>Introduction</title>
                 <clause id='C' inline-header='false' obligation='informative'>
                   <title depth='2'>Introduction Subsection</title>
                   <p id='X1'/>
                   <p id='X2'/>
                 </clause>
               </introduction>
               <abstract id='AA' obligation='informative'>
                 <p id='X3'/>
                 <p id='X4'/>
               </abstract>
             </preface>
             <sections>
               <clause id='H' obligation='normative'>
                 <title depth='1'>
                   I.
                   <tab/>
                   Terms, Definitions, Symbols and Abbreviated Terms
                 </title>
                 <terms id='I' obligation='normative'>
                   <title depth='2'>
                     A.
                     <tab/>
                     Normal Terms
                   </title>
                   <term id='J'>
                     <name>1.</name>
                     <preferred>Term2</preferred>
                   </term>
                 </terms>
                 <definitions id='K'>
                   <title>B.</title>
                   <dl>
                     <dt>Symbol</dt>
                     <dd>Definition</dd>
                   </dl>
                 </definitions>
               </clause>
               <clause id='D' obligation='normative'>
                 <title depth='1'>
                   1.
                   <tab/>
                   Scope
                 </title>
                 <p id='X5'/>
                 <p id='X6'/>
               </clause>
               <clause id='M' inline-header='false' obligation='normative'>
                 <title depth='1'>
                   III.
                   <tab/>
                   Clause 4
                 </title>
                 <p id='X6a'/>
                 <clause id='N' inline-header='false' obligation='normative'>
                   <title depth='2'>
                     2.
                     <tab/>
                     Introduction
                   </title>
                   <p id='X7'/>
                   <p id='X8'/>
                 </clause>
                 <clause id='O' inline-header='false' obligation='normative'>
                   <title depth='2'>
                     A.
                     <tab/>
                     Clause 4.2
                   </title>
                   <p id='X9'/>
                   <p id='X10'/>
                   <clause id='O1' inline-header='false' obligation='normative'>
                     <title depth='3'>
                       1.
                       <tab/>
                       Clause 4.2.1
                     </title>
                     <p id='X11'/>
                     <p id='X12'/>
                     <clause id='O11' inline-header='false' obligation='normative'>
                       <title depth='4'>
                         3.
                         <tab/>
                         Clause 4 Leaf
                       </title>
                       <p id='X13'/>
                       <p id='X14'/>
                     </clause>
                   </clause>
                 </clause>
               </clause>
             </sections>
             <annex id='P' inline-header='false' obligation='normative'>
               <title>
                 <strong>Annex I</strong>
                 <br/>
                 <strong>Annex</strong>
               </title>
               <p id='X15'/>
               <p id='X16'/>
               <clause id='Q' inline-header='false' obligation='normative'>
                 <title depth='2'>
                   1.
                   <tab/>
                   Annex A.1
                 </title>
                 <p id='X17'/>
                 <p id='X18'/>
                 <clause id='Q1' inline-header='false' obligation='normative'>
                   <title depth='3'>
                     I.
                     <tab/>
                     Annex A.1a
                   </title>
                   <p id='X19'/>
                   <p id='X20'/>
                   <clause id='Q11' inline-header='false' obligation='normative'>
                     <title depth='4'>
                       1.
                       <tab/>
                       Annex A Leaf
                     </title>
                     <p id='X21'/>
                     <p id='X22'/>
                   </clause>
                 </clause>
               </clause>
             </annex>
             <annex id='U' inline-header='false' obligation='normative'>
               <title>
                 <strong>Annex II</strong>
                 <br/>
                 <strong>Terminal annex</strong>
               </title>
               <p id='X23'/>
               <p id='X24'/>
             </annex>
             <bibliography>
               <references id='R' obligation='informative' normative='true'>
                 <title depth='1'>Normative References</title>
               </references>
               <clause id='S' obligation='informative'>
                 <title depth='1'>Bibliography</title>
                 <references id='T' obligation='informative' normative='false'>
                   <title depth='2'>Bibliography Subsection</title>
                 </references>
               </clause>
             </bibliography>
           </un-standard>
    OUTPUT
  end

  it "processes section names, suppressing section numbering" do
    input = <<~"INPUT"
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
      <un-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
           <foreword obligation="informative">
              <title>Foreword</title>
              <p id="A">This is a preamble</p>
            </foreword>
             <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
              <title depth="2">Introduction Subsection</title>
            </clause>
            </introduction>
            <abstract obligation="informative">
         <title>Summary</title>
            <p id="AA">This is an abstract</p>
            </abstract>
            <clause id="H" obligation="normative"><title depth="1">Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
              <title depth="2">Normal Terms</title>
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
              <title depth="1">Scope</title>
              <p id="E">Text</p>
            </clause>

            <clause id="M" inline-header="false" obligation="normative"><title depth="1">Clause 4</title><clause id="N" inline-header="false" obligation="normative">
              <title depth="2">Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">Clause 4.2</title>
            </clause></clause>

            </sections><annex id="P" inline-header="false" obligation="normative">
              <title><strong>Annex I</strong><br/><strong>Annex</strong></title>
              <clause id="Q" inline-header="false" obligation="normative">
              <title depth="2">Annex A.1</title>
              <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">Annex A.1a</title>
              </clause>
            </clause>
            </annex><bibliography><references id="R" obligation="informative" normative="true">
              <title depth="1">Normative References</title>
            </references><clause id="S" obligation="informative">
              <title depth="1">Bibliography</title>
              <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
            </clause>
            </bibliography>
            </un-standard>
    OUTPUT

    html = xmlpp(<<~"OUTPUT")
              #{HTML_HDR}
                   <br/>
                   <div>
                     <h1 class="AbstractTitle">Summary</h1>
                     <p id="AA">This is an abstract</p>
                   </div>
                   <br/>
                   <div>
                     <h1 class="ForewordTitle">Foreword</h1>
                     <p id="A">This is a preamble</p>
                   </div>
                   <br/>
                   <div class="Section3" id="B">
                     <h1 class="IntroTitle">Introduction</h1>
                     <div id="C"><h2>Introduction Subsection</h2>
            </div>
          </div>
          <br/>
          <div class='Section3' id='H'>
            <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
            <div id='I'>
              <h2>Normal Terms</h2>
              <p class='TermNum' id='J'/>
              <p class='Terms' style='text-align:left;'>Term2</p>
            </div>
            <div id='K'>
              <h2>Symbols</h2>
              <dl>
                <dt>
                  <p>Symbol</p>
                </dt>
                <dd>Definition</dd>
              </dl>
                </div>
                   </div>
                   <div id="D">
                     <h1>Scope</h1>
                     <p id="E">Text</p>
                   </div>
                   <div id="M">
                     <h1>Clause 4</h1>
                     <div id="N"><h2>Introduction</h2>
                </div>
                     <div id="O"><h2>Clause 4.2</h2>
                </div>
                   </div>
                   <br/>
                   <div id="P" class="Section3">
                   <h1 class='Annex'>
        <b>Annex I</b>
        <br/>
        <b>Annex</b>
      </h1>
                     <div id="Q"><h2>Annex A.1</h2>
                  <div id="Q1"><h3>Annex A.1a</h3>
                  </div>
                </div>
                   </div>
                   <br/>
                   <div>
                     <h1 class="Section3">Bibliography</h1>
                     <div>
                       <h2 class="Section3">Bibliography Subsection</h2>
                     </div>
                   </div>
                 </div>
               </body>
             </html>
    OUTPUT

    word = xmlpp(<<~"OUTPUT")
       <div>
        <div class='WordSection2'>
          <div>
            <p>
              <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
            </p>
            <p class='AbstractTitle'>Summary</p>
            <p id='AA'>This is an abstract</p>
          </div>
          <div>
            <p>
              <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
            </p>
            <p class='ForewordTitle'>Foreword</p>
            <p id='A'>This is a preamble</p>
          </div>
          <div class='Section3' id='B'>
            <p>
              <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
            </p>
            <p class='IntroTitle'>Introduction</p>
            <div id='C'>
              <h2>Introduction Subsection</h2>
            </div>
          </div>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='Section3' id='H'>
            <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
            <div id='I'>
              <h2>Normal Terms</h2>
              <p class='TermNum' id='J'/>
              <p class='Terms' style='text-align:left;'>Term2</p>
            </div>
            <div id='K'>
              <h2>Symbols</h2>
              <table class='dl'>
                <tr>
                  <td valign='top' align='left'>
                    <p align='left' style='margin-left:0pt;text-align:left;'>Symbol</p>
                  </td>
                  <td valign='top'>Definition</td>
                </tr>
              </table>
            </div>
          </div>
          <p>&#160;</p>
        </div>
        <p>
          <br clear='all' class='section'/>
        </p>
        <div class='WordSection3'>
          <div id='D'>
            <h1>Scope</h1>
            <p id='E'>Text</p>
          </div>
          <div id='M'>
            <h1>Clause 4</h1>
            <div id='N'>
              <h2>Introduction</h2>
            </div>
            <div id='O'>
              <h2>Clause 4.2</h2>
            </div>
          </div>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div id='P' class='Section3'>
            <h1 class='Annex'>
              <b>Annex I</b>
              <br/>
              <b>Annex</b>
            </h1>
            <div id='Q'>
              <h2>Annex A.1</h2>
              <div id='Q1'>
                <h3>Annex A.1a</h3>
              </div>
            </div>
          </div>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div>
            <h1 class='Section3'>Bibliography</h1>
            <div>
              <h2 class='Section3'>Bibliography Subsection</h2>
            </div>
          </div>
        </div>
      </div>
    OUTPUT

    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({ suppressheadingnumbers: true }).convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({ suppressheadingnumbers: true }).convert("test", presxml, true))).to be_equivalent_to xmlpp(html)
    expect(xmlpp(IsoDoc::UN::WordConvert.new({ suppressheadingnumbers: true }).convert("test", presxml, true).sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">').sub(%r{<v:line.*$}m, "</div></div>"))).to be_equivalent_to xmlpp(word)
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{BLANK_HDR}
      <sections/>
      </un-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :un, header_footer: true)))).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Roboto})
  end

  it "processes admonitions" do
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword id="FF">
        <p>
        <xref target="B"/>
        <xref target="B1"/>
        <xref target="E"/>
        <xref target="E1"/>
        </p>
        </foreword>
        </preface>
        <sections>
          <clause id="A">
          <admonition id="B" unnumbered="true">
            <name>First Box</name>
            <p id="C">paragraph</p>
          </admonition>
          </clause>
          <clause id="A1">
          <admonition id="B1">
            <name>Second Box</name>
            <p id="C1">paragraph</p>
          </admonition>
          </clause>
        </sections>
        <annex id="D"><title>First Annex</title>
          <admonition id="E">
            <name>Third Box</name>
            <p id="F">paragraph</p>
          </admonition>
        </annex>
        <annex id="D1"><title>Second Annex</title>
          <admonition id="E1">
            <name>Fourth Box</name>
            <p id="F1">paragraph</p>
          </admonition>
        </annex>
      </un-standard>
    INPUT

    presxml = <<~OUTPUT
      <un-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <preface>
          <foreword id="FF">
          <p>
            <xref target='B'>Box (??)</xref>
            <xref target='B1'>Box 1</xref>
            <xref target='E'>Box I.1</xref>
            <xref target='E1'>Box II.1</xref>
          </p>
          </foreword>
        </preface>
        <sections>
          <clause id='A'>
          <title>I.</title>
            <admonition id='B' unnumbered='true'>
              <name>First Box</name>
              <p id='C'>paragraph</p>
            </admonition>
          </clause>
          <clause id='A1'>
           <title>II.</title>
            <admonition id='B1'>
              <name>Box 1&#xA0;&#x2014; Second Box</name>
              <p id='C1'>paragraph</p>
            </admonition>
          </clause>
        </sections>
        <annex id='D'>
        <title><strong>Annex I</strong><br/><strong>First Annex</strong></title>
          <admonition id='E'>
            <name>Box I.1&#xA0;&#x2014; Third Box</name>
            <p id='F'>paragraph</p>
          </admonition>
        </annex>
        <annex id='D1'>
        <title><strong>Annex II</strong><br/><strong>Second Annex</strong></title>
          <admonition id='E1'>
            <name>Box II.1&#xA0;&#x2014; Fourth Box</name>
            <p id='F1'>paragraph</p>
          </admonition>
        </annex>
      </un-standard>
    OUTPUT

    html = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
        <br/>
      <div id='FF'>
        <h1 class='ForewordTitle'>Foreword</h1>
        <p>
          <a href='#B'>Box (??)</a>
          <a href='#B1'>Box 1</a>
          <a href='#E'>Box I.1</a>
          <a href='#E1'>Box II.1</a>
        </p>
      </div>
                     <div id="A">
                     <h1>I.</h1>
                     <div id="B" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">First Box</p>
                   <p id="C">paragraph</p>
                 </div>
                   </div>
                   <div id="A1">
                     <h1>II.</h1>
                     <div id="B1" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box 1&#160;&#8212; Second Box</p>
                   <p id="C1">paragraph</p>
                 </div>
                   </div>
                   <br/>
                   <div id="D" class="Section3">
                     <h1 class="Annex"><b>Annex I</b><br/><b>First Annex</b></h1>
                     <div id="E" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box I.1&#160;&#8212; Third Box</p>
                   <p id="F">paragraph</p>
                 </div>
                   </div>
                   <br/>
                   <div id="D1" class="Section3">
                     <h1 class="Annex"><b>Annex II</b><br/><b>Second Annex</b></h1>
                     <div id="E1" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box II.1&#160;&#8212; Fourth Box</p>
                   <p id="F1">paragraph</p>
                 </div>
                   </div>
                 </div>
               </body>
             </html>
    OUTPUT
    word = xmlpp(<<~"OUTPUT")
      <div class='WordSection3'>
           <div id='A'>
             <h1>I.</h1>
             <div id='B' class='Admonition'>
               <p class='AdmonitionTitle' style='text-align:center;'>First Box</p>
               <p id='C'>paragraph</p>
             </div>
           </div>
           <div id='A1'>
             <h1>II.</h1>
             <div id='B1' class='Admonition'>
               <p class='AdmonitionTitle' style='text-align:center;'>Box 1&#160;&#8212; Second Box</p>
               <p id='C1'>paragraph</p>
             </div>
           </div>
           <p>
             <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
           </p>
           <div id='D' class='Section3'>
             <h1 class='Annex'>
               <b>Annex I</b>
               <br/>
               <b>First Annex</b>
             </h1>
             <div id='E' class='Admonition'>
               <p class='AdmonitionTitle' style='text-align:center;'>Box I.1&#160;&#8212; Third Box</p>
               <p id='F'>paragraph</p>
             </div>
           </div>
           <p>
             <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
           </p>
           <div id='D1' class='Section3'>
             <h1 class='Annex'>
               <b>Annex II</b>
               <br/>
               <b>Second Annex</b>
             </h1>
             <div id='E1' class='Admonition'>
               <p class='AdmonitionTitle' style='text-align:center;'>Box II.1&#160;&#8212; Fourth Box</p>
               <p id='F1'>paragraph</p>
             </div>
           </div>
         </div>
    OUTPUT
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", input, true))).to be_equivalent_to presxml
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({}).convert("test", presxml, true))).to be_equivalent_to html
    expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", presxml, true).sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, "</div>"))).to be_equivalent_to word
  end

  it "processes inline section headers" do
    expect(xmlpp(IsoDoc::UN::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
       <clause id="M" inline-header="false" obligation="normative"><title>I.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>A.<tab/>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>B.<tab/>Clause 4.2</title>
       </clause></clause>

       </sections>
      </un-standard>
    INPUT
      #{HTML_HDR}
                 <div id="M">
                   <h1>I.&#160; Clause 4</h1>
                   <div id="N"><h2>A.&#160; Introduction</h2>

            </div>
                   <div id="O"><span class="zzMoveToFollowing">B.&#160; Clause 4.2&#160; </span>

            </div>
                 </div>
               </div>
             </body>
           </html>
    OUTPUT
  end

  it "does not switch plenary title page in HTML" do
    FileUtils.rm_f("test.html")
    input = <<~"INPUT"
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
    expect(html).not_to include "<div id='abstractbox'"
  end

  it "switch to plenary title page in DOC" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
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
    expect(html).to include "This is a plenary page"
  end

  it "switch to plenary title page in DOC if any bibdata/ext/section" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
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
    expect(html).to include "This is a plenary page"
  end

  it "does not switch plenary title page in DOC if no bibdata/ext/section" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
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
    expect(html).not_to include "This is a plenary page"
  end

  it "processes bibliography" do
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", <<~INPUT, true))).to be_equivalent_to <<~OUTPUT
          <un-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <clause>
          <eref bibitemid="ISO712"/>
          </clause>
          </sections>
          <bibliography><references id="R" obligation="informative" normative="true">
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
      <?xml version='1.0'?>
      <un-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <sections>
          <clause>
            <eref bibitemid='ISO712'>ISO 712</eref>
          </clause>
        </sections>
        <bibliography>
          <references id='R' obligation='informative' normative='true'>
            <title depth="1">Normative References</title>
            <bibitem id='ISO712' type='standard'>
              <title format='text/plain'>Cereals and cereal products</title>
              <docidentifier type='ISO'>ISO 712</docidentifier>
              <contributor>
                <role type='publisher'/>
                <organization>
                  <name>International Organization for Standardization</name>
                </organization>
              </contributor>
            </bibitem>
          </references>
        </bibliography>
      </un-standard>
    OUTPUT
  end

  it "processes note types" do
    expect(xmlpp(IsoDoc::UN::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).sub(%r{<localized-strings>.*</localized-strings>}m, ""))).to be_equivalent_to <<~"OUTPUT"
          <un-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <note type="title-footnote"><p>ABC</p></note>
          </bibdata>
          <sections>
          <clause>
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
      <?xml version='1.0'?>
      <un-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata>
        <note type='title-footnote'>
          <p>ABC</p>
        </note>
      </bibdata>
        <sections>
          <clause>
            <note type='source' id='A'>
              <name>Source</name>
              <p>Source</p>
            </note>
            <note type='abbreviation' id='B'>
              <name>Abbreviations</name>
              <p>Source</p>
            </note>
            <note type='source' id='C'>
              <name>Source</name>
              <p>Source</p>
            </note>
            <note type='abbreviation' id='D'>
              <name>Abbreviations</name>
              <p>Source</p>
            </note>
            <note id='E'>
              <name>NOTE</name>
              <p>Source</p>
            </note>
          </clause>
        </sections>
      </un-standard>
    OUTPUT
  end
end
