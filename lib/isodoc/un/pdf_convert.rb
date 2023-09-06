require_relative "base_convert"
require "isodoc"

module IsoDoc
  module UN

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(docxml)
        case @doctype
        when "plenary", "agenda", "budgetary" 
          "un.plenary.xsl"
        else
          docxml.at(ns("//bibdata/ext/session/*")) ?
            "un.plenary-attachment.xsl" : "un.recommendation.xsl"
        end
      end
    end
  end
end

