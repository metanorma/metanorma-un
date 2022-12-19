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
    output = <<~"OUTPUT"
      [[:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT

    expect(processor.output_formats.sort.to_s).to be_equivalent_to output
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::UN })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(strip_guid(<<~"OUTPUT"))
          #{BLANK_HDR}
      <sections/>
      </un-standard>
    OUTPUT

    expect(xmlpp(strip_guid(processor
      .input_to_isodoc(input, nil)))).to be_equivalent_to output
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    FileUtils.rm_f "test.html"
    input = <<~"INPUT"
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <clause id="D" obligation="normative">
           <title>1.<tab/>Scope</title>
           <p id="E">Text</p>
         </clause>
          </sections>
      </un-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
        <div id="D">
          <h1 id="toc0">1.&#xA0; Scope</h1>
          <p id="E">Text</p>
        </div>
      </main>
    OUTPUT

    processor.output(input, "test.xml", "test.html", :html)

    expect(
      xmlpp(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>")),
    ).to be_equivalent_to output
  end

  it "generates DOC from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    FileUtils.rm_f "test.doc"
    input = <<~"INPUT"
      <un-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <clause id="D" obligation="normative">
           <title>1.<tab/>Scope</title>
           <p id="E">Text</p>
         </clause>
          </sections>
      </un-standard>
    INPUT

    processor.output(input, "test.xml", "test.doc", :doc)
    expect(File.read("test.doc", encoding: "utf-8"))
      .to include '<div class="WordSection3"><div><a name="D" id="D"></a><h1>1.<span style="mso-tab-count:1">&#xA0; </span>Scope</h1><p class="MsoNormal"><a name="E" id="E"></a>Text</p></div>'
  end

  it "parses :toc document attribute" do
    FileUtils.rm_f "test.xml"
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :toc:
    INPUT
    output = <<~OUTPUT
      {:breakupurlsintables=>false, :datauriimage=>true, :hierarchicalassets=>false, :sourcehighlighter=>true, :suppressasciimathdup=>true, :toc=>"local-variable", :tocfigures=>false, :tocrecommendations=>false, :toctables=>false, :usexinclude=>true}
    OUTPUT
    expect(Metanorma::UN::Input::Asciidoc.new.extract_options(input)
      .sort.to_h.to_s).to eq output.strip
  end
end
