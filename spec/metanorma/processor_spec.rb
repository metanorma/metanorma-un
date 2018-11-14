require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Unece::Processor do

  registry = Metanorma::Registry.instance
  registry.register(Metanorma::Unece::Processor)

  let(:processor) {
    registry.find_processor(:unece)
  }

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    output = <<~"OUTPUT"
    [[:doc, "doc"], [:html, "html"], [:xml, "xml"]]
    OUTPUT

    expect(processor.output_formats.sort.to_s).to be_equivalent_to output
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::Unece })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
<sections/>
</unece-standard>
    OUTPUT

    expect(processor.input_to_isodoc(input, nil)).to be_equivalent_to output
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    input = <<~"INPUT"
    <unece-standard xmlns="http://riboseinc.com/isoxml">
    <sections>
    <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>
        </sections>
    </unece-standard>
    INPUT

    output = <<~"OUTPUT"
   <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
     <div id="D">
       <h1>1.&#xA0; Scope</h1>
       <p id="E">Text</p>
     </div>
   </main>
    OUTPUT

    processor.output(input, "test.html", :html)

    expect(
      File.read("test.html", encoding: "utf-8").
      gsub(%r{^.*<main}m, "<main").
      gsub(%r{</main>.*}m, "</main>")
    ).to be_equivalent_to output

  end

end
