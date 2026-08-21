# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module Un
  end
end

module Metanorma
  module Un::Document
  end
end

module Metanorma
  existing = defined?(Metanorma::UnDocument) && Metanorma::UnDocument
  if !existing.equal?(Metanorma::Un::Document)
    Metanorma.send(:remove_const, :UnDocument) if existing
    UnDocument = Metanorma::Un::Document
  end
end

require "metanorma/un/registers"
Metanorma::Un::Registers.setup

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :un,
  gem: "metanorma-un",
  model_root: Metanorma::Un::Document::Root,
  pubid_module: nil,
  renderers: { html: Metanorma::Html::StandardRenderer },
))
