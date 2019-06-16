require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Unece do
  #it "generates output for the Rice document" do
  #  FileUtils.rm_rf %w(spec/examples/rfc6350.doc spec/examples/rfc6350.html spec/examples/rfc6350.pdf)
  #  FileUtils.cd "spec/examples"
  #  Asciidoctor.convert_file "rfc6350.adoc", {:attributes=>{"backend"=>"unece"}, :safe=>0, :header_footer=>true, :requires=>["metanorma-unece"], :failure_level=>4, :mkdirs=>true, :to_file=>nil}
  #  FileUtils.cd "../.."
  #  expect(File.exist?("spec/examples/rfc6350.doc")).to be true
  #  expect(File.exist?("spec/examples/rfc6350.html")).to be true
  #  expect(File.exist?("spec/examples/rfc6350.pdf")).to be false
  #end

  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
<sections/>
</unece-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to output
  end

  it "converts a blank document" do
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

    FileUtils.rm_f "test.html"
    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: TC
      :committee-number: 1
      :committee-type: A
      :committee_2: TC1
      :committee-number_2: 1
      :committee-type_2: B
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title: Main Title
      :subtitle: Subtitle
      :session: Session
      :session-date: 2000-01-01
      :item-footnote: A/123
      :item-number: 123, 456
      :item-name: ABC, DEF
      :subitem-name: EGH, IJK
      :collaborator: WHO
      :agenda-id: WHO 1
      :distribution: public
    INPUT
    output = <<~"OUTPUT"
    <?xml version="1.0" encoding="UTF-8"?>
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="standard">
  <title type="main" language="en" format="text/plain">Main Title</title>
  <title type="subtitle" language="en" format="text/plain">Subtitle</title>
  <docidentifier>1000(wd)</docidentifier>
  <docnumber>1000</docnumber>
<edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
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
  <status>
    <stage>working-draft</stage>
    <iteration>3</iteration>
  </status>
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
    <committee type="B">TC1</committee>
  </editorialgroup>
  <distribution>public</distribution>
  <session>
  <number>Session</number>
  <date>2000-01-01</date>
  <item-number>123</item-number>
<item-number>456</item-number>
<item-name>ABC</item-name>
<item-name>DEF</item-name>
<subitem-name>EGH</subitem-name>
<subitem-name>IJK</subitem-name>
  <collaborator>WHO</collaborator>
  <id>WHO 1</id>
  <item-footnote>A/123</item-footnote>
</session>
</ext>
</bibdata>
<sections/>
</unece-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to output
  end

   it "processes committee-draft, languages" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :status: committee-draft
      :language: eo, tlh
      :submissionlanguage: de, jp
    INPUT
    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
           <unece-standard xmlns="https://open.ribose.com/standards/unece">
       <bibdata type="standard">

         <docidentifier>1000(cd)</docidentifier>
         <docnumber>1000</docnumber>
         <contributor>
           <role type="author"/>
           <organization>
             <name>UNECE</name>
           </organization>
         </contributor>
         <contributor>
           <role type="publisher"/>
           <organization>
             <name>UNECE</name>
           </organization>
         </contributor>
         <language>eo</language>
        <language>tlh</language>
         <script>Latn</script>
         <status>
           <stage>committee-draft</stage>
         </status>
         <copyright>
           <from>#{Date.today.year}</from>
           <owner>
             <organization>
               <name>UNECE</name>
             </organization>
           </owner>
         </copyright>
         <ext>
         <doctype>recommendation</doctype>
         <session/>
        <submissionlanguage>de</submissionlanguage>
        <submissionlanguage>jp</submissionlanguage>
         </ext>
       </bibdata>
       <sections/>
       </unece-standard>
    OUTPUT
   end

   it "processes draft-standard" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :status: draft-standard
    INPUT
    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
    <unece-standard xmlns="https://open.ribose.com/standards/unece">
