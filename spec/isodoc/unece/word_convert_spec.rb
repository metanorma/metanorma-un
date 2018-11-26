require "spec_helper"

RSpec.describe IsoDoc::Unece do

  it "processes default metadata, recommendation" do
    csdc = IsoDoc::Unece::WordConvert.new({toc: true})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="recommendation">
  <title language="en" format="plain">Main Title</title>
  <subtitle language="en" format="plain">Subtitle</title>
  <docidentifier>1000</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status format="plain">working-draft</status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <security>Client Confidential</security>
</bibdata><version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
<sections/>
</unece-standard>
    INPUT

    output = <<~"OUTPUT"
    {:accesseddate=>"XXX", :confirmeddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000", :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Recommendation", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :editorialgroup=>[], :formatted_docnumber=>"UN/CEFACT Recommendation 1000", :ics=>"XXX", :implementeddate=>"XXX", :issueddate=>"XXX", :language=>"en", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"XXX", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :sc=>"XXXX", :secretariat=>"XXXX", :session_agendaitem=>nil, :session_collaborator=>nil, :session_date=>nil, :session_distribution=>nil, :session_id=>nil, :session_number=>nil, :status=>"Working Draft", :tc=>"TC", :toc=>true, :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

    it "processes default metadata, plenary" do
    csdc = IsoDoc::Unece::WordConvert.new({toc: true})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="plenary">
  <title language="en" format="plain">Main Title</title>
  <subtitle language="en" format="plain">Subtitle</title>
  <docidentifier>1000(wd)</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status format="plain">working-draft</status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  <session>
  <number>3</number>
  <date>2001-01-01</date>
  <agenda_item>5</agenda_item>
  <collaborator>WHO</collaborator>
  <id>WHO-UNECE-01</id>
  <distribution>public</distribution>
  </session>
</bibdata><version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
<sections/>
</unece-standard>
    INPUT

    output = <<~"OUTPUT"
    {:accesseddate=>"XXX", :confirmeddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000(wd)", :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Plenary", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :editorialgroup=>[], :formatted_docnumber=>"1000(wd)", :ics=>"XXX", :implementeddate=>"XXX", :issueddate=>"XXX", :language=>"en", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"XXX", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :sc=>"XXXX", :secretariat=>"XXXX", :session_agendaitem=>"5", :session_collaborator=>"WHO", :session_date=>"2001-01-01", :session_distribution=>"public", :session_id=>"WHO-UNECE-01", :session_number=>"Third", :status=>"Working Draft", :tc=>"TC", :toc=>true, :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

  it "processes section names" do
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
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
       <p id="AA">This is an abstract</o>
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
        <bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </unece-standard>
    INPUT

    output = <<~"OUTPUT"
           <div class="WordSection3">
             <div>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="AbstractTitle">Summary</p>
               <p id="AA">This is an abstract</p>
             </div>
             <div>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="ForewordTitle">Foreword</p>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3" id="B">
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="IntroTitle">Introduction</p>
               <div id="C"><h2><span style="mso-tab-count:1">&#160; </span>Introduction Subsection</h2>

          </div>
             </div>
             <p>&#160;</p>
           </div>
           <br clear="all" class="section"/>
           <div class="WordSection3"><div id="D"><h1>1.<span style="mso-tab-count:1">&#160; </span>Scope</h1><p id="E">Text</p></div><div id="M"><h1>II.<span style="mso-tab-count:1">&#160; </span>Clause 4</h1><div id="N"><h2>2. <span style="mso-tab-count:1">&#160; </span>Introduction</h2>

          </div><div id="O"><h2>A. <span style="mso-tab-count:1">&#160; </span>Clause 4.2</h2>

            <div id="O1"><h3>1. <span style="mso-tab-count:1">&#160; </span>Clause 4.2.1</h3>

            <div id="O11"><h4>3. <span style="mso-tab-count:1">&#160; </span>Clause 4 Leaf</h4>

            </div>
            </div>
          </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div id="P" class="Section3"><h1 class="Annex"><b>Annex I</b><br/><b>Annex</b></h1><div id="Q"><h2>1. <span style="mso-tab-count:1">&#160; </span>Annex A.1</h2>

            <div id="Q1"><h3>I. <span style="mso-tab-count:1">&#160; </span>Annex A.1a</h3>

            <div id="Q11"><h4>1. <span style="mso-tab-count:1">&#160; </span>Annex A Leaf</h4>

            </div>
            </div>
          </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div id="U" class="Section3"><h1 class="Annex">1<br/><b>Terminal annex</b></h1></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div><h1 class="Section3">Bibliography</h1><div><h2 class="Section3">Bibliography Subsection</h2></div></div>
    OUTPUT

    expect(IsoDoc::Unece::WordConvert.new({}).convert("test", input, true).sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '')).to be_equivalent_to output
end

  it "processes cross-references to section names" do
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
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
         <xref target="E"/>
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
       </clause>
       </introduction>
       <abstract id="AA" obligation="informative">
       <p>This is an abstract</o>
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
        <bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </unece-standard>
    INPUT

    output = <<~"OUTPUT"
             <div id="A">
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="ForewordTitle">Foreword</p>
               <p>
            <a href="#A">Foreword</a>
            <a href="#B">Introduction</a>
            <a href="#C">Introduction Subsection</a>
            <a href="#AA">AA</a>
            <a href="#H">H</a>
            <a href="#I">I</a>
            <a href="#J">J</a>
            <a href="#K">K</a>
            <a href="#D">paragraph 1</a>
            <a href="#E">E</a>
            <a href="#M">Clause II</a>
            <a href="#N">paragraph 2</a>
            <a href="#O">Clause II.A</a>
            <a href="#O1">Clause II.A.1</a>
            <a href="#O11">paragraph 3</a>
            <a href="#P">Annex I</a>
            <a href="#Q">Annex I.1</a>
            <a href="#Q1">Annex I.1.I</a>
            <a href="#Q11">paragraph I.1.I.A.1</a>
            <a href="#U">paragraph II.1</a>
            <a href="#R">R</a>
            <a href="#S">S</a>
            <a href="#T">T</a>
           </p>
             </div>
    OUTPUT

    expect(IsoDoc::Unece::WordConvert.new({}).
           convert("test", input, true).
           sub(%r{^.*<div id="A">}m, '<div id="A">').sub(%r{<div class="Section3".*$}m, '')
          ).to be_equivalent_to output
end

    it "processes section names, suppressing section numbering" do
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
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
       <p id="AA">This is an abstract</o>
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
       </annex><bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </unece-standard>
    INPUT

    output = <<~"OUTPUT"
           <div class="WordSection3">
             <div>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="AbstractTitle">Summary</p>
               <p id="AA">This is an abstract</p>
             </div>
             <div>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="ForewordTitle">Foreword</p>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3" id="B">
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="IntroTitle">Introduction</p>
               <div id="C"><h2><span style="mso-tab-count:1">&#160; </span>Introduction Subsection</h2>

          </div>
             </div>
             <p>&#160;</p>
           </div>
           <br clear="all" class="section"/>
           <div class="WordSection3"><div id="D"><h1>Scope</h1><p id="E">Text</p></div><div id="M"><h1>Clause 4</h1><div id="N"><h2><span style="mso-tab-count:1">&#160; </span>Introduction</h2>

          </div><div id="O"><h2><span style="mso-tab-count:1">&#160; </span>Clause 4.2</h2>

          </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div id="P" class="Section3"><h1 class="Annex"><b>Annex I</b><br/><b>Annex</b></h1><div id="Q"><h2><span style="mso-tab-count:1">&#160; </span>Annex A.1</h2>

            <div id="Q1"><h3><span style="mso-tab-count:1">&#160; </span>Annex A.1a</h3>

            </div>
          </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div><h1 class="Section3">Bibliography</h1><div><h2 class="Section3">Bibliography Subsection</h2></div></div>
       </div>
         </body>
       </html>
        OUTPUT
    expect(IsoDoc::Unece::WordConvert.new({suppressheadingnumbers: true}).convert("test", input, true).sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '')).to be_equivalent_to output
    end

