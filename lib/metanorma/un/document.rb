# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module Un
  end
end

module Metanorma
  module Un::Document
    autoload :Blocks, "metanorma/un/document/blocks"
    autoload :Metadata, "metanorma/un/document/metadata"
    autoload :Root, "metanorma/un/document/root"
    autoload :Sections, "metanorma/un/document/sections"
    autoload :Un_text_element, "metanorma/un/document/un_text_element"
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
  renderers: { html: lambda do |_document, **_options|
    Metanorma::Html::StandardRenderer
  end },
))
