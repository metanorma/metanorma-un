require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "isodoc", "unece", "html"))

RSpec.describe IsoDoc::Unece do

  it "processes default metadata, recommendation" do
    csdc = IsoDoc::Unece::HtmlConvert.new({toc: true})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="standard">
  <title type="main" language="en" format="plain">Main Title</title>
  <title type="subtitle" language="en" format="plain">Subtitle</title>
  <docidentifier>1000A</docidentifier>
  <docnumber>1000</docnumber>
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
        <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
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
</unece-standard>
    INPUT

    output = <<~"OUTPUT"
  {:accesseddate=>"XXX", :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :distribution=>nil, :docnumber=>"1000A", :docnumeric=>"1000", :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Recommendation", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :edition=>"2", :formatted_docnumber=>"UN/CEFACT Recommendation 1000A", :implementeddate=>"XXX", :issueddate=>"XXX", :item_footnote=>nil, :logo=>"#{File.join(logoloc, "logo.jpg")}", :obsoleteddate=>"XXX", :publisheddate=>"XXX", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :session_collaborator=>nil, :session_date=>nil, :session_id=>nil, :session_itemname=>[], :session_itemnumber=>[], :session_number=>nil, :session_subitemname=>[], :stage=>"Working Draft", :stageabbr=>"wd", :submissionlanguage=>["German"], :tc=>"TC", :toc=>nil, :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

    it "processes default metadata, plenary; six official UN languages" do
    csdc = IsoDoc::Unece::HtmlConvert.new({toc: true})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="standard">
  <title type="main" language="en" format="plain">Main Title</title>
  <title type="subtitle" language="en" format="plain">Subtitle</title>
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
        <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
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
  <id>WHO-UNECE-01</id>
  <distribution>public</distribution>
  </session>
  </ext>
</bibdata>
<sections/>
</unece-standard>
    INPUT

    output = <<~"OUTPUT"
    {:accesseddate=>"XXX", :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :distribution=>nil, :docnumber=>"1000(wd)", :docnumeric=>nil, :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Plenary", :docyear=>"2001", :draft=>nil, :draftinfo=>"", :edition=>nil, :formatted_docnumber=>"1000(wd)", :implementeddate=>"XXX", :issueddate=>"XXX", :item_footnote=>nil, :logo=>"#{File.join(logoloc, "logo.jpg")}", :obsoleteddate=>"XXX", :publisheddate=>"XXX", :receiveddate=>"XXX", :revdate=>nil, :revdate_monthyear=>nil, :session_collaborator=>"WHO", :session_date=>"2001-01-01", :session_id=>"WHO-UNECE-01", :session_itemname=>["ABC", "DEF"], :session_itemnumber=>["5", "6"], :session_number=>"Third", :session_subitemname=>["GHI", "JKL"], :stage=>"Working Draft", :stageabbr=>"wd", :tc=>"TC", :toc=>nil, :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

  it "processes section names without paragraph content" do
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
      <preface>
      <foreword obligation="informative">
         <title>Foreword</title>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction>
       <abstract obligation="informative">
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

    output = xmlpp(<<~"OUTPUT")
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
             <div id="H">
               <h1>I.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
               <div id="I"><h2>A. &#160; Normal Terms</h2>

            <p class="TermNum" id="J">1.</p>
            <p class="Terms" style="text-align:left;">Term2</p>

          </div>
               <div id="K"><h2>B. &#160; Symbols and abbreviated terms</h2>
            <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
          </div>
             </div>
             <div id="D">
               <h1>II.&#160; Scope</h1>
             </div>
             <div id="M">
               <h1>III.&#160; Clause 4</h1>
               <div id="N"><h2>A. &#160; Introduction</h2>

          </div>
               <div id="O"><h2>B. &#160; Clause 4.2</h2>

            <div id="O1"><h3>1. &#160; Clause 4.2.1</h3>

            <div id="O11"><h4>I. &#160; Clause 4 Leaf</h4>

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
               <div id="Q"><h2>1. &#160; Annex A.1</h2>

            <div id="Q1"><h3>I. &#160; Annex A.1a</h3>

            <div id="Q11"><h4>A. &#160; Annex A Leaf</h4>

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

    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).convert("test", input, true))).to be_equivalent_to output
