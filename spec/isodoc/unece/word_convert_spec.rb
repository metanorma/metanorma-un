require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "isodoc", "un", "html"))

RSpec.describe IsoDoc::UN do

  it "processes default metadata, recommendation" do
    csdc = IsoDoc::UN::WordConvert.new({toc: true})
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
    {:accesseddate=>"XXX", :agency=>"UN", :authors=>[], :authors_affiliations=>{}, :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :distribution=>nil, :docnumber=>"1000", :docnumeric=>nil, :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Recommendation", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :edition=>"2", :formatted_docnumber=>"UN/CEFACT Recommendation 1000", :implementeddate=>"XXX", :issueddate=>"XXX", :item_footnote=>nil, :logo=>"#{File.join(logoloc, "logo.jpg")}", :obsoleteddate=>"XXX", :publisheddate=>"XXX", :publisher=>"United Nations", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :session_collaborator=>nil, :session_date=>nil, :session_id=>nil, :session_id_head=>nil, :session_id_tail=>nil, :session_itemname=>[], :session_itemnumber=>[], :session_number=>nil, :session_subitemname=>[], :stage=>"Working Draft", :stageabbr=>"wd", :submissionlanguage=>["German"], :tc=>"TC", :toc=>true, :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :vote_endeddate=>"XXX", :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

    it "processes default metadata, plenary" do
    csdc = IsoDoc::UN::WordConvert.new({toc: true})
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
    {:accesseddate=>"XXX", :agency=>"UN", :authors=>[], :authors_affiliations=>{}, :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :distribution=>nil, :doclanguage=>["English", "French"], :docnumber=>"1000(wd)", :docnumeric=>nil, :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Plenary", :docyear=>"2001", :draft=>nil, :draftinfo=>"", :edition=>nil, :formatted_docnumber=>"1000(wd)", :implementeddate=>"XXX", :issueddate=>"XXX", :item_footnote=>nil, :logo=>"#{File.join(logoloc, "logo.jpg")}", :obsoleteddate=>"XXX", :publisheddate=>"XXX", :publisher=>"United Nations", :receiveddate=>"XXX", :revdate=>nil, :revdate_monthyear=>nil, :session_collaborator=>"WHO", :session_date=>"2001-01-01", :session_id=>"ECE/WHO-UNECE-01", :session_id_head=>"ECE", :session_id_tail=>"/WHO-UNECE-01", :session_itemname=>[], :session_itemnumber=>[], :session_number=>"Third", :session_subitemname=>[], :stage=>"Working Draft", :stageabbr=>"wd", :tc=>"TC", :toc=>true, :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :vote_endeddate=>"XXX", :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

  it "processes section names" do
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

    output = xmlpp(<<~"OUTPUT")
    <div>
           <div class="WordSection2">
             <div>
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="AbstractTitle">Summary</p>
               <p id="AA">This is an abstract</p>
             </div>
             <div>
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="ForewordTitle">Foreword</p>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3" id="B">
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="IntroTitle">Introduction</p>
               <div id="C"><h2>Introduction Subsection</h2>

          </div>
             </div>
               <p>
    <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
  </p>
  <div class='Section3' id='H'>
    <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
    <div id='I'>
      <h2>Normal Terms</h2>
      <p class='TermNum' id='J'>.</p>
      <p class='Terms' style='text-align:left;'>Term2</p>
    </div>
    <div id='K'>
      <h2>Symbols and abbreviated terms</h2>
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
           <p><br clear="all" class="section"/></p>
           <div class="WordSection3"><div id="D"><h1>1.<span style="mso-tab-count:1">&#160; </span>Scope</h1><p id="E">Text</p></div><div id="M"><h1>II.<span style="mso-tab-count:1">&#160; </span>Clause 4</h1><div id="N"><h2>A. <span style="mso-tab-count:1">&#160; </span>Introduction</h2>

          </div><div id="O"><h2>B. <span style="mso-tab-count:1">&#160; </span>Clause 4.2</h2>

            <div id="O1"><h3>1. <span style="mso-tab-count:1">&#160; </span>Clause 4.2.1</h3>

            <div id="O11"><h4>I. <span style="mso-tab-count:1">&#160; </span>Clause 4 Leaf</h4>

            </div>
            </div>
          </div></div><p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p><div id="P" class="Section3"><h1 class="Annex"><b>Annex I</b><br/><b>Annex</b></h1><div id="Q"><h2>1. <span style="mso-tab-count:1">&#160; </span>Annex A.1</h2>

            <div id="Q1"><h3>I. <span style="mso-tab-count:1">&#160; </span>Annex A.1a</h3>

            <div id="Q11"><h4>A. <span style="mso-tab-count:1">&#160; </span>Annex A Leaf</h4>

            </div>
            </div>
          </div></div><p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p><div id="U" class="Section3"><h1 class="Annex"><b>Annex II</b><br/><b>Terminal annex</b></h1></div><p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p><div><h1 class="Section3">Bibliography</h1><div><h2 class="Section3">Bibliography Subsection</h2></div></div>
          </div></div>
    OUTPUT

    expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", input, true).sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">').sub(%r{<v:line.*$}m, '</div></div>'))).to be_equivalent_to output
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

    output = xmlpp(<<~"OUTPUT")
    <div>
           <div class="WordSection2">
             <div>
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="AbstractTitle">Summary</p>
               <p id="AA">This is an abstract</p>
             </div>
             <div>
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="ForewordTitle">Foreword</p>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3" id="B">
               <p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="IntroTitle">Introduction</p>
               <div id="C"><h2>Introduction Subsection</h2>

          </div>
             </div>
                 <p>
      <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
    </p>
    <div class='Section3' id='H'>
      <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
      <div id='I'>
        <h2>Normal Terms</h2>
        <p class='TermNum' id='J'>.</p>
        <p class='Terms' style='text-align:left;'>Term2</p>
      </div>
      <div id='K'>
        <h2>Symbols and abbreviated terms</h2>
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
           <p><br clear="all" class="section"/></p>
        <div class='WordSection3'>
           <div id='D'>
             <h1>
               1.
               <span style='mso-tab-count:1'>&#160; </span>
               Scope
             </h1>
             <p id='E'>Text</p>
           </div>
           <div id='M'>
             <h1>
               II.
               <span style='mso-tab-count:1'>&#160; </span>
               Clause 4
             </h1>
             <div id='N'>
               <h2>
                 A. 
                 <span style='mso-tab-count:1'>&#160; </span>
                 Introduction
               </h2>
             </div>
             <div id='O'>
               <h2>
                 B. 
                 <span style='mso-tab-count:1'>&#160; </span>
                 Clause 4.2
               </h2>
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
    expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", input, true).sub(%r{^.*<div class="WordSection2">}m, '<div><div class="WordSection2">').sub(%r{<v:line.*$}m, '</div></div>'))).to be_equivalent_to output
    end

it "processes admonitions" do
  input = <<~"INPUT"
  <un-standard xmlns="http://riboseinc.com/isoxml">
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
  </un-standard>
  INPUT

  output = xmlpp(<<~"OUTPUT")
         <div class="WordSection3"><div id="A"><h1>I.<span style="mso-tab-count:1">&#160; </span></h1><div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box 1&#160;&#8212; First Box</p>

             <p id="C">paragraph</p>
           </div></div><div id="A1"><h1>II.<span style="mso-tab-count:1">&#160; </span></h1><div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box 2&#160;&#8212; Second Box</p>

             <p id="C1">paragraph</p>
           </div></div><p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p><div id="D" class="Section3"><h1 class="Annex"><b>Annex I</b><br/><b>First Annex</b></h1><div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box I.1&#160;&#8212; Third Box</p>

             <p id="F">paragraph</p>
           </div></div><p><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p><div id="D1" class="Section3"><h1 class="Annex"><b>Annex II</b><br/><b>Second Annex</b></h1><div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box II.1&#160;&#8212; Fourth Box</p>

             <p id="F1">paragraph</p>
           </div></div>
       </div>
  OUTPUT
    expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", input, true).sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '</div>'))).to be_equivalent_to output
end

    it "processes inline section headers" do
      expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", <<~"INPUT", true).sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').sub(%r{<v:line.*$}m, '</div>'))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>

       </sections>
      </un-standard>
    INPUT
           <div class="WordSection3"><div id="M"><h1>I.<span style="mso-tab-count:1">&#160; </span>Clause 4</h1><div id="N"><h2>A. <span style="mso-tab-count:1">&#160; </span>Introduction</h2>

        </div><div id="O"><span class="zzMoveToFollowing">B. <span style="mso-tab-count:1">&#160; </span>Clause 4.2 </span>

        </div></div>
       </div>
OUTPUT
    end


  it "uses plenary title page in DOC for plenaries" do
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
IsoDoc::UN::WordConvert.new(toc: true).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).to include 'This is a plenary page'
  expect(html).to include 'class="zzContents"'
  end

  it "removes intro page page in DOC for plenaries with no ToC" do
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
IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).to include 'This is a plenary page'
  expect(html).not_to include 'class="zzContents"'
  end

   it "populates abstract box if there is an abstract" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
