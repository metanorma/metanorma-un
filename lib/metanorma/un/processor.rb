require "metanorma/processor"

module Metanorma
  module UN
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

      def fonts_manifest
        {
          "Arial" => nil,
          "Arial Black" => nil,
          "Courier New" => nil,
          "Times New Roman" => nil,
          "STIX Two Math" => nil,
          "Source Han Sans" => nil,
          "Source Han Sans Normal" => nil,
        }
      end

      def version
        "Metanorma::UN #{Metanorma::UN::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
        options_preprocess(options)
        case format
        when :html
          IsoDoc::UN::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::UN::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::UN::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::UN::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
