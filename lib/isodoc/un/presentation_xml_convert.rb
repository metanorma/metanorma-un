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
        n = @xrefs.get[f["id"]]
        lbl = case f["type"]
              when "source" then "Source"
              when "abbreviation" then "Abbreviations"
              else
                @note_lbl
              end
        prefix_name(f, "", lbl, "name")
      end

      include Init
    end
  end
end

