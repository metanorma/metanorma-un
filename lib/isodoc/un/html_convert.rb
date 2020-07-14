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
            options[:script] == "Hans" ?
            '"SimSun",serif' :
            '"Times New Roman", serif'
          ),
          headerfont: (
            options[:script] == "Hans" ?
            '"SimHei",sans-serif' :
            '"Times New Roman", serif'
          ),
          monospacefont: '"Courier New",monospace'
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_unece_titlepage.html"),
          htmlintropage: html_doc_path("html_unece_intro.html"),
          scripts: html_doc_path("scripts.html"),
        }
      end


      def googlefonts
        <<~HEAD.freeze
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500,700,900" rel="stylesheet">
        HEAD
      end

      def make_body(xml, docxml)
        plenary = is_plenary?(docxml)
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

      def make_body3(body, docxml)
        body.div **{ class: "main-section" } do |div3|
          boilerplate docxml, div3
          abstract docxml, div3
          foreword docxml, div3
          introduction docxml, div3
          preface docxml, div3
          acknowledgements docxml, div3
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def middle(isoxml, out)
        middle_admonitions(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        page_break(out)
        out.div **{ class: "Section3", id: f["id"] } do |div|
          div.h1(**{ class: "IntroTitle" }) do |h1|
            h1 << @i18n.introduction
          end
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          s.h1(**{ class: "ForewordTitle" }) do |h1|
            h1 << @i18n.foreword
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      include BaseConvert
      include Init
    end
  end
end

