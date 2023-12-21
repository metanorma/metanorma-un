require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "metanorma-un"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

OPTIONS = [backend: :un, header_footer: true].freeze

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def strip_guid(xml)
  xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&").gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def presxml_options
  { semanticxmlinsert: "false" }
end

def xmlpp(xml)
  c = HTMLEntities.new
  xml &&= xml.split(/(&\S+?;)/).map do |n|
    if /^&\S+?;$/.match?(n)
      c.encode(c.decode(n), :hexadecimal)
    else n
    end
  end.join
  xsl = <<~XSL
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:template match="/">
        <xsl:copy-of select="."/>
      </xsl:template>
    </xsl:stylesheet>
  XSL
  Nokogiri::XSLT(xsl).transform(Nokogiri::XML(xml, &:noblanks))
    .to_xml(indent: 2, encoding: "UTF-8")
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

def boilerplate_read(file, xmldoc)
  conv = Metanorma::UN::Converter.new(:un, {})
  conv.init(Asciidoctor::Document.new([]))
  x = conv.boilerplate_isodoc(xmldoc).populate_template(file, nil)
  ret = conv.boilerplate_file_restructure(x)
  ret.to_xml(encoding: "UTF-8", indent: 2,
             save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
    .gsub(/<(\/)?sections>/, "<\\1boilerplate>")
    .gsub(/ id="_[^"]+"/, " id='_'")
end

def boilerplate(xmldoc)
  file = File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "un",
                   "boilerplate.adoc")
  ret = Nokogiri::XML(boilerplate_read(
                        File.read(file, encoding: "utf-8")
                        .gsub(/<\/?membership>/, ""), xmldoc
                      ))
  ret.xpath("//passthrough").each(&:remove)
  strip_guid(ret.root.to_xml(encoding: "UTF-8", indent: 2,
                             save_with: Nokogiri::XML::Node::SaveOptions::AS_XML))
end

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <un-standard xmlns="https://www.metanorma.org/ns/un" type="semantic" version="#{Metanorma::UN::VERSION}">
  <bibdata type="standard">
   <title type='main' language='en' format='text/plain'>Document title</title>
    <contributor>
      <role type="author"/>
      <organization>
        <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
      </organization>
    </contributor>
    <contributor>
      <role type="publisher"/>
      <organization>
        <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
      </organization>
    </contributor>
    <language>ar</language>
   <language>ru</language>
   <language>en</language>
   <language>fr</language>
   <language>zh</language>
   <language>es</language>
    <script>Latn</script>

    <status> <stage>published</stage> </status>
    <copyright>
      <from>#{Date.today.year}</from>
      <owner>
        <organization>
          <name>#{Metanorma::UN::ORGANIZATION_NAME_LONG}</name>
        </organization>
      </owner>
    </copyright>
    <ext>
    <doctype>recommendation</doctype>
    <session/>
    </ext>
  </bibdata>
                         <metanorma-extension>
            <presentation-metadata>
              <name>TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>HTML TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>DOC TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>PDF TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
          </metanorma-extension>
HDR

def blank_hdr_gen
  <<~"HDR"
    #{BLANK_HDR}
    #{boilerplate(Nokogiri::XML("#{BLANK_HDR}</un-standard>"))}
  HDR
end

HTML_HDR = <<~"HDR".freeze
  <html xmlns:epub="http://www.idpf.org/2007/ops" lang="en">
  <head/>
     <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
     <div class="title-section">
       <p>&#160;</p>
     </div>
     <br/>
     <div class="prefatory-section">
       <p>&#160;</p>
     </div>
     <br/>
     <div class="main-section">
HDR

def mock_pdf
  allow(::Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.gsub(/"/, ""), output.gsub(/"/, ""))
  end
end
