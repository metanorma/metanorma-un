require "isodoc"
require "twitter_cldr"
require "iso-639"

module IsoDoc
  module UN

    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, labels)
        super
        here = File.dirname(__FILE__)
        set(:logo, File.expand_path(File.join(here, "html", "logo.jpg")))
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en' and @type='main']"))&.text
        set(:doctitle, main)
      end

      def subtitle(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en' and @type='subtitle']"))&.text
        set(:docsubtitle, main)
      end

      def extract_languages(nodeset)
        lgs = []
        nodeset.each do |l|
          l && ISO_639&.find(l.text)&.english_name &&
            lgs << ISO_639.find(l.text).english_name 
        end
        lgs.map { |l| l == "Spanish; Castilian" ? "Spanish" : l }
      end

      def author(isoxml, _out)
        tc = isoxml.at(ns("//bibdata/ext/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        set(:distribution, isoxml&.at(ns("//bibdata/ext/distribution"))&.text)
        lgs = extract_languages(isoxml.xpath(ns("//bibdata/language")))
        lgs = [] if lgs.sort == %w(English French Arabic Chinese Russian Spanish).sort
        slgs = extract_languages(isoxml.xpath(ns("//bibdata/ext/submissionlanguage")))
        lgs = [] if slgs.size == 1
        set(:doclanguage, lgs) unless lgs.empty?
        set(:submissionlanguage, slgs) unless slgs.empty?
        session(isoxml, _out)
        super
      end

      def multival(isoxml, xpath)
        items = []
        isoxml.xpath(ns(xpath)).each { |i| items << i.text }
        items
      end

      def session(isoxml, _out)
        set(:session_number, isoxml&.at(ns("//bibdata/ext/session/number"))&.text&.to_i&.
            localize&.to_rbnf_s("SpelloutRules", "spellout-ordinal")&.capitalize)
        set(:session_date, isoxml&.at(ns("//bibdata/ext/session/date"))&.text)
        set(:session_collaborator, isoxml&.at(ns("//bibdata/ext/session/collaborator"))&.text)
        sid = isoxml&.at(ns("//bibdata/ext/session/id"))&.text
        set(:session_id, sid)
        set(:session_id_head, sid&.sub(%r{/.*$}, ""))
        set(:session_id_tail, sid&.sub(%r{^[^/]+}, ""))
        set(:item_footnote, isoxml&.at(ns("//bibdata/ext/session/item-footnote"))&.text)
        set(:session_itemnumber, multival(isoxml, "//bibdata/ext/session/item-number"))
        set(:session_itemname, multival(isoxml, "//bibdata/ext/session/item-name"))
        set(:session_subitemname, multival(isoxml, "//bibdata/ext/session/subitem-name"))
      end

      def docid(isoxml, _out)
        dn = isoxml.at(ns("//bibdata/docidentifier"))&.text
        set(:docnumber, dn)
        type = isoxml&.at(ns("//bibdata/ext/doctype"))&.text
        set(:formatted_docnumber, type == "recommendation" ? "UN/CEFACT Recommendation #{dn}" : dn)
      end

      def stage_abbr(status)
        case status
        when "working-draft" then "wd"
        when "committee-draft" then "cd"
        when "draft-standard" then "d"
        else
          ""
        end
      end

      def unpublished(status)
        !%w(published withdrawn).include? status.downcase
      end
    end
  end
end