<un-standard xmlns="https://www.metanorma.org/ns/un">
<bibdata type="standard">
  <title language="en" format="plain">Main Title</title>
  <ext><doctype>plenary</doctype></ext>
  </bibdata>
  <preface><abstract><title>Abstract</title><p>123</p></abstract></preface>
  <sections/>
  </un-standard>
INPUT
IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).to include '<a name="abstractbox" id="abstractbox">'
  end

   it "does not populate abstract box if there is no abstract" do
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
IsoDoc::UN::WordConvert.new(toc: false).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).not_to include '<a name="abstractbox" id="abstractbox">'
  end


  it "does not used plenary title page in DOC for recommendations" do
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
IsoDoc::UN::WordConvert.new(toc: true).convert("test", input, false)
  html = File.read("test.doc", encoding: "utf-8")
  expect(html).not_to include '<a name="abstractbox" id="abstractbox">'
  expect(html).to include 'preface_container'
  end

  it "processes bibliography" do
        input = <<~"INPUT"
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
  output = xmlpp(<<~"OUTPUT")
<div class="WordSection3"><div><h1/><a href="#ISO712">ISO 712</a></div>  
</div>
  OUTPUT
  expect(xmlpp(IsoDoc::UN::WordConvert.new({}).convert("test", input, true).
         sub(%r{^.*<div class="WordSection3">}m, '<div class="WordSection3">').
         sub(%r{<v:line.*$}m, '</div>'))).to be_equivalent_to output
  end

  it "processes plenary preface" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <un-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="standard">
    <ext><doctype>plenary</doctype></ext>
    </bibdata>
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
        IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          section1 = html.sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">').sub(%r{<div class="WordSection2">.*$}m, "")
          section2 = html.sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">').sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
          expect(section1).to include "This is an abstract"
          expect(xmlpp(section2)).to be_equivalent_to xmlpp(<<~"OUTPUT")
          <div class="WordSection2">

      <div>
        <p class="MsoNormal"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
        <p class="ForewordTitle">Foreword</p>
        <p class="MsoNormal"><a name="A" id="A"></a>This is a preamble</p>
      </div>
      <div class="Section3"><a name="B" id="B"></a>
        <p class="MsoNormal"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
        <p class="IntroTitle">Introduction</p>
        <div><a name="C" id="C"></a><h2>Introduction Subsection</h2>
   </div>
 </div>
 <p class='MsoNormal'>
   <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
 </p>
 <div class='Section3'>
   <a name='H' id='H'/>
   <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
   <div>
     <a name='I' id='I'/>
     <h2>Normal Terms</h2>
     <p class='TermNum'>
       <a name='J' id='J'/>
       .
     </p>
     <p class='Terms' style='text-align:left;'>Term2</p>
   </div>
   <div>
     <a name='K' id='K'/>
     <h2>Symbols and abbreviated terms</h2>
     <table class='dl'>
       <tr>
         <td valign='top' align='left'>
           <p align='left' style='margin-left:0pt;text-align:left;' class='MsoNormal'>Symbol</p>
         </td>
         <td valign='top'>Definition</td>
       </tr>
     </table>

   </div>
      </div>
      <p class="MsoNormal">&#xA0;</p>
    </div>
          OUTPUT

    end

  it "removes WordSection2 if empty" do
        FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <un-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="standard">
    <ext><doctype>plenary</doctype></ext>
    </bibdata>
      <preface>
        </preface><sections>
