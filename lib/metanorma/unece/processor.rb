require "metanorma/processor"

module Metanorma
  module Unece
    class Processor < Metanorma::Processor

      def initialize
        @short = :unece
        @input_format = :asciidoc
        @asciidoctor_backend = :unece
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
        )
      end

      def version
        "Metanorma::Unece #{Metanorma::Unece::VERSION}"
      end

      def input_to_isodoc(file)
        Metanorma::Input::Asciidoc.new.process(file, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Unece::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Unece::WordConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
