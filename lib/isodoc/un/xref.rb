require "roman-numerals"

module IsoDoc
  module UN
    class Xref < IsoDoc::Xref
      def initial_anchor_names(doc)
        if @parse_settings.empty? || @parse_settings[:clauses]
          preface_names(doc.at(ns("//preface/abstract")))
          preface_names(doc.at(ns("//foreword")))
          preface_names(doc.at(ns("//introduction")))
          doc.xpath(ns("//preface/clause")).each do |c|
            preface_names(c)
          end
          preface_names(doc.at(ns("//acknowledgements")))
          clause_names(doc, 0)
        end
        if @parse_settings.empty?
          sequential_asset_names(
            doc.xpath(ns("//preface/abstract | //foreword | //introduction | "\
                         "//preface/clause | //acknowledgements")),
          )
          middle_section_asset_names(doc)
          termnote_anchor_names(doc)
          termexample_anchor_names(doc)
        end
      end

      def clause_names(docxml, _sect_num)
        q = "//clause[parent::sections]"
        @paranumber = 0
        i = 0
        docxml.xpath(ns(q)).each do |c|
          section_names(c, i, 1)
          i += 1
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
        return num if clause.nil?

        leaf_section?(clause) and label_leaf_section(clause, lvl) and return
        num = num + 1
        lbl = levelnumber(num, 1)
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

      def annex_names(clause, num)
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
            next if c["unnumbered"] == "true"

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
          next if c["unnumbered"] == "true"

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
          next if t["id"].nil? || t["id"].empty?

          i += 1 unless t["unnumbered"] == "true"
          @anchors[t["id"]] = anchor_struct(i.to_s, nil, @labels["admonition"],
                                            "box", t["unnumbered"])
        end
      end

      def hierarchical_admonition_names(clause, num)
        i = 0
        clause.xpath(ns(".//admonition")).each do |t|
          next if t["id"].nil? || t["id"].empty?

          i += 1 unless t["unnumbered"] == "true"
          @anchors[t["id"]] =
            anchor_struct("#{num}.#{i}", nil, @labels["admonition"], "box",
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
    end
  end
end