INPUT
        IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          expect(html).not_to include '<div class="WordSection2"'
  end

  it "does not removes WordSection2 if no preface but ToC" do
        FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <un-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="standard">
    <ext><doctype>plenary</doctype></ext>
    </bibdata>
      <preface>
        </preface><sections>
INPUT
        IsoDoc::UN::WordConvert.new({toc: true}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")    
          expect(html).to include '<div class="WordSection2"'
  end

  it "processes recommendation preface" do
    FileUtils.rm_f("test.doc")
    input = <<~"INPUT"
    <un-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata type="standard">
    <ext><doctype>recommendation</doctype></ext>
    </bibdata>
    #{BOILERPLATE}
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
        </preface><sections/>
        </un-standard>
INPUT
        IsoDoc::UN::WordConvert.new({}).convert("test", input, false)
          html = File.read("test.doc", encoding: "utf-8")
          section1 = html.sub(%r{^.*<div class="WordSection1">}m, '<div class="WordSection1">').sub(%r{<div class="WordSection2">.*$}m, "")
          section2 = html.sub(%r{^.*<div class="WordSection2">}m, '<div class="WordSection2">').sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
          expect(section1).not_to include "This is an abstract"
          expect(xmlpp(section2)).to be_equivalent_to xmlpp(<<~"OUTPUT")
                 <div class="WordSection2">
       <div>
<div class='boilerplate-legal'>
  <div>
    <div>
      <p class='TitlePageSubhead'>Note</p>
      <p class='MsoNormal'>
        <a name='_' id='_'/>
        The designations employed and the presentation of the material in
        this publication do not imply the expression of any opinion
        whatsoever on the part of the Secretariat of the United Nations
        concerning the legal status of any country, territory, city or area,
        or of its authorities, or concerning the delimitation of its
        frontiers or boundaries.
      </p>
    </div>
  </div>
</div>
<div class='boilerplate-copyright'>
  <div>
    <p class='MsoNormal'>
      <a name='boilerplate-ECEhdr' id='boilerplate-ECEhdr'/>
      ECE/TRADE/437
    </p>
    <p class='MsoNormal'>
      <a name='_' id='_'/>
      Copyright &#xA9; United Nations 2020
      <br/>
       All rights reserved worldwide
      <br/>
       United Nations publication issued by the Economic Commission for
      Europe
    </p>
  </div>
</div>

       </div>

       <div><a name="preface_container" id="preface_container"></a><div>

               <p class="AbstractTitle">Summary</p>
               <p class="MsoNormal"><a name="AA" id="AA"></a>This is an abstract</p>
             </div><div>
               <p class="MsoNormal"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="ForewordTitle">Foreword</p>
               <p class="MsoNormal"><a name="A" id="A"></a>This is a preamble</p>
             </div><div class="Section3"><a name="B" id="B"></a>
               <p class="MsoNormal"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
               <p class="IntroTitle">Introduction</p>
               <div><a name="C" id="C"></a><h2>Introduction Subsection</h2>

          </div>
             </div>
 </div>
 <p class='MsoNormal'>
   <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
 </p>
 <div class='Section3'>
   <a name='H' id='H'/>
   <h1 class='IntroTitle'>Terms, Definitions, Symbols and Abbreviated Terms</h1>
   <div>
     <a name='I' id='I'/>
     <h2>Normal Terms</h2>
     <p class='TermNum'>
       <a name='J' id='J'/>
       .
     </p>
     <p class='Terms' style='text-align:left;'>Term2</p>
   </div>
   <div>
     <a name='K' id='K'/>
     <h2>Symbols and abbreviated terms</h2>
     <table class='dl'>
       <tr>
         <td valign='top' align='left'>
           <p align='left' style='margin-left:0pt;text-align:left;' class='MsoNormal'>Symbol</p>
         </td>
         <td valign='top'>Definition</td>
       </tr>
     </table>

             </div></div>







             <p class="MsoNormal">&#xA0;</p>
           </div>
          OUTPUT

    end

end
