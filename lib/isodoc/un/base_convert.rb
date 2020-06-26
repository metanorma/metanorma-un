require_relative "metadata"
require_relative "xref"
require "fileutils"

module IsoDoc
  module UN
    module BaseConvert
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:toc, @toc)
      end

def xref_init(lang, script, klass, labels, options)
        @xrefs = Xref.new(lang, script, klass, labels, options)
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{@xrefs.anchor(annex['id'], :label)}"
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

      def middle_clause
        "//clause[parent::sections]"
      end

      def admonition_name_parse(node, div, name)
        div.p **{ class: "AdmonitionTitle", style: "text-align:center;" } do |p|
          lbl = @xrefs.anchor(node['id'], :label)
          lbl.nil? or p << l10n("#{@admonition_lbl} #{lbl}")
          name and !lbl.nil? and p << "&nbsp;&mdash; "
          name and name.children.each { |n| parse(n, div) }
        end
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

       def note_label(node)
         n = @xrefs.get[node["id"]]
      lbl = case node["type"]
            when "source" then "Source"
            when "abbreviation" then "Abbreviations"
            else
              @note_lbl
            end
      return "#{lbl}:" # if n.nil? || n[:label].nil? || n[:label].empty?
      #l10n("#{lbl} #{n[:label]}:")
    end
    end
  end
end
