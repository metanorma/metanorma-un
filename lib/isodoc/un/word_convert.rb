require_relative "base_convert"
require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        @toc = options[:toc]
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' :
                     '"Times New Roman",serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' :
                       '"Times New Roman",serif'),
          monospacefont: '"Courier New",monospace'
        }
      end

      def default_file_locations(options)
        {
          wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("unece.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_unece_titlepage.html"),
          wordintropage: html_doc_path("word_unece_intro.html"),
          ulstyle: "l3",
          olstyle: "l2",
        }
      end

      def footnotes(div)
        if @meta.get[:item_footnote]
          fn = noko do |xml|
            xml.aside **{ id: "ftnitem" } do |div|
              div.p @meta.get[:item_footnote]
            end
          end.join("\n")
          @footnotes.unshift fn
        end
        super
      end

      def make_body(xml, docxml)
        plenary = is_plenary?(docxml)
        if plenary &&
            @wordcoverpage == html_doc_path("word_unece_titlepage.html")
          @wordcoverpage = html_doc_path("word_unece_plenary_titlepage.html")
        end
        @wordintropage = nil if plenary && !@toc
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          info docxml, div2
          boilerplate docxml, div2
          preface_block docxml, div2
          abstract docxml, div2
          foreword docxml, div2
          introduction docxml, div2
          preface docxml, div2
          acknowledgements docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end

      ENDLINE = <<~END.freeze
      <v:line 
 alt="" style='position:absolute;left:0;text-align:left;z-index:251662848;
 mso-wrap-edited:f;mso-width-percent:0;mso-height-percent:0;
 mso-width-percent:0;mso-height-percent:0'
 from="6.375cm,20.95pt" to="10.625cm,20.95pt"
 strokeweight="1.5pt"/>
      END

      def end_line(_isoxml, out)
        out.parent.add_child(ENDLINE)
      end

      def middle(isoxml, out)
        middle_admonitions(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
        end_line(isoxml, out)
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        out.div **{ class: "Section3", id: f["id"] } do |div|
          page_break(out)
          div.p(**{ class: "IntroTitle" }) do |h1|
            f&.at(ns("./title"))&.children&.each { |n| parse(n, h1) }
          end
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        out.div **attr_code(id: f["id"]) do |s|
          page_break(out)
          s.p(**{ class: "ForewordTitle" }) do |h1|
            f&.at(ns("./title"))&.children&.each { |n| parse(n, h1) }
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def word_preface(docxml)
        super
        preface_container =
          docxml.at("//div[@id = 'preface_container']") # recommendation
        abstractbox = docxml.at("//div[@id = 'abstractbox']") # plenary
        foreword = docxml.at("//p[@class = 'ForewordTitle']/..")
        intro = docxml.at("//p[@class = 'IntroTitle']/..")
        abstract = docxml.at("//p[@class = 'AbstractTitle']/..")
        abstract.parent = (abstractbox || preface_container) if abstract &&
          (abstractbox || preface_container)
        abstractbox and abstract&.xpath(".//p/br")&.each do |a|
          a.parent.remove if /page-break-before:always/.match(a["style"])
        end
        docxml&.at("//p[@class = 'AbstractTitle']")&.remove if abstractbox
        foreword.parent = preface_container if foreword && preface_container
        intro.parent = preface_container if intro && preface_container
        if preface_container && (foreword || intro)
          preface_container.at("./div/p[br]").remove # remove initial page break
        end
        if abstractbox && !intro && !foreword && !@toc
          sect2 = docxml.at("//div[@class='WordSection2']")
          sect2.next_element.remove # pagebreak
          sect2.remove # pagebreak
        end
        abstractbox.parent.remove if abstractbox && !abstract
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//abstract")) || return
        out.div **attr_code(id: f["id"]) do |s|
          page_break(out)
          s.p(**{ class: "AbstractTitle" }) do |h1|
            f&.at(ns("./title"))&.children&.each { |n| parse(n, h1) }
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def authority_cleanup(docxml)
        super
        a = docxml.at("//div[@id = 'boilerplate-ECEhdr']") and
          a["class"] = "boilerplate-ECEhdr"
        docxml&.at("//div[@class = 'authority']")&.remove
      end

      include BaseConvert
      include Init
    end
  end
end