<bibdata type="standard">

  <docidentifier>1000(d)</docidentifier>
  <docnumber>1000</docnumber>
  <contributor>
    <role type="author"/>
    <organization>
      <name>UNECE</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>UNECE</name>
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
    <stage>draft-standard</stage>
  </status>
  <copyright>
    <from>#{Date.today.year}</from>
    <owner>
      <organization>
        <name>UNECE</name>
      </organization>
    </owner>
  </copyright>
         <ext>
         <doctype>recommendation</doctype>
         <session/>
         </ext>
</bibdata>
<sections/>
</unece-standard>
    OUTPUT
   end

   it "warns when type used other than recommendation or plenary" do
     expect { Asciidoctor.convert(<<~"INPUT", backend: :unece, header_footer: true) }.to output(/is not a legal document type/).to_stderr
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: cheese
     INPUT
   end

  it "processes abstracts" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      Preamble

      [abstract]
      == Section
      Abstract
    INPUT

    output = <<~"OUTPUT"
    <preface><abstract id="_">
  <p id="_">Abstract</p>
</abstract><foreword obligation="informative">
  <title>Foreword</title>
  <p id="_">Preamble</p>
</foreword></preface><sections>
</sections>
</unece-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true)).sub(/^.*<preface/m, "<preface")).to be_equivalent_to output
  end

  it "processes notes" do
      expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :unece, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}
      
      [NOTE]
      .The United Nations Centre for Trade Facilitation and e-Business
      ====
      Only use paddy or parboiled rice for the determination of husked rice yield.
      ====
      INPUT
      #{BLANK_HDR}
       <sections>
         <note id="_">
         <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </note>
       </sections>
       </unece-standard>
      OUTPUT
    end


  it "processes simple admonitions with Asciidoc names" do
      expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :unece, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}
      
      [IMPORTANT%unnumbered]
      .The United Nations Centre for Trade Facilitation and e-Business
      ====
      Only use paddy or parboiled rice for the determination of husked rice yield.
      ====
      INPUT
      #{BLANK_HDR}
       <sections>
         <admonition id="_" type="important" unnumbered="true">
         <name>The United Nations Centre for Trade Facilitation and e-Business</name>
         <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </admonition>
       </sections>
       </unece-standard>

      OUTPUT
    end


  it "adds paragraph numbering" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      == Section 1
      Para 1

      * A
      * B
      * C

      Para 2

      [appendix]
      == Annex
      Para 3

      Para 4
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
    <sections><clause id="_" inline-header="false" obligation="normative"><title>Section 1</title><clause id="_" inline-header="true" obligation="normative"><p id="_">Para 1</p><ul id="_">
         <li>
           <p id="_">A</p>
         </li>
         <li>
           <p id="_">B</p>
         </li>
         <li>
           <p id="_">C</p>
         </li>
       </ul></clause>

       <clause id="_" inline-header="true" obligation="normative"><p id="_">Para 2</p></clause></clause>
       </sections><annex id="_" inline-header="false" obligation="normative"><title>Annex</title><clause id="_" inline-header="true" obligation="normative"><p id="_">Para 3</p></clause>
       <clause id="_" inline-header="true" obligation="normative"><p id="_">Para 4</p></clause></annex>
       </unece-standard>

    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :unece, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Roboto]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6, \.h2Annex \{[^}]+font-family: "Roboto]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :unece, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6, \.h2Annex \{[^}]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :unece, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6, \.h2Annex \{[^}]+font-family: Comic Sans;]m)
  end

  it "processes inline_quoted formatting" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [keyword]#keyword#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT

    output = <<~"OUTPUT"
            #{BLANK_HDR}
       <sections>
        <p id="_"><em>emphasis</em>
       <strong>strong</strong>
       <tt>monospace</tt>
       “double quote”
       ‘single quote’
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>a</mi><mn>90</mn></msub></math></stem> 
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <keyword>keyword</keyword>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap></p>
       </sections>
       </unece-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true))).to be_equivalent_to output
  end
end
