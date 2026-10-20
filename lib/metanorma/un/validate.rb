module Metanorma
  module UN
    class Validate < Standoc::Validate
      # The old RNG pass is retired with the model-based pipeline: UN's
      # RNGs predate the current semantic model, and the gem ships no
      # generated compile schema.
      def validate(doc)
        @log.add_error_ranges(doc)
        content_validate(doc)
      end

      def content_validate(doc)
        super
        bibdata_validate(doc.root)
      end

      def bibdata_validate(doc)
        stage_validate(doc)
      end

      def stage_validate(xmldoc)
        stage = xmldoc&.at("//bibdata/status/stage")&.text
        %w(proposal working-draft committee-draft draft-standard final-draft
           published withdrawn).include? stage or
          @log.add(:UN_2, nil, params: [stage])
      end
    end
  end
end
