require_relative "metadata"
require "fileutils"
require "roman-numerals"

module IsoDoc
  module Unece
    module BaseConvert
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:toc, @toc)
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{anchor(annex['id'], :label)}"
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
        preface_names(d.at(ns("//abstract")))
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

      def annex_levelnum(num, lvl)
        case lvl % 3
        when 0 then RomanNumerals.to_roman(num)
        when 1 then ("A".ord + num - 1).chr
        when 2 then num.to_s
        end
      end

      NONTERMINAL =
        "./clause | ./term  | ./terms | ./definitions | ./references".freeze

      def leaf_section?(clause)
        !clause.at(ns(NONTERMINAL)) &&
          !%w(definitions annex terms).include?(clause.name) &&
          clause.at(ns("./p | ./bibitem"))
      end

      def label_leaf_section(clause, lvl)
        @paranumber += 1
        @anchors[clause["id"]] = {label: @paranumber.to_s, 
                                  xref: "paragraph #{@paranumber}", 
                                  level: lvl, type: "paragraph" }
      end

      def label_annex_leaf_section(clause, num, lvl)
        @paranumber += 1
        @anchors[clause["id"]] = {label: @paranumber.to_s, 
                                  xref: "paragraph #{num}.#{@paranumber}", 
                                  level: lvl, type: "paragraph" }
      end

      def section_names(clause, num, lvl)
        return num if clause.nil?
        leaf_section?(clause) and label_leaf_section(clause, lvl) and return
        num = num + 1
        lbl = levelnumber(num, 1)
        @anchors[clause["id"]] = { label: lbl, level: lvl, type: "clause",
                                   xref: l10n("#{@clause_lbl} #{lbl}") }
        i = 1
        clause.xpath(ns(NONTERMINAL)).each do |c|
          section_names1(c, "#{lbl}.#{levelnumber(i, lvl + 1)}", lvl + 1)
          i += 1 if !leaf_section?(c)
        end
        num
      end

      def section_names1(clause, num, level)
        leaf_section?(clause) and label_leaf_section(clause, level) and return
        /\.(?<leafnum>[^.]+$)/ =~ num
        @anchors[clause["id"]] = { label: leafnum, level: level, type: "clause",
                                   xref: l10n("#{@clause_lbl} #{num}") }
        i = 1
        clause.xpath(ns(NONTERMINAL)).each do |c|
          section_names1(c, "#{num}.#{levelnumber(i, level + 1)}", level + 1)
          i += 1 if !leaf_section?(c)
        end
      end

      def annex_name_lbl(clause, num)
        l10n("<b>#{@annex_lbl} #{num}</b>")
      end

      def annex_names(clause, num)
        hierarchical_asset_names(clause, num)
        leaf_section?(clause) and
          label_annex_leaf_section(clause, num, 1) and return
        @anchors[clause["id"]] = { label: annex_name_lbl(clause, num),
                                   type: "clause",
                                   xref: "#{@annex_lbl} #{num}", level: 1 }
        i = 1
        clause.xpath(ns("./clause")).each do |c|
          annex_names1(c, "#{num}.#{annex_levelnum(i, 2)}", 2)
          i += 1 if !leaf_section?(c)
        end
      end

      def annex_names1(clause, num, level)
        leaf_section?(clause) and
          label_annex_leaf_section(clause, num, level) and return
        /\.(?<leafnum>[^.]+$)/ =~ num
        @anchors[clause["id"]] = { label: leafnum, xref: "#{@annex_lbl} #{num}",
                                   level: level, type: "clause" }
        i = 1
        clause.xpath(ns("./clause | ./references")).each do |c|
          annex_names1(c, "#{num}.#{annex_levelnum(i, level + 1)}", level + 1)
          i += 1 if !leaf_section?(c)
        end
      end

      def back_anchor_names(docxml)
        docxml.xpath(ns("//annex")).each_with_index do |c, i|
          @paranumber = 0
          annex_names(c, RomanNumerals.to_roman(i + 1))
        end
        docxml.xpath(ns("//bibliography/clause |"\
                        "//bibliography/references")).each do |b|
          preface_names(b)
        end
        docxml.xpath(ns("//bibitem[not(ancestor::bibitem)]")).each do |ref|
          reference_names(ref)
        end
      end

      def sequential_admonition_names(clause)
        i = 0
        clause.xpath(ns(".//admonition")).each do |t|
          i += 1 unless t["unnumbered"]
          next if t["id"].nil? || t["id"].empty?
          @anchors[t["id"]] = anchor_struct(i.to_s, nil, @admonition_lbl,
                                            "box", t["unnumbered"])
        end
      end

      def hierarchical_admonition_names(clause, num)
        i = 0
        clause.xpath(ns(".//admonition")).each do |t|
          i += 1 unless t["unnumbered"]
          next if t["id"].nil? || t["id"].empty?
          @anchors[t["id"]] =
            anchor_struct("#{num}.#{i}", nil, @admonition_lbl, "box",
                          t["unnumbered"])
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
        div.p **{ class: "AdmonitionTitle", style: "text-align:center;" } do |p|
          lbl = anchor(node['id'], :label)
          lbl.nil? or p << l10n("#{@admonition_lbl} #{lbl}")
          name and !lbl.nil? and p << "&nbsp;&mdash; "
          name and name.children.each { |n| parse(n, div) }
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
          if lbl = anchor(node['id'], :label)
            s << "#{lbl}. " unless @suppressheadingnumbers
            insert_tab(s, 1)
          end
          s << "#{title} "
        end
      end
    end
  end
end
