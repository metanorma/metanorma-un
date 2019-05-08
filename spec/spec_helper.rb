require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "metanorma-unece"
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

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(x)
  HTMLEntities.new.encode(x, :hexadecimal).gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n").
    gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<").gsub(/&#x26;/, '&').gsub(/&#x27;/, "'").
    gsub(/\\u(....)/) { |s| "&#x#{$1.downcase};" }
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

BLANK_HDR = <<~"HDR"
       <?xml version="1.0" encoding="UTF-8"?>
       <unece-standard xmlns="#{Metanorma::Unece::DOCUMENT_NAMESPACE}">
       <bibdata type="recommendation">

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
               <name>#{Metanorma::Unece::ORGANIZATION_NAME_SHORT}</name>
             </organization>
           </owner>
         </copyright>
         <editorialgroup>
           <committee/>
         </editorialgroup>
         <session/>
       </bibdata>
HDR

HTML_HDR = <<~"HDR"
        <html>
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

