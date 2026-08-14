# frozen_string_literal: true

module Metanorma
  module Un::Document
    module Sections
      # UN sections container.
      # Corresponds to un.rnc:
      #   sections = element sections { (clause | floating-title)+ }
      #
      # UN does not allow terms/definitions at top level of sections.
      class UnSections < Metanorma::Standoc::Document::Sections::Sections
        xml do
          element "sections"
          ordered

          map_element "clause",         to: :clause
          map_element "floating-title", to: :floating_title

          Metanorma::Standoc::Document::SectionXmlMapping.apply_sections_attributes(self)
        end
      end
    end
  end
end
