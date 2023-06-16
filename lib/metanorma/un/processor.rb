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
          "Noto Serif" => nil,
          "Noto Serif HK" => nil,
          "Noto Serif JP" => nil,
          "Noto Serif KR" => nil,
          "Noto Serif SC" => nil,
          "Noto Serif TC" => nil,
          "Noto Sans Mono" => nil,
          "Noto Sans Mono CJK HK" => nil,
          "Noto Sans Mono CJK JP" => nil,
          "Noto Sans Mono CJK KR" => nil,
          "Noto Sans Mono CJK SC" => nil,
          "Noto Sans Mono CJK TC" => nil,
        }
      end

      def version
        "Metanorma::UN #{Metanorma::UN::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
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
