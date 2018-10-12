require "metanorma/unece"
require "asciidoctor"
require "asciidoctor/unece"
require "isodoc/unece"

if defined? Metanorma
  Metanorma::Registry.instance.register(Metanorma::Unece::Processor)
end
