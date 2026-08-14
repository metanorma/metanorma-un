# frozen_string_literal: true

require "metanorma/standoc"
# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/un.rb).
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
    autoload :UnTextElement, "metanorma/un/document/un_text_element"
  end
end


# Backwards-compat alias so external consumers that reference
# Metanorma::UnDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::UnDocument) && Metanorma::UnDocument
  if !existing.equal?(Metanorma::Un::Document)
    Metanorma.send(:remove_const, :UnDocument) if existing
    UnDocument = Metanorma::Un::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_un_register)
  Metanorma::Registers::Setup.setup_un_register
end

module Metanorma
  deprecate_constant :UnDocument
end
