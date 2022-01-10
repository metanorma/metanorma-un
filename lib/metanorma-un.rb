require "metanorma/un"
require "asciidoctor"
require "isodoc/un"

if defined? Metanorma
  Metanorma::Registry.instance.register(Metanorma::UN::Processor)
end
