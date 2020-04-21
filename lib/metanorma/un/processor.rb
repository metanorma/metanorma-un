require "metanorma/processor"

module Metanorma
  module UN
    def self.pdf_fonts
      ["Arial", "Arial Black", "Courier", "Times New Roman", "HanSans"]
    end

    class Processor < Metanorma::Processor

      def initialize
        @short = :un
        @input_format = :asciidoc
        @asciidoctor_backend = :un
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf",
        )
      end

      def version
        "Metanorma::UN #{Metanorma::UN::VERSION}"
      end

      def input_to_isodoc(file, filename)
        Metanorma::UN::Input::Asciidoc.new.process(file, filename, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::UN::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::UN::WordConvert.new(options).convert(outname, isodoc_node)
        when :pdf
          IsoDoc::UN::PdfConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
