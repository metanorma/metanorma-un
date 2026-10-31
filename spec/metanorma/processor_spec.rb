require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::UN::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::UN::Processor)

  let(:processor) do
    registry.find_processor(:un)
  end

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    output = <<~OUTPUT
[[:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT

    expect(processor.output_formats.sort).to eq [[:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::UN })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = Xml::C14n.format(strip_guid(<<~"OUTPUT"))
<?xml version="1.0" encoding="UTF-8"?>


<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::UN::VERSION}" flavor="un">
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

    expect(Xml::C14n.format(strip_guid(processor
      .input_to_isodoc(input, nil)))).to be_xml_equivalent_to output
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    FileUtils.rm_f "test.html"
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <clause id="D" obligation="normative" displayorder="1">
           <title>1.<tab/>Scope</title>
           <p id="E">Text</p>
         </clause>
          </sections>
      </un-standard>
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
<?xml version="1.0" encoding="UTF-8"?>


<main class="main-section">
   <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
   <div id="D">
      <h1>
         <a class="anchor" href="#D"/>
         <a class="header" href="#D"/>
      </h1>
      <p id="E">Text</p>
   </div>
</main>
    OUTPUT

    processor.output(input, "test.xml", "test.html", :html)

    expect(
      Xml::C14n.format(strip_guid(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))),
    ).to be_xml_equivalent_to Xml::C14n.format(strip_guid(output))
  end

  it "generates DOC from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <clause id="D" obligation="normative" displayorder="1">
           <title>1.<tab/>Scope</title>
           <fmt-title depth="1">1.<tab/>Scope</fmt-title>
           <p id="E">Text</p>
         </clause>
          </sections>
      </un-standard>
    INPUT

    processor.output(input, "test.xml", "test.doc", :doc)
    expect(File.read("test.doc", encoding: "utf-8"))
      .to include('<div class="WordSection3"><div><a name="D" id="D"></a><h1>1.<span style="mso-tab-count:1">&#xA0; </span>Scope</h1><p class="MsoNormal"><a name="E" id="E"></a>Text</p></div>')
  end
end