end


  it "processes section names with paragraph content" do
    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).convert("test", <<~INPUT, true))).to be_equivalent_to <<~OUTPUT
    <unece-standard xmlns="http://riboseinc.com/isoxml">
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
       <clause id="D" obligation="normative">
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
          <h2>A. &#160; Normal Terms</h2>
          <p class='TermNum' id='J'>1.</p>
          <p class='Terms' style='text-align:left;'>Term2</p>
        </div>
        <div id='K'>
          <h2>B. &#160; Symbols and abbreviated terms</h2>
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
          <h2>2. &#160; Introduction</h2>
          <p id='A5'>Text</p>
        </div>
        <div id='O'>
          <h2>A. &#160; Clause 4.2</h2>
          <div id='O1'>
            <h3>1. &#160; Clause 4.2.1</h3>
            <div id='O11'>
              <h4>3. &#160; Clause 4 Leaf</h4>
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
          <h2>1. &#160; Annex A.1</h2>
          <div id='Q1'>
            <h3>I. &#160; Annex A.1a</h3>
            <div id='Q11'>
              <h4>1. &#160; Annex A Leaf</h4>
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

    output = xmlpp(<<~"OUTPUT")
    <div>
    <h1 class="ForewordTitle">Foreword</h1>
        <p>
                   <a href='#A'>Foreword</a>
           <a href='#B'>Introduction</a>
           <a href='#C'>Introduction Subsection</a>
           <a href='#AA'>Abstract</a>
           <a href='#H'>Clause I</a>
           <a href='#I'>Clause I.A</a>
           <a href='#J'>Clause I.A.1</a>
           <a href='#K'>Clause I.B</a>
           <a href='#D'>paragraph 1</a>
           <a href='#M'>Clause III</a>
           <a href='#N'>paragraph 2</a>
           <a href='#O'>Clause III.A</a>
           <a href='#O1'>Clause III.A.1</a>
           <a href='#O11'>paragraph 3</a>
           <a href='#P'>Annex I</a>
           <a href='#Q'>Annex I.1</a>
           <a href='#Q1'>Annex I.1.I</a>
           <a href='#Q11'>paragraph I.1.I.A.1</a>
           <a href='#U'>Annex II</a>
           <a href='#R'>Normative References</a>
           <a href='#S'>Bibliography</a>
           <a href='#T'>Bibliography Subsection</a>
         </p>
    </div>
    OUTPUT

    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).
           convert("test", input, true).
           sub(%r{^.*<h1 class="ForewordTitle">}m, '<div><h1 class="ForewordTitle">').
           sub(%r{</div>.*$}m, '</div>')
          )).to be_equivalent_to output
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

    output = xmlpp(<<~"OUTPUT")
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
               <h1 class="Annex">
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
    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({suppressheadingnumbers: true}).convert("test", input, true))).to be_equivalent_to output
    end

it "injects JS into blank html" do
  system "rm -f test.html"
  input = <<~"INPUT"
    = Document title
    Author
    :docfile: test.adoc
    :novalid:
  INPUT

  output = xmlpp(<<~"OUTPUT")
  #{BLANK_HDR}
<sections/>
</unece-standard>
  OUTPUT

  expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true)))).to be_equivalent_to output
  html = File.read("test.html", encoding: "utf-8")
  expect(html).to match(%r{jquery\.min\.js})
  expect(html).to match(%r{Roboto})
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
  </unece-standard>
  INPUT

  output = xmlpp(<<~"OUTPUT")
  #{HTML_HDR}
               <div id="A">
               <h1>I.&#160; </h1>
               <div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">First Box</p>

             <p id="C">paragraph</p>
           </div>
             </div>
             <div id="A1">
               <h1>II.&#160; </h1>
               <div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box 1&#160;&#8212; Second Box</p>

             <p id="C1">paragraph</p>
           </div>
             </div>
             <br/>
             <div id="D" class="Section3">
               <h1 class="Annex"><b>Annex I</b><br/><b>First Annex</b></h1>
               <div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box I.1&#160;&#8212; Third Box</p>

             <p id="F">paragraph</p>
           </div>
             </div>
             <br/>
             <div id="D1" class="Section3">
               <h1 class="Annex"><b>Annex II</b><br/><b>Second Annex</b></h1>
               <div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">Box II.1&#160;&#8212; Fourth Box</p>

             <p id="F1">paragraph</p>
           </div>
             </div>
           </div>
         </body>
       </html>
  OUTPUT
    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).convert("test", input, true))).to be_equivalent_to output
end

    it "processes inline section headers" do
    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
  #{HTML_HDR}
             <div id="M">
               <h1>I.&#160; Clause 4</h1>
               <div id="N"><h2>A. &#160; Introduction</h2>

        </div>
               <div id="O"><span class="zzMoveToFollowing">B. &#160; Clause 4.2 </span>

        </div>
             </div>
           </div>
         </body>
       </html>
OUTPUT
    end


  it "does not switch plenary title page in HTML" do
    FileUtils.rm_f("test.html")
        csdc = IsoDoc::Unece::HtmlConvert.new({toc: true})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="standard">
  <title language="en" format="plain">Main Title</title>
  <ext><doctype>plenary</doctype></ext>
  </bibdata>
  <sections/>
  </unece-standard>
INPUT
  IsoDoc::Unece::HtmlConvert.new({}).convert("test", input, false)
  html = File.read("test.html", encoding: "utf-8")
  expect(html).not_to include "<div class=MsoNormal id='abstractbox'"
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
  output = xmlpp(<<~"OUTPUT")
  #{HTML_HDR}
        <div>
        <h1/>
        <a href="#ISO712">ISO 712</a>
      </div>
    </div>
  </body>
</html>
  OUTPUT
    expect(xmlpp(IsoDoc::Unece::HtmlConvert.new({}).convert("test", input, true))).to be_equivalent_to output
  end

end
