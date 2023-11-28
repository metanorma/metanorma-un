require "roman-numerals"

module IsoDoc
  module UN
    class Xref < IsoDoc::Xref
      def clause_order_main(_docxml)
        [{ path: "//sections/clause | //sections/terms | //sections/definitions", multi: true }]
      end

      def asset_anchor_names(doc)
        super
        @parse_settings.empty? or return
        sequential_asset_names(
          doc.xpath(ns("//preface/abstract | //foreword | //introduction | " \
                       "//preface/clause | //acknowledgements")),
        )
      end

      def main_anchor_names(xml)
        @paranumber = 0
        super
      end

      def levelnumber(num, lvl)
        case lvl % 3
        when 1 then RomanNumerals.to_roman(num.to_i)
        when 2 then ("A".ord + num.to_i - 1).chr
        when 0 then num.to_s
        end
      end

      def annex_levelnum(num, lvl)
        case lvl % 3
        when 0 then RomanNumerals.to_roman(num.to_i)
        when 1 then ("A".ord + num.to_i - 1).chr
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
        @paranumber.nil? and @paranumber = 0
        @paranumber += 1
        @anchors[clause["id"]] =
          { label: @paranumber.to_s, elem: @labels["paragraph"],
            xref: l10n("#{@labels['paragraph']} #{@paranumber}"),
            level: lvl, type: "paragraph" }
      end

      def label_annex_leaf_section(clause, num, lvl)
        @paranumber += 1
        @anchors[clause["id"]] =
          { label: @paranumber.to_s, elem: @labels["paragraph"],
            xref: l10n("#{@labels['paragraph']} #{num}.#{@paranumber}"),
            level: lvl, type: "paragraph" }
      end

      def section_names(clause, num, lvl)
        clause.nil? and return num
        leaf_section?(clause) and label_leaf_section(clause, lvl) and return
        lbl = levelnumber(num.increment(clause).print, 1)
        @anchors[clause["id"]] = { label: lbl, level: lvl, type: "clause",
                                   elem: @labels["clause"],
                                   xref: l10n("#{@labels['clause']} #{lbl}") }
        i = 1
        clause.xpath(ns(NONTERMINAL)).each do |c|
          section_names1(c, "#{lbl}.#{levelnumber(i, lvl + 1)}", lvl + 1)
          i += 1 if !leaf_section?(c) && c["unnumbered"] != "true"
        end
        num
      end

      def section_names1(clause, num, level)
        leaf_section?(clause) and label_leaf_section(clause, level) and return
        /\.(?<leafnum>[^.]+$)/ =~ num
        clause["unnumbered"] == "true" or
          @anchors[clause["id"]] = { label: leafnum, level: level, type: "clause",
                                     elem: @labels["clause"],
                                     xref: l10n("#{@labels['clause']} #{num}") }
        i = 1
        clause.xpath(ns(NONTERMINAL)).each do |c|
          section_names1(c, "#{num}.#{levelnumber(i, level + 1)}", level + 1)
          i += 1 if !leaf_section?(c) && c["unnumbered"] != "true"
        end
      end

      def annex_anchor_names(xml)
        i = ::IsoDoc::XrefGen::Counter.new
        clause_order_annex(xml).each do |a|
          xml.xpath(ns(a[:path])).each do |c|
            annex_names(c, i.increment(c).print)
            a[:multi] or break
          end
        end
      end

      def annex_name_lbl(_clause, num)
        l10n("<strong>#{@labels['annex']} #{num}</strong>")
      end

      SUBCLAUSES =
        "./clause | ./references | ./term  | ./terms | ./definitions".freeze

      def annex_name_anchors(clause, num)
        { label: annex_name_lbl(clause, num),
          elem: @labels["annex"],
          type: "clause", value: num.to_s, level: 1,
          xref: "#{@labels['annex']} #{num}" }
      end

      def annex_names(clause, number)
        @paranumber = 0
        num = annex_levelnum(number, 0)
        hierarchical_asset_names(clause, num)
        leaf_section?(clause) and
          label_annex_leaf_section(clause, num, 1) and return
        @anchors[clause["id"]] = annex_name_anchors(clause, num)
        if @klass.single_term_clause?(clause)
          annex_names1(clause.at(ns("./references | ./terms | ./definitions")),
                       num.to_s, 1)
        else
          i = 1
          clause.xpath(ns(SUBCLAUSES)).each do |c|
            c["unnumbered"] == "true" and next
            annex_names1(c, "#{num}.#{annex_levelnum(i, 2)}", 2)
            i += 1 if !leaf_section?(c)
          end
        end
      end

      def annex_names1(clause, num, level)
        leaf_section?(clause) and
          label_annex_leaf_section(clause, num, level) and return
        /\.(?<leafnum>[^.]+$)/ =~ num
        @anchors[clause["id"]] = { label: leafnum, xref: l10n("#{@labels['annex']} #{num}"),
                                   level: level, type: "clause", elem: @labels["annex"] }
        i = 1
        clause.xpath(ns("./clause | ./references")).each do |c|
          c["unnumbered"] == "true" and next
          annex_names1(c, "#{num}.#{annex_levelnum(i, level + 1)}", level + 1)
          i += 1 if !leaf_section?(c)
        end
      end

      def clause_order_back(_docxml)
        [
          { path: "//bibliography/references | //bibliography/clause",
            multi: true },
          { path: "//indexsect", multi: true },
          { path: "//colophon/*", multi: true },
        ]
      end

      def sequential_admonition_names(clause, container: false)
        i = 0
        clause.xpath(ns(".//admonition")).noblank.each do |t|
          i += 1 unless t["unnumbered"] == "true"
          @anchors[t["id"]] =
            anchor_struct(i.to_s, container ? t : nil, @labels["admonition"],
                                            "box", t["unnumbered"])
        end
      end

      def hierarchical_admonition_names(clause, num)
        i = 0
        clause.xpath(ns(".//admonition")).noblank.each do |t|
          i += 1 unless t["unnumbered"] == "true"
          @anchors[t["id"]] =
            anchor_struct("#{num}.#{i}", nil, @labels["admonition"], "box",
                          t["unnumbered"])
        end
      end

      def sequential_asset_names(clause, container: false)
        super
        sequential_admonition_names(clause, container: container)
      end

      def hierarchical_asset_names(clause, num)
        super
        hierarchical_admonition_names(clause, num)
      end
    end
  end
end
