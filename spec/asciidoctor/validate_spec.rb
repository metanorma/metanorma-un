require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::UN do
   it "Warns of illegal doctype" do
       FileUtils.rm_f "test.err"
    Asciidoctor.convert(<<~"INPUT", backend: :un, header_footer: true) 
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :doctype: pizza

  text
  INPUT
    expect(File.read("test.err")).to include "pizza is not a legal document type"
end

it "Warns of illegal status" do
    FileUtils.rm_f "test.err"
    Asciidoctor.convert(<<~"INPUT", backend: :un, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :status: pizza

  text
  INPUT
    expect(File.read("test.err")).to include "pizza is not a recognised status"
end

end