it "processes admonitions" do
  input = <<~"INPUT"
  <unece-standard xmlns="http://riboseinc.com/isoxml">
    <preface>
    <xref target="B"/>
    <xref target="B1"/>
    <xref target="E"/>
    <xref target="E1"/>
    </preface>
    <sections>
      <clause id="A">
      <admonition id="B">
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
  </unece-standard>
  INPUT

  output = <<~"OUTPUT"
         <div class="WordSection3"><div id="A"><h1>1.<span style="mso-tab-count:1">&#160; </span></h1><div class="Admonition"><p class="FigureTitle" align="center">Box 1&#160;&#8212; First Box</p>

             <p id="C">paragraph</p>
           </div></div><div id="A1"><h1>2.<span style="mso-tab-count:1">&#160; </span></h1><div class="Admonition"><p class="FigureTitle" align="center">Box 2&#160;&#8212; Second Box</p>

             <p id="C1">paragraph</p>
           </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div id="D" class="Section3"><h1 class="Annex">1<br/><b>First Annex</b></h1><div class="Admonition"><p class="FigureTitle" align="center">Box I.1&#160;&#8212; Third Box</p>

             <p id="F">paragraph</p>
           </div></div><br clear="all" style="mso-special-character:line-break;page-break-before:always"/><div id="D1" class="Section3"><h1 class="Annex">1<br/><b>Second Annex</b></h1><div class="Admonition"><p class="FigureTitle" align="center">Box II.1&#160;&#8212; Fourth Box</p>

             <p id="F1">paragraph</p>
           </div></div>
       </div>
         </body>
       </html>
  OUTPUT
    expect(IsoDoc::Unece::WordConvert.new({}).convert("test", input, true).sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '')).to be_equivalent_to output
