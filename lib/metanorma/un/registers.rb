# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Un
    # un's lutaml-model register: type substitutions from standoc.
    # Formerly Metanorma::Registers::Setup.setup_un_register in metanorma-document.
    module Registers
      module_function

      def setup
          sd = Metanorma::StandardDocument
          reg = Lutaml::Model::Register.new(:un_document)
          Lutaml::Model::GlobalRegister.register(reg)

          reg.register_global_type_substitution(
            from_type: sd::Sections::Sections,
            to_type: Metanorma::Un::Document::Sections::UnSections,
          )
          reg.register_global_type_substitution(
            from_type: sd::Sections::Preface,
            to_type: Metanorma::Un::Document::Sections::UnPreface,
          )
          reg.register_global_type_substitution(
            from_type: Metanorma::Document::Components::MultiParagraph::AdmonitionBlock,
            to_type: Metanorma::Un::Document::Blocks::UnAdmonitionBlock,
          )
      end
    end
  end
end
