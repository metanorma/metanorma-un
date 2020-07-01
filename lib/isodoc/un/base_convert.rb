require "fileutils"

module IsoDoc
  module UN
    module BaseConvert
      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{@xrefs.anchor(annex['id'], :label)}"
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def middle_clause
        "//clause[parent::sections]"
      end

      def admonition_parse(node, out)
        name = node.at(ns("./name"))
        out.div **admonition_attrs(node) do |t|
          admonition_name_parse(node, t, name) if name
          node.children.each do |n|
            parse(n, t) unless n.name == "name"
          end
        end
      end

      def inline_header_title(out, node, c1)
        out.span **{ class: "zzMoveToFollowing" } do |s|
          if lbl = @xrefs.anchor(node['id'], :label)
            s << "#{lbl}. " unless @suppressheadingnumbers
            insert_tab(s, 1)
          end
          c1&.children&.each { |c2| parse(c2, s) }
        end
      end

      def is_plenary?(docxml)
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        return true if  %w(plenary agenda budgetary).include?(doctype)
        return true if docxml&.at(ns("//bibdata/ext/session/*"))
        false
      end
    end
  end
end
