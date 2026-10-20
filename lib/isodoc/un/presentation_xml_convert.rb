require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        super
        @toc = options[:toc]
      end

      def middle_title(docxml); end

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
        prefix_name(elem, {}, lbl, "name")
      end

      def admonition1(elem)
        return if elem["notag"] == "true"

        n = @xrefs.anchor(elem["id"], :label)
        lbl = n && l10n("#{@i18n.box} #{n}")
        prefix_name(elem, { caption: i18n_delim("admonition", block_delim) },
                    lbl, "name")
      end

      def toc_title(docxml)
        @toc or return
        super
      end

      def move_norm_ref_to_sections(docxml); end

      include Init
    end
  end
end
