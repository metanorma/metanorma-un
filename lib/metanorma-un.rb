require "metanorma/un"
require "asciidoctor"
require "isodoc/un"
require "metanorma"

if defined? Metanorma::Registry
  Metanorma::Registry.instance.register(Metanorma::UN::Processor)
end
