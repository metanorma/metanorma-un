require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Unece do
  it "generates output for the Rice document" do
    FileUtils.rm_rf %w(spec/examples/rfc6350.doc spec/examples/rfc6350.html spec/examples/rfc6350.pdf)
    FileUtils.cd "spec/examples"
    Asciidoctor.convert_file "rfc6350.adoc", {:attributes=>{"backend"=>"unece"}, :safe=>0, :header_footer=>true, :requires=>["metanorma-unece"], :failure_level=>4, :mkdirs=>true, :to_file=>nil}
    FileUtils.cd "../.."
    expect(File.exist?("spec/examples/rfc6350.doc")).to be true
    expect(File.exist?("spec/examples/rfc6350.html")).to be true
    expect(File.exist?("spec/examples/rfc6350.pdf")).to be false
  end

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
      :agenda-item: 123
      :collaborator: WHO
      :agenda-id: WHO 1
      :distribution: publid
    INPUT
    output = <<~"OUTPUT"
    <?xml version="1.0" encoding="UTF-8"?>
<unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
<bibdata type="recommendation">
  <title language="en" format="text/plain">Main Title</title>
  <subtitle language="en" format="text/plain">Subtitle</title>
  <docidentifier>1000(wd)</docidentifier>
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
    <committee type="B">TC1</committee>
  </editorialgroup>
  <session>
  <number>Session</number>
  <date>2000-01-01</date>
  <agenda-item>123</agenda-item>
  <collaborator>WHO</collaborator>
  <id>WHO 1</id>
  <distribution>publid</distribution>
</session>
</bibdata><version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
<sections/>
</unece-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :unece, header_footer: true)).to be_equivalent_to output
  end

  it "processes figures" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[id]]
      .Figure 1
      ....
      This is a literal

      Amen
      ....
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
       <sections>
                <figure id="id">
         <name>Figure 1</name>
         <pre>This is a literal

       Amen</pre>
       </figure>
       </sections>
       </unece-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true))).to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
             <preface><foreword obligation="informative">
         <title>Foreword</title>
         <p id="_">This is a preamble</p>
       </foreword></preface><sections>
       <clause id="_"  inline-header="false" obligation="normative">
         <title>Section 1</title>
       </clause></sections>
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
       "double quote"
       'single quote'
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="AsciiMath">a_90</stem>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <keyword>keyword</keyword>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap></p>
       </sections>
       </unece-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :unece, header_footer: true))).to be_equivalent_to output
  end

  it "uses user-specified HTML stylesheets" do
    FileUtils.rm_f "spec/assets/test.html"
    system "metanorma -t unece spec/assets/test.adoc"

    html = File.read("spec/assets/test.html", encoding: "utf-8")
    expect(html).to match(%r[I am an HTML stylesheet])
    expect(html).to match(%r[I am an HTML cover page])
    expect(html).to match(%r[I am an HTML intro page])
    expect(html).to match(%r[I am an HTML scripts page])
  end

  it "uses user-specified Word stylesheets" do
    FileUtils.rm_f "spec/assets/test.doc"
    system "metanorma -t unece spec/assets/test.adoc"

    html = File.read("spec/assets/test.doc", encoding: "utf-8")
    expect(html).to match(%r[I am a Word stylesheet])
    expect(html).to match(%r[I am a Standard stylesheet])
    expect(html).to match(%r[I am a Word cover page])
    expect(html).to match(%r[I am a Word intro page])
    # expect(html).to match(%r[I am a Word header file]) -- binhexed:
    expect(html).to match(%r[\nPCEtLSBJIGFtIGEgV29yZCBIZWFkZXIgZmlsZSAtLT4K\n])
  end
end