end

    it "processes inline section headers" do
      expect(IsoDoc::Unece::WordConvert.new({}).convert("test", <<~"INPUT", true).sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '')).to be_equivalent_to <<~"OUTPUT"
      <unece-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>

       </sections>
      </unece-standard>
    INPUT
           <div class="WordSection3"><div id="M"><h1>I.<span style="mso-tab-count:1">&#160; </span>Clause 4</h1><div id="N"><h2>1. <span style="mso-tab-count:1">&#160; </span>Introduction</h2>

        </div><div id="O"><span class="zzMoveToFollowing">2. <span style="mso-tab-count:1">&#160; </span>Clause 4.2 </span>

        </div></div>
       </div>
         </body>
       </html>
OUTPUT
    end


  it "uses plenary title page in DOC for plenaries" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="plenary">
  <title language="en" format="plain">Main Title</title>
  </bibdata>
  <sections/>
  </unece-standard>
INPUT
IsoDoc::Unece::WordConvert.new(toc: true).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).to include '<a name="abstractbox" id="abstractbox">'
  expect(html).to include 'class="zzContents"'
  end

  it "removes intro page page in DOC for plenaries with no ToC" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="plenary">
  <title language="en" format="plain">Main Title</title>
  </bibdata>
  <sections/>
  </unece-standard>
INPUT
IsoDoc::Unece::WordConvert.new(toc: false).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).to include '<a name="abstractbox" id="abstractbox">'
  expect(html).not_to include 'class="zzContents"'
  end


  it "does not used plenary title page in DOC for recommendations" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="recommendation">
  <title language="en" format="plain">Main Title</title>
  </bibdata>
  <sections/>
  </unece-standard>
INPUT
IsoDoc::Unece::WordConvert.new(toc: true).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).not_to include '<a name="abstractbox" id="abstractbox">'
  expect(html).to include 'preface_container'
  end

  it "processes bibliography" do
        input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <sections>
    <clause>
    <eref bibitemid="ISO712"/>
    </clause>
    </sections>
    <bibliography><references id="R" obligation="informative">
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
</unece-standard>
INPUT
  output = <<~"OUTPUT"
