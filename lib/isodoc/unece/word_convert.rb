require "isodoc"
require_relative "metadata"
require "fileutils"
require "roman-numerals"

module IsoDoc
  module Unece
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        FileUtils.cp html_doc_path('logo.jpg'), "logo.jpg"
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Times New Roman",serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Times New Roman",serif'),
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

      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def make_body(xml, docxml)
        plenary = docxml.at(ns("//bibdata[@type = 'plenary']"))
        if plenary && @wordcoverpage == html_doc_path("word_unece_titlepage.html")
          @wordcoverpage = html_doc_path("word_unece_plenary_titlepage.html")
        end
        @wordintropage = nil if plenary
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
        foreword docxml, div2
        introduction docxml, div2
        div2.p { |p| p << "&nbsp;" } # placeholder
      end
      section_break(body)
    end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//title[@language='en']"))&.text
        set_metadata(:doctitle, main)
      end

      def generate_header(filename, dir)
        return unless @header
        template = Liquid::Template.parse(File.read(@header, encoding: "UTF-8"))
        meta = @meta.get
        meta[:filename] = filename
        params = meta.map { |k, v| [k.to_s, v] }.to_h
        File.open("header.html", "w") { |f| f.write(template.render(params)) }
        @files_to_delete << "header.html"
        "header.html"
      end

      def header_strip(h)
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "").gsub(/<\/?b>/, "")
        h1 = to_xhtml_fragment(h.dup)
        h1.traverse do |x|
          x.replace(" ") if x.name == "span" &&
            /mso-tab-count/.match(x["style"])
          x.remove if x.name == "span" && x["class"] == "MsoCommentReference"
          x.remove if x.name == "a" && x["epub:type"] == "footnote"
          x.replace(x.children) if x.name == "a"
        end
        from_xhtml(h1)
      end

      ENDLINE = <<~END.freeze
      <v:line id="_x0000_s1026"
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
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
        end_line(isoxml, out)
      end

      def clause_parse_title(node, div, c1, out)
        if node["inline-header"] == "true"
          inline_header_title(out, node, c1)
        else
          div.send "h#{get_anchors[node['id']][:level]}" do |h|
            lbl = get_anchors[node['id']][:label]
            h << "#{lbl}. " if lbl && !@suppressheadingnumbers
            insert_tab(h, 1)
            c1&.children&.each { |c2| parse(c2, h) }
          end
        end
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        page_break(out)
        out.div **{ class: "Section3", id: f["id"] } do |div|
          s.p(**{ class: "IntroTitle" }) do |h1|
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
          s.p(**{ class: "ForewordTitle" }) do |h1|
            h1 << @foreword_lbl
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def word_preface(docxml)
        super
        preface_container = docxml.at("//div[@id = 'preface_container']") # recommendation
        abstractbox = docxml.at("//div[@id = 'abstractbox']") # plenary
        foreword = docxml.at("//p[@class = 'ForewordTitle']/..")
        intro = docxml.at("//p[@class = 'IntroTitle']/..")
        foreword.parent = (abstractbox || preface_container) if foreword
        docxml&.at("//p[@class = 'ForewordTitle']")&.remove if abstractbox
        intro.parent = preface_container if intro && preface_container
        if abstractbox && !intro
          sect2 = docxml.at("//div[@class='WordSection2']")
          sect2.next_element.remove # pagebreak
          sect2.remove # pagebreak
        end
      end

      # SAME as html_convert.rb from here on, starting with annex_name

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}"
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def pre_parse(node, out)
        out.pre node.text # content.gsub(/</, "&lt;").gsub(/>/, "&gt;")
      end

      def term_defs_boilerplate(div, source, term, preface)
        if source.empty? && term.nil?
          div << @no_terms_boilerplate
        else
          div << term_defs_boilerplate_cont(source, term)
        end
      end

      def i18n_init(lang, script)
        super
        @admonition_lbl = "Box"
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      def term_cleanup(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |d|
          h2 = d.at("./preceding-sibling::*[@class = 'TermNum'][1]")
          h2.add_child("&nbsp;")
          h2.add_child(d.remove)
        end
        docxml
      end

      MIDDLE_CLAUSE = "//clause[parent::sections]".freeze

      def initial_anchor_names(d)
        preface_names(d.at(ns("//foreword")))
        preface_names(d.at(ns("//introduction")))
        sequential_asset_names(d.xpath(ns("//foreword | //introduction")))
        middle_section_asset_names(d)
        clause_names(d, 0)
        termnote_anchor_names(d)
        termexample_anchor_names(d)
      end

      def clause_names(docxml, sect_num)
        q = "//clause[parent::sections]"
        @paranumber = 0
        docxml.xpath(ns(q)).each_with_index do |c, i|
          section_names(c, (i + sect_num), 1)
        end
      end

      def levelnumber(num, lvl)
        case lvl % 3
        when 1 then RomanNumerals.to_roman(num)
        when 2 then ("A".ord + num - 1).chr
        when 0 then num.to_s
        end
      end

      def annex_levelnumber(num, lvl)
        case lvl % 3
        when 0 then RomanNumerals.to_roman(num)
        when 1 then ("A".ord + num - 1).chr
        when 2 then num.to_s
        end
      end

      def leaf_section(clause, lvl)
        @paranumber += 1
        @anchors[clause["id"]] = {label: @paranumber.to_s, xref: "paragraph #{@paranumber}", level: lvl, type: "paragraph" }
      end

      def annex_leaf_section(clause, num, lvl)
        @paranumber += 1
        @anchors[clause["id"]] = {label: @paranumber.to_s, xref: "paragraph #{num}.#{@paranumber}", level: lvl, type: "paragraph" }
      end

      def section_names(clause, num, lvl)
        return num if clause.nil?
        clause.at(ns("./clause | ./term  | ./terms | ./definitions")) or
          leaf_section(clause, lvl) && return
        num = num + 1
        lbl = levelnumber(num, 1)
        @anchors[clause["id"]] =
          { label: lbl, xref: l10n("#{@clause_lbl} #{lbl}"), level: lvl, type: "clause" }
        i = 1
        clause.xpath(ns("./clause | ./term  | ./terms | ./definitions")).each do |c|
          section_names1(c, "#{lbl}.#{levelnumber(i, lvl + 1)}", lvl + 1)
          i += 1 if c.at(ns("./clause | ./term  | ./terms | ./definitions"))
        end
        num
      end

      def section_names1(clause, num, level)
        unless clause.at(ns("./clause | ./term  | ./terms | ./definitions"))
          leaf_section(clause, level) and return
        end
        /\.(?<leafnum>[^.]+$)/ =~ num
        @anchors[clause["id"]] =
          { label: leafnum, level: level, xref: l10n("#{@clause_lbl} #{num}"), type: "clause" }
        i = 1
        clause.xpath(ns("./clause | ./terms | ./term | ./definitions")).each do |c|
          section_names1(c, "#{num}.#{levelnumber(i, level + 1)}", level + 1)
          i += 1 if c.at(ns("./clause | ./term  | ./terms | ./definitions"))
        end
      end

      def annex_name_lbl(clause, num)
        l10n("<b>#{@annex_lbl} #{num}</b>")
      end

      def annex_names(clause, num)
        unless clause.at(ns("./clause | ./term  | ./terms | ./definitions"))
          annex_leaf_section(clause, num, 1) and return
        end
        @anchors[clause["id"]] = { label: annex_name_lbl(clause, num), type: "clause",
                                   xref: "#{@annex_lbl} #{num}", level: 1 }
        i = 1
        clause.xpath(ns("./clause")).each do |c|
          annex_names1(c, "#{num}.#{annex_levelnumber(i, 2)}", 2)
          i += 1 if c.at(ns("./clause | ./term  | ./terms | ./definitions"))
        end
        hierarchical_asset_names(clause, num)
      end

      def annex_names1(clause, num, level)
        unless clause.at(ns("./clause | ./term  | ./terms | ./definitions"))
          annex_leaf_section(clause, num, level) and return
        end
        /\.(?<leafnum>[^.]+$)/ =~ num
        @anchors[clause["id"]] = { label: leafnum, xref: "#{@annex_lbl} #{num}",
                                   level: level, type: "clause" }
        i = 1
        clause.xpath(ns("./clause")).each do |c|
          annex_names1(c, "#{num}.#{annex_levelnumber(i, level + 1)}", level + 1)
          i += 1 if c.at(ns("./clause | ./term  | ./terms | ./definitions"))
        end
      end

      def back_anchor_names(docxml)
        docxml.xpath(ns("//annex")).each_with_index do |c, i|
          @paranumber = 0
          annex_names(c, RomanNumerals.to_roman(i + 1))
        end
        docxml.xpath(ns("//bibitem[not(ancestor::bibitem)]")).each do |ref|
          reference_names(ref)
        end
      end

      def sequential_admonition_names(clause)
        i = 0
        clause.xpath(ns(".//admonition")).each do |t|
          i += 1
          next if t["id"].nil? || t["id"].empty?
          @anchors[t["id"]] = anchor_struct(i.to_s, nil, @admonition_lbl, "box")
        end
      end

      def hierarchical_admonition_names(clause, num)
        i = 0 
        clause.xpath(ns(".//admonition")).each do |t|
          i += 1
          next if t["id"].nil? || t["id"].empty?
          @anchors[t["id"]] = anchor_struct("#{num}.#{i}", nil, @admonition_lbl, "box")
        end
      end

      def sequential_asset_names(clause)
        super
        sequential_admonition_names(clause)
      end

      def hierarchical_asset_names(clause, num)
        super
        hierarchical_admonition_names(clause, num)
      end

      def admonition_name_parse(node, div, name)
        div.p **{ class: "FigureTitle", align: "center" } do |p|
          p << l10n("#{@admonition_lbl} #{get_anchors[node['id']][:label]}")
          if name
            p << "&nbsp;&mdash; "
            name.children.each { |n| parse(n, div) }
          end
        end
      end

      def admonition_parse(node, out)
        name = node.at(ns("./name"))
        out.div **{ class: "Admonition" } do |t|
          admonition_name_parse(node, t, name) if name
          node.children.each do |n|
            parse(n, t) unless n.name == "name"
          end
        end
      end

      def inline_header_title(out, node, c1)
        title = c1&.content || ""
        out.span **{ class: "zzMoveToFollowing" } do |s|
          if get_anchors[node['id']][:label]
            s << "#{get_anchors[node['id']][:label]}. " unless @suppressheadingnumbers
            insert_tab(s, 1)
          end
          s << "#{title} "
        end
      end
    end
  end
end
