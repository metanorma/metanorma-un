require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        super
        @toc = options[:toc]
      end

      def note1(elem)
        return if elem.parent.name == "bibitem"
        return if elem["type"] == "title-footnote"

        # n = @xrefs.get[f["id"]]
        lbl = case elem["type"]
              when "source" then "Source"
              when "abbreviation" then "Abbreviations"
              else
                @i18n.note
              end
        prefix_name(elem, "", lbl, "name")
      end

      def admonition1(elem)
        return if elem["notag"] == "true"

        n = @xrefs.anchor(elem["id"], :label) or return
        lbl = l10n("#{@i18n.admonition} #{n}")
        prefix_name(elem, "&#xa0;&#x2014; ", lbl, "name")
      end

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(elem, "<br/>", lbl, "title")
      end

      include Init
    end
  end
end