<div class="WordSection3"><div><h1>1.<span style="mso-tab-count:1">&#160; </span></h1><a href="#ISO712">ISO 712</a></div>  
</div>
  OUTPUT
  expect(IsoDoc::Unece::WordConvert.new({}).convert("test", input, true).
         sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').
         sub(%r{<v:line.*$}m, '')).to be_equivalent_to output
  end

  it "processes plenary preface" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="plenary"/>
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
       <p id="AA">This is an abstract</o>
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
INPUT
        IsoDoc::Unece::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          section1 = html.sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">').sub(%r{<div class="WordSection2">.*$}m, "")
          section2 = html.sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">').sub(%r{<div class="WordSection3">.*$}m, "")
          expect(section1).to include "This is an abstract"
          expect(section2).to be_equivalent_to <<~"OUTPUT"
          <div class="WordSection2">

      <div>
        <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
        <p class="ForewordTitle">Foreword</p>
        <p class="MsoNormal"><a name="A" id="A"></a>This is a preamble</p>
      </div>
      <div class="Section3"><a name="B" id="B"></a>
        <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
        <p class="IntroTitle">Introduction</p>
        <div><a name="C" id="C"></a><p class="h2Annex"><span style="mso-tab-count:1">&#xA0; </span>Introduction Subsection</p>

   </div>
      </div>
      <p class="MsoNormal">&#xA0;</p>
    </div>
    <br clear="all" class="section"/>
          OUTPUT

    end

  it "removes WordSection2 if empty" do
        FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="plenary"/>
      <preface>
        </preface><sections>
INPUT
        IsoDoc::Unece::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          expect(html).not_to include '<div class="WordSection2"'
  end

  it "does not removes WordSection2 if no preface but ToC" do
        FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="plenary"/>
      <preface>
        </preface><sections>
INPUT
        IsoDoc::Unece::WordConvert.new({toc: true}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")    
          expect(html).to include '<div class="WordSection2"'
  end

  it "processes recommendation preface" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="recommendation"/>
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
       <p id="AA">This is an abstract</o>
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
INPUT
        IsoDoc::Unece::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          section1 = html.sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">').sub(%r{<div class="WordSection2">.*$}m, "")
          section2 = html.sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">').sub(%r{<div class="WordSection3">.*$}m, "")
          expect(section1).not_to include "This is an abstract"
          expect(section2).to be_equivalent_to <<~"OUTPUT"
                 <div class="WordSection2">
       <div>
         <p class="MsoNormal"><b>Note</b>
         </p><p class="MsoNormal">The designations employed and the presentation of the material in this publication do not imply the expression of any opinion whatsoever on the part of the Secretariat of the United Nations concerning the legal status of any country, territory, city or area, or of its authorities, or concerning the delimitation of its frontiers or boundaries.</p>



         <p align="center" style="border:solid;" class="MsoNormal">ECE/TRADE/437</p>
         <p align="center" class="MsoNormal">Copyright &#xA9; United Nations <br/>
         All rights reserved worldwide<br/>
         United Nations publication issued by the Economic Commission for Europe</p>

       </div>

       <div><a name="preface_container" id="preface_container"></a><div>

               <p class="AbstractTitle">Summary</p>
               <p class="MsoNormal"><a name="AA" id="AA"></a>This is an abstract</p>
             </div><div>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="ForewordTitle">Foreword</p>
               <p class="MsoNormal"><a name="A" id="A"></a>This is a preamble</p>
             </div><div class="Section3"><a name="B" id="B"></a>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
               <p class="IntroTitle">Introduction</p>
               <div><a name="C" id="C"></a><p class="h2Annex"><span style="mso-tab-count:1">&#xA0; </span>Introduction Subsection</p>

          </div>
             </div></div>







             <p class="MsoNormal">&#xA0;</p>
           </div>
           <br clear="all" class="section"/>
          OUTPUT

    end

end
