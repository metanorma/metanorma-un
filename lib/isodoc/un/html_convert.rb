require_relative "base_convert"
require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        {
          bodyfont: (
            if options[:script] == "Hans"
              '"Source Han Sans",serif'
            else
              '"Times New Roman", serif'
            end
          ),
          headerfont: (
            if options[:script] == "Hans"
              '"Source Han Sans",sans-serif'
            else
              '"Times New Roman", serif'
            end
          ),
          monospacefont: '"Courier New",monospace',
          normalfontsize: "15px",
          footnotefontsize: "0.9em",
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_unece_titlepage.html"),
          htmlintropage: html_doc_path("html_unece_intro.html"),
        }
      end

      def googlefonts
        <<~HEAD.freeze
          <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
          <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500,700,900" rel="stylesheet">
        HEAD
      end

      def make_body(xml, docxml)
        plenary = plenary?(docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72",
                      "xml:lang": "EN-US", class: "container" }
        if plenary &&
            @htmlcoverpage == html_doc_path("html_unece_titlepage.html")
          @htmlcoverpage = html_doc_path("html_unece_plenary_titlepage.html")
        end
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def introduction(clause, out)
        page_break(out)
        out.div class: "Section3", id: clause["id"] do |div|
          clause_name(clause, clause.at(ns("./title")), div, { class: "IntroTitle" })
          clause.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def foreword(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"]) do |s|
          clause_name(clause, clause.at(ns("./title")) || @i18n.foreword, s,
                      class: "ForewordTitle")
          clause.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      include BaseConvert
      include Init
    end
  end
end
