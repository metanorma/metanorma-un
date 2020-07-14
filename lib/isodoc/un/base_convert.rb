require "fileutils"

module IsoDoc
  module UN
    module BaseConvert
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

      def inline_header_title(out, node, title)
        out.span **{ class: "zzMoveToFollowing" } do |s|
          title&.children&.each { |c2| parse(c2, s) }
          clausedelimspace(out) if /\S/.match(title&.text)
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
