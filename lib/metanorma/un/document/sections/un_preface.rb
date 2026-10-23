# frozen_string_literal: true

module Metanorma
  module Un::Document
    module Sections
      # UN preface with only abstract, foreword, introduction.
      # Corresponds to un.rng:
      #   preface = element preface { abstract?, foreword?, introduction? }
      #
      # This class deliberately does NOT inherit StandardDocument::Preface:
      # lutaml-model deep-duplicates a parent's XML mappings into subclasses,
      # so inheriting would keep the isodoc-level acknowledgements,
      # executivesummary and clause mappings that the UN grammar forbids.
      # Attributes are composed directly instead.
      #
      # The UN abstract is a Basic-Section (UnAbstractSection); foreword and
      # introduction keep the isodoc Content-Section model.
      class UnPreface < Lutaml::Model::Serializable
        attribute :abstract, UnAbstractSection
        attribute :foreword, Metanorma::Standoc::Document::Sections::ContentSection
        attribute :introduction, Metanorma::Standoc::Document::Sections::ContentSection

        # Presentation-specific attributes
        attribute :semx_id, :string
        attribute :displayorder, :integer

        xml do
          element "preface"
          ordered

          map_element "abstract",      to: :abstract
          map_element "foreword",      to: :foreword
          map_element "introduction",  to: :introduction

          Metanorma::Standoc::Document::SectionXmlMapping.apply_preface_attributes(self)
        end
      end
    end
  end
end
