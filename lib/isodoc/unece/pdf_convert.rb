require_relative "base_convert"
require "isodoc"

module IsoDoc
  module Unece

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class PdfConvert < IsoDoc::PdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      #def convert1(docxml, filename, dir)
        #FileUtils.cp html_doc_path('logo.jpg'), File.join(@localdir, "logo.jpg")
        #@files_to_delete << File.join(@localdir, "logo.jpg")
        #super
      #end

      def default_fonts(options)
        {
          bodyfont: (
            options[:script] == "Hans" ?
            '"SimSun",serif' :
            '"Roboto", "Helvetica Neue", Helvetica, Arial, sans-serif'
          ),
          headerfont: (
            options[:script] == "Hans" ?
            '"SimHei",sans-serif' :
            '"Roboto", "Helvetica Neue", Helvetica, Arial, sans-serif'
          ),
          monospacefont: '"Space Mono",monospace'
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_unece_titlepage.html"),
          htmlintropage: html_doc_path("html_unece_intro.html"),
          scripts: html_doc_path("scripts.pdf.html"),
        }
      end


      def googlefonts
        <<~HEAD.freeze
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500,700,900" rel="stylesheet">
        HEAD
      end

      def make_body(xml, docxml)
        plenary = docxml.at(ns("//bibdata/ext[doctype = 'plenary']"))
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72", "xml:lang": "EN-US", class: "container" }
        if plenary && @htmlcoverpage == html_doc_path("html_unece_titlepage.html")
          @htmlcoverpage = html_doc_path("html_unece_plenary_titlepage.html")
        end
        #@htmlintropage = nil if plenary
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def make_body3(body, docxml)
        body.div **{ class: "main-section" } do |div3|
          abstract docxml, div3
          foreword docxml, div3
          introduction docxml, div3
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def html_preface(docxml)
        super
        docxml
      end

      def middle(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def clause_parse_title(node, div, c1, out)
        if node["inline-header"] == "true"
          inline_header_title(out, node, c1)
        else
          div.send "h#{anchor(node['id'], :level) || '1'}" do |h|
            lbl = anchor(node['id'], :label, false)
            h << "#{lbl}. " if lbl && !@suppressheadingnumbers
            insert_tab(h, 1) if lbl && !@suppressheadingnumbers
            c1&.children&.each { |c2| parse(c2, h) }
          end
        end
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        page_break(out)
        out.div **{ class: "Section3", id: f["id"] } do |div|
          div.h1(**{ class: "IntroTitle" }) do |h1|
            h1 << @introduction_lbl
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
            h1 << @foreword_lbl
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      include BaseConvert
    end
  end
end

