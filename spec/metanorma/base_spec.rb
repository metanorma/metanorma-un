require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::UN do
  it "processes a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </un-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:

      = Clause
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
          <sections>
        <clause id='_' inline-header='false' obligation='normative'>
          <title>Clause</title>
        </clause>
      </sections>
      </un-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.doc")).to be true
    expect(File.exist?("test.pdf")).to be true
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
    output = xmlpp(<<~"OUTPUT")
          <?xml version="1.0" encoding="UTF-8"?>
      <un-standard xmlns="https://www.metanorma.org/ns/un" type="semantic" version="#{Metanorma::UN::VERSION}">
      <bibdata type="standard">
        <title type="main" language="en" format="text/plain">Main Title</title>
        <title type="subtitle" language="en" format="text/plain">Subtitle</title>
        <docidentifier>1000(wd)</docidentifier>
        <docnumber>1000</docnumber>
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
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
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
            <name>United Nations</name>
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
          #{BOILERPLATE.sub(/United Nations #{Date.today.year}/, 'United Nations 2001')}
      <sections/>
      </un-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
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
    output = <<~OUTPUT
                 <un-standard xmlns="https://www.metanorma.org/ns/un" type="semantic" version="#{Metanorma::UN::VERSION}">
             <bibdata type="standard">
      <title type='main' language='en' format='text/plain'>Document title</title>
               <docidentifier>1000(cd)</docidentifier>
               <docnumber>1000</docnumber>
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
                   <name>United Nations</name>
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
      #{BOILERPLATE}
             <sections/>
             </un-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
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
    output = <<~OUTPUT
          <un-standard xmlns="https://www.metanorma.org/ns/un" type="semantic" version="#{Metanorma::UN::VERSION}">
      <bibdata type="standard">
      <title type='main' language='en' format='text/plain'>Document title</title>
        <docidentifier>1000(d)</docidentifier>
        <docnumber>1000</docnumber>
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
          <stage>draft-standard</stage>
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
               <doctype>recommendation</doctype>
               <session/>
               </ext>
      </bibdata>
      #{BOILERPLATE}
      <sections/>
      </un-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "warns when type used other than recommendation or plenary" do
    input = <<~INPUT
       = Document title
       Author
       :docfile: test.adoc
       :nodoc:
       :novalid:
       :docnumber: 1000
       :doctype: cheese
 INPUT
    expect { Asciidoctor.convert(input, *OPTIONS) }
      .to output(/is not a legal document type/).to_stderr
  end

  it "processes abstracts" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      Preamble

      [abstract]
      == Section
      Abstract
    INPUT

    output = xmlpp(<<~"OUTPUT")
          <preface><abstract id="_">
          <title>Summary</title>
        <p id="_">Abstract</p>
      </abstract><foreword id="_" obligation="informative">
        <title>Foreword</title>
        <p id="_">Preamble</p>
      </foreword></preface>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))
      .sub(/^.*<preface/m, "<preface")
      .sub(%r{</preface>.*$}m, "</preface>")))
      .to be_equivalent_to output
  end

  it "processes notes" do
    input = <<~INPUT
        #{ASCIIDOC_BLANK_HDR}

        [NOTE]
        .The United Nations Centre for Trade Facilitation and e-Business
        ====
        Only use paddy or parboiled rice for the determination of husked rice yield.
        ====
      INPUT
      output = <<~OUTPUT
        #{BLANK_HDR}
         <sections>
           <note id="_">
           <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
         </note>
         </sections>
         </un-standard>
      OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes simple admonitions with Asciidoc names" do
    input = <<~INPUT
        #{ASCIIDOC_BLANK_HDR}

        [IMPORTANT%unnumbered,subsequence=A]
        .The United Nations Centre for Trade Facilitation and e-Business
        ====
        Only use paddy or parboiled rice for the determination of husked rice yield.
        ====
      INPUT
      output = <<~OUTPUT
        #{BLANK_HDR}
         <sections>
           <admonition id="_" type="important" unnumbered="true" subsequence="A">
           <name>The United Nations Centre for Trade Facilitation and e-Business</name>
           <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
         </admonition>
         </sections>
         </un-standard>

      OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
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

    output = xmlpp(<<~"OUTPUT")
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
         </un-standard>

    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "does not add paragraph numbering to an agenda" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :doctype: agenda

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

  output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR.sub(%r{<doctype>recommendation</doctype>}, '<doctype>agenda</doctype>')}
      <sections><clause id="_" inline-header="false" obligation="normative"><title>Section 1</title><p id="_">Para 1</p><ul id="_">
           <li>
             <p id="_">A</p>
           </li>
           <li>
             <p id="_">B</p>
           </li>
           <li>
             <p id="_">C</p>
           </li>
         </ul>

         <p id="_">Para 2</p></clause>
         </sections><annex id="_" inline-header="false" obligation="normative"><title>Annex</title><p id="_">Para 3</p>
         <p id="_">Para 4</p></annex>
         </un-standard>

  OUTPUT

  expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
    .to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Times New Roman", serif]m)
    expect(html).to match(%r[h1,\sh2,\sh3,\sh4,\sh5,\sh6,\s\.h2Annex[^}]+font-family: "Times New Roman", serif]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Source Han Sans", serif;]m)
    expect(html).to match(%r[h1,\sh2,\sh3,\sh4,\sh5,\sh6,\s\.h2Annex[^}]+font-family: "Source Han Sans", sans-serif;]m)
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
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1,\sh2,\sh3,\sh4,\sh5,\sh6,\s\.h2Annex[^}]+font-family: Comic Sans;]m)
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

    output = xmlpp(<<~"OUTPUT")
                  #{BLANK_HDR}
             <sections>
              <p id="_"><em>emphasis</em>
             <strong>strong</strong>
             <tt>monospace</tt>
             “double quote”
             ‘single quote’
             super<sup>script</sup>
             sub<sub>script</sub>
             <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mrow>
        <mi>a</mi>
      </mrow>
      <mrow>
        <mn>90</mn>
      </mrow>
      </msub></math></stem>
             <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
             <keyword>keyword</keyword>
             <strike>strike</strike>
             <smallcap>smallcap</smallcap></p>
             </sections>
             </un-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes sections" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      .Foreword1

      Text

      == Foreword

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Scope

      Text

      == Normative References

      == Terms and Definitions

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Symbols and Abbreviated Terms

      [.nonterm]
      ==== General

      ==== Symbols 1

      == Abbreviated Terms

      == Clause 4
      === Introduction

      === Clause 4.2

      == Terms and Definitions

      [appendix]
      == Annex

      === Annex A.1

      == Bibliography

      === Bibliography Subsection
    INPUT
    output = <<~OUTPUT
          #{BLANK_HDR.sub(/<status>/, '<abstract> <p>Text</p> </abstract> <status>')}
              <preface>
          <abstract id='_'>
          <title>Summary</title>
            <p id='_'>Text</p>
          </abstract>
          <foreword id='_' obligation='informative'>
            <title>Foreword</title>
            <p id='_'>Text</p>
          </foreword>
          <clause id='_' inline-header='false' obligation='informative'>
            <title>Dedication</title>
          </clause>
          <acknowledgements id='_' obligation='informative'>
            <title>Acknowledgements</title>
          </acknowledgements>
        </preface>
        <sections>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Foreword</title>
          </clause>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Introduction</title>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Introduction Subsection</title>
            </clause>
          </clause>
          <clause id='_' inline-header='false' obligation='normative' type="scope">
            <title>Scope</title>
            <clause id='_' inline-header='true' obligation='normative'>
              <p id='_'>Text</p>
            </clause>
          </clause>
          <terms id='_' obligation='normative'>
            <title>Terms and definitions</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <term id='term-term1'>
              <preferred><expression><name>Term1</name></expression></preferred>
            </term>
          </terms>
          <clause id='_' obligation='normative'>
            <title>Terms, definitions, symbols and abbreviated terms</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Introduction</title>
              <clause id='_' inline-header='false' obligation='normative'>
                <title>Intro 1</title>
              </clause>
            </clause>
            <terms id='_' obligation='normative'>
              <title>Intro 2</title>
              <clause id='_' inline-header='false' obligation='normative'>
                <title>Intro 3</title>
              </clause>
            </terms>
            <clause id='_' obligation='normative'>
              <title>Intro 4</title>
              <terms id='_' obligation='normative'>
                <title>Intro 5</title>
                <term id='term-term1-1'>
                  <preferred><expression><name>Term1</name></expression></preferred>
                </term>
              </terms>
            </clause>
            <terms id='_' obligation='normative'>
              <title>Normal Terms</title>
              <term id='term-term2'>
                <preferred><expression><name>Term2</name></expression></preferred>
              </term>
            </terms>
            <definitions id='_' obligation='normative'>
              <title>Symbols and abbreviated terms</title>
              <clause id='_' inline-header='false' obligation='normative'>
                <title>General</title>
              </clause>
              <definitions id='_' obligation='normative'>
                <title>Symbols and abbreviated terms</title>
              </definitions>
            </definitions>
          </clause>
          <definitions id='_' obligation='normative' type="abbreviated_terms">
            <title>Abbreviated terms</title>
          </definitions>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Clause 4</title>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Introduction</title>
            </clause>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Clause 4.2</title>
            </clause>
          </clause>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Terms and Definitions</title>
          </clause>
        </sections>
        <annex id='_' inline-header='false' obligation='normative'>
          <title>Annex</title>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Annex A.1</title>
          </clause>
        </annex>
        <bibliography>
          <references id='_' obligation='informative' normative="true">
            <title>Normative references</title>
            <p id='_'>There are no normative references in this document.</p>
          </references>
          <clause id='_' obligation='informative'>
            <title>Bibliography</title>
            <references id='_' obligation='informative' normative="false">
              <title>Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </un-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes sections with do-not-number-subheadings" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :do-not-number-subheadings:

      .Foreword1

      Text

      == Foreword

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Scope

      Text

      == Normative References

      == Terms and Definitions

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Symbols and Abbreviated Terms

      [.nonterm]
      ==== General

      ==== Symbols 1

      == Abbreviated Terms

      == Clause 4
      === Introduction

      === Clause 4.2

      == Terms and Definitions

      [appendix]
      == Annex

      === Annex A.1

      == Bibliography

      === Bibliography Subsection
    INPUT
    output = <<~OUTPUT
         #{BLANK_HDR.sub(/<status>/, '<abstract> <p>Text</p> </abstract> <status>')}
         <preface>
        <abstract id='_'>
        <title>Summary</title>
          <p id='_'>Text</p>
        </abstract>
        <foreword id='_' obligation='informative'>
          <title>Foreword</title>
          <p id='_'>Text</p>
        </foreword>
        <clause id='_' inline-header='false' obligation='informative'>
          <title>Dedication</title>
        </clause>
        <acknowledgements id='_' obligation='informative'>
          <title>Acknowledgements</title>
        </acknowledgements>
      </preface>
      <sections>
        <clause id='_' inline-header='false' obligation='normative'>
          <title>Foreword</title>
        </clause>
        <clause id='_' inline-header='false' obligation='normative'>
          <title>Introduction</title>
          <clause id='_' inline-header='false' obligation='normative' unnumbered='true'>
            <title>Introduction Subsection</title>
          </clause>
        </clause>
        <clause id='_' inline-header='false' obligation='normative' type="scope">
          <title>Scope</title>
          <clause id='_' inline-header='true' obligation='normative'>
            <p id='_'>Text</p>
          </clause>
        </clause>
        <terms id='_' obligation='normative'>
          <title>Terms and definitions</title>
          <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
          <term id='term-term1'>
            <preferred><expression><name>Term1</name></expression></preferred>
          </term>
        </terms>
         <clause id='_' obligation='normative'>
                  <title>Terms, definitions, symbols and abbreviated terms</title>
                  <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
                  <clause id='_' inline-header='false' obligation='normative'>
                    <title>Introduction</title>
                    <clause id='_' inline-header='false' obligation='normative'>
                      <title>Intro 1</title>
                    </clause>
                  </clause>
                  <terms id='_' obligation='normative'>
                    <title>Intro 2</title>
                    <clause id='_' inline-header='false' obligation='normative'>
                      <title>Intro 3</title>
                    </clause>
                  </terms>
                  <clause id='_' obligation='normative'>
                    <title>Intro 4</title>
                    <terms id='_' obligation='normative'>
                      <title>Intro 5</title>
                      <term id='term-term1-1'>
                        <preferred><expression><name>Term1</name></expression></preferred>
                      </term>
                    </terms>
                  </clause>
                  <terms id='_' obligation='normative'>
                    <title>Normal Terms</title>
                    <term id='term-term2'>
                      <preferred><expression><name>Term2</name></expression></preferred>
                    </term>
                  </terms>
                  <definitions id='_' obligation='normative'>
                    <title>Symbols and abbreviated terms</title>
                    <clause id='_' inline-header='false' obligation='normative'>
                      <title>General</title>
                    </clause>
                    <definitions id='_' obligation='normative'>
                      <title>Symbols and abbreviated terms</title>
                    </definitions>
                  </definitions>
                </clause>
                <definitions id='_' obligation='normative' type="abbreviated_terms">
                  <title>Abbreviated terms</title>
                </definitions>
        <clause id='_' inline-header='false' obligation='normative'>
          <title>Clause 4</title>
          <clause id='_' inline-header='false' obligation='normative' unnumbered='true'>
            <title>Introduction</title>
          </clause>
          <clause id='_' inline-header='false' obligation='normative' unnumbered='true'>
            <title>Clause 4.2</title>
          </clause>
        </clause>
        <clause id='_' inline-header='false' obligation='normative'>
          <title>Terms and Definitions</title>
        </clause>
      </sections>
      <annex id='_' inline-header='false' obligation='normative'>
        <title>Annex</title>
        <clause id='_' inline-header='false' obligation='normative' unnumbered='true'>
          <title>Annex A.1</title>
        </clause>
      </annex>
      <bibliography>
        <references id='_' normative='true' obligation='informative'>
          <title>Normative references</title>
          <p id='_'>There are no normative references in this document.</p>
        </references>
        <clause id='_' obligation='informative'>
          <title>Bibliography</title>
          <references id='_' normative='false' obligation='informative'>
            <title>Bibliography Subsection</title>
          </references>
        </clause>
      </bibliography>
         </un-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end
end
