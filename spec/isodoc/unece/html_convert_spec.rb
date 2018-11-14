require "spec_helper"

RSpec.describe IsoDoc::Unece do

  it "processes default metadata, recommendation" do
    csdc = IsoDoc::Unece::HtmlConvert.new({})
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
        {:accesseddate=>"XXX", :confirmeddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000(wd)", :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Recommendation", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :editorialgroup=>[], :formatted_docnumber=>"Recommendation No. 1000(wd)", :ics=>"XXX", :implementeddate=>"XXX", :issueddate=>"XXX", :language=>"en", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :sc=>"XXXX", :secretariat=>"XXXX", :session_agendaitem=>nil, :session_collaborator=>nil, :session_date=>nil, :session_distribution=>nil, :session_id=>nil, :session_number=>nil, :status=>"Working Draft", :tc=>"TC", :toc=>nil, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

    it "processes default metadata, plenary" do
    csdc = IsoDoc::Unece::HtmlConvert.new({})
    input = <<~"INPUT"
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="plenary">
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
        {:accesseddate=>"XXX", :confirmeddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000(wd)", :docsubtitle=>"Subtitle", :doctitle=>"Main Title", :doctype=>"Plenary", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :editorialgroup=>[], :formatted_docnumber=>"1000(wd)", :ics=>"XXX", :implementeddate=>"XXX", :issueddate=>"XXX", :language=>"en", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :sc=>"XXXX", :secretariat=>"XXXX", :session_agendaitem=>"5", :session_collaborator=>"WHO", :session_date=>"2001-01-01", :session_distribution=>"public", :session_id=>"WHO-UNECE-01", :session_number=>"Third", :status=>"Working Draft", :tc=>"TC", :toc=>nil, :updateddate=>"XXX", :wg=>"XXXX"}
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
        #{HTML_HDR}
        <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <p id="A">This is a preamble</p>
             </div>
             <br/>
             <div class="Section3" id="B">
               <h1 class="IntroTitle">Introduction</h1>
               <div id="C"><h2>&#160; Introduction Subsection</h2>

          </div>
             </div>
             <div id="D">
               <h1>1.&#160; Scope</h1>
               <p id="E">Text</p>
             </div>
             <div id="M">
               <h1>II.&#160; Clause 4</h1>
               <div id="N"><h2>2. &#160; Introduction</h2>

          </div>
               <div id="O"><h2>3. &#160; Clause 4.2</h2>

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

            <div id="Q1"><h3>1. &#160; Annex A.1a</h3>

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
    OUTPUT

    expect(
      IsoDoc::Unece::HtmlConvert.new({}).convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    ).to be_equivalent_to output
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
<sections/>
</unece-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Roboto})
  end

end
