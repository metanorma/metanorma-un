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
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(x)
  HTMLEntities.new.encode(x, :hexadecimal).gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n").
    gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<").gsub(/&#x26;/, '&').gsub(/&#x27;/, "'").
    gsub(/\\u(....)/) { |s| "&#x#{$1.downcase};" }
end

def xmlpp(x)
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(x),s)
  s
end

ASCIIDOC_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

HDR

BOILERPLATE =
  HTMLEntities.new.decode(
  File.read(File.join(File.dirname(__FILE__), "..", "lib", "asciidoctor", "un", "boilerplate.xml"), encoding: "utf-8").
  gsub(/\{\{ agency \}\}/, "ISO").gsub(/\{\{ docyear \}\}/, Date.today.year.to_s).
  gsub(/\{% if unpublished %\}.*\{% endif %\}/m, "").
  gsub(/<p>/, "<p id='_'>").
  gsub(/\{% if tc == "United Nations Centre for Trade Facilitation and Electronic Business \(UN\/CEFACT\)" %\}.*?\{% endif %\}/m, "").
  gsub(/(?<=\p{Alnum})'(?=\p{Alpha})/, "’")
)

BLANK_HDR = <<~"HDR"
       <?xml version="1.0" encoding="UTF-8"?>
       <un-standard xmlns="https://www.metanorma.org/ns/un">
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
       #{BOILERPLATE}
HDR

HTML_HDR = <<~"HDR"
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


