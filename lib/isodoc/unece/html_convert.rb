require "isodoc"
require_relative "metadata"
require "fileutils"
require "roman-numerals"

module IsoDoc
  module Unece

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        FileUtils.cp html_doc_path('logo.jpg'), "logo.jpg"
        @files_to_delete << "logo.jpg"
      end

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
          scripts: html_doc_path("scripts.html"),
        }
      end

      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:toc, @toc)
      end

      def html_head
        <<~HEAD.freeze
          <title>{{ doctitle }}</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!--TOC script import-->
    <script type="text/javascript" src="https://cdn.rawgit.com/jgallen23/toc/0.3.2/dist/toc.min.js"></script>

    <!--Google fonts-->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,400i,500,700,900" rel="stylesheet">
    <!--Font awesome import for the link icon-->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/solid.css" integrity="sha384-v2Tw72dyUXeU3y4aM2Y0tBJQkGfplr39mxZqlTBDUZAb9BGoC40+rdFCG0m10lXk" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/fontawesome.css" integrity="sha384-q3jl8XQu1OpdLgGFvNRnPdj5VIlCvgsDQTQB6owSOHWlAurxul7f+JpUOVdAiJ5P" crossorigin="anonymous">
    <style class="anchorjs"></style>
        HEAD
      end

      def make_body(xml, docxml)
        plenary = docxml.at(ns("//bibdata[@type = 'plenary']"))
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72", "xml:lang": "EN-US", class: "container" }
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
=begin
        preface_container = docxml.at("//div[@id = 'preface_container']") # recommendation
        abstractbox = docxml.at("//div[@id = 'abstractbox']") # plenary
        foreword = docxml.at("//p[@class = 'ForewordTitle']/..")
        intro = docxml.at("//p[@class = 'IntroTitle']/..")
        abstract = docxml.at("//h1[@class = 'AbstractTitle']/..")
        abstract.parent = (abstractbox || preface_container) if abstract
        docxml.at("//h1[@class = 'AbstractTitle']").remove if abstractbox
        foreword.parent = preface_container if foreword && preface_container
        intro.parent = preface_container if intro && preface_container
        if abstractbox && !intro && !foreword
          sect2 = docxml.at("//div[@class='WordSection2']")
          sect2.next_element.remove # pagebreak
          sect2.remove # pagebreak
        end
=end
        docxml
      end

      def middle(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def html_toc(docxml)
        docxml
      end

      def clause_parse_title(node, div, c1, out)
        if node["inline-header"] == "true"
          inline_header_title(out, node, c1)
        else
          div.send "h#{get_anchors[node['id']][:level]}" do |h|
            lbl = get_anchors[node['id']][:label]
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

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}"
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def i18n_init(lang, script)
        super
        @admonition_lbl = "Box"
        @abstract_lbl = "Summary"
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
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
        hierarchical_asset_names(clause, num)
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

      def abstract(isoxml, out)
        f = isoxml.at(ns("//abstract")) || return
        page_break(out)
        out.div **attr_code(id: f["id"]) do |s|
          s.h1(**{ class: "AbstractTitle" }) { |h1| h1 << @abstract_lbl }
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end
    end
  end
end

