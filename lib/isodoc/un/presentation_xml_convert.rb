require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        super
        @toc = options[:toc]
      end

      def note1(f)
        return if f.parent.name == "bibitem"
        return if f["type"] == "title-footnote"
        n = @xrefs.get[f["id"]]
        lbl = case f["type"]
              when "source" then "Source"
              when "abbreviation" then "Abbreviations"
              else
                @i18n.note
              end
        prefix_name(f, "", lbl, "name")
      end

      def conversions(docxml)
        super
        admonition docxml
      end

      def admonition(docxml)
        docxml.xpath(ns("//admonition")).each do |f|
          admonition1(f)
        end
      end

      def admonition1(f)
        n = @xrefs.anchor(f['id'], :label) or return
        lbl = l10n("#{@i18n.admonition} #{n}")
        prefix_name(f, "&nbsp;&mdash; ", lbl, "name")
      end

      def annex1(f)
        lbl = @xrefs.anchor(f['id'], :label)
        if t = f.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(f, "<br/>", lbl, "title")
      end

      include Init
    end
  end
end

