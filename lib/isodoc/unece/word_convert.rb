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
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
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
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "")
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

      # SAME as html_convert.rb from here on, starting with annex_name

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]} "
          t << "<b>#{name.text}</b>"
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

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]} "
          t << "<b>#{name.text}</b>"
        end
      end

      def annex_name_lbl(clause, num)
        obl = l10n("(#{@inform_annex_lbl})")
        obl = l10n("(#{@norm_annex_lbl})") if clause["obligation"] == "normative"
        l10n("<b>#{@annex_lbl} #{num}</b> #{obl}")
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

      def middle(isoxml, out)
        middle_title(out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

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
        unless clause.at(ns("./clause | ./term  | ./terms | ./definitions"))
          leaf_section(clause, lvl) and return
        end
        num = num + 1
        lbl = levelnumber(num, 1)
        @anchors[clause["id"]] =
          { label: lbl, xref: l10n("#{@clause_lbl} #{lbl}"), level: lvl, type: "clause" }
        clause.xpath(ns("./clause | ./term  | ./terms | ./definitions")).
          each_with_index do |c, i|
          section_names1(c, "#{lbl}.#{levelnumber(i + 1, lvl + 1)}", lvl + 1)
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
        clause.xpath(ns("./clause | ./terms | ./term | ./definitions")).
          each_with_index do |c, i|
          section_names1(c, "#{num}.#{levelnumber(i + 1, level + 1)}", level + 1)
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
        clause.xpath(ns("./clause")).each_with_index do |c, i|
          annex_names1(c, "#{num}.#{levelnumber(i + 1, 2)}", 2)
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
        clause.xpath(ns("./clause")).each_with_index do |c, i|
          annex_names1(c, "#{num}.#{levelnumber(i + 1, level + 1)}", level + 1)
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
    end
  end
end

