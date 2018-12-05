require "isodoc"
require "twitter_cldr"
require "iso-639"

module IsoDoc
  module Unece

    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, labels)
        super
        set(:status, "XXX")
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en']"))&.text
        set(:doctitle, main)
      end

      def subtitle(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/subtitle[@language='en']"))&.text
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
        tc = isoxml.at(ns("//bibdata/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        set(:session_number, isoxml&.at(ns("//bibdata/session/number"))&.text&.to_i&.
            localize&.to_rbnf_s("SpelloutRules", "spellout-ordinal")&.capitalize)
        set(:session_date, isoxml&.at(ns("//bibdata/session/date"))&.text)
        set(:session_agendaitem, isoxml&.at(ns("//bibdata/session/agenda_item"))&.text)
        set(:session_collaborator, isoxml&.at(ns("//bibdata/session/collaborator"))&.text)
        set(:session_id, isoxml&.at(ns("//bibdata/session/id"))&.text)
        set(:distribution, isoxml&.at(ns("//bibdata/distribution"))&.text)
        lgs = extract_languages(isoxml.xpath(ns("//bibdata/language")))
        lgs = [] if lgs.sort == %w(English French Arabic Chinese German Spanish).sort
        slgs = extract_languages(isoxml.xpath(ns("//bibdata/submissionlanguage")))
        lgs = [] if slgs.size == 1
        set(:language, lgs) unless lgs.empty?
        set(:submissionlanguage, slgs) unless slgs.empty?
      end

      def docid(isoxml, _out)
        dn = isoxml.at(ns("//bibdata/docidentifier"))&.text
        set(:docnumber, dn)
        type = isoxml&.at(ns("//bibdata/@type"))&.value
        set(:formatted_docnumber, type == "recommendation" ? "UN/CEFACT Recommendation #{dn}" : dn)
      end

      def status_print(status)
        status.split(/-/).map{ |w| w.capitalize }.join(" ")
      end

      def status_abbr(status)
        case status
        when "working-draft" then "wd"
        when "committee-draft" then "cd"
        when "draft-standard" then "d"
        else
          ""
        end
      end

      def unpublished(status)
        %w(published withdrawn).include? status.downcase
      end

      def version(isoxml, _out)
        super
        revdate = get[:revdate]
        set(:revdate_monthyear, monthyr(revdate))
      end

      MONTHS = {
        "01": "January",
        "02": "February",
        "03": "March",
        "04": "April",
        "05": "May",
        "06": "June",
        "07": "July",
        "08": "August",
        "09": "September",
        "10": "October",
        "11": "November",
        "12": "December",
      }.freeze

      def monthyr(isodate)
        m = /(?<yr>\d\d\d\d)-(?<mo>\d\d)/.match isodate
        return isodate unless m && m[:yr] && m[:mo]
        return "#{MONTHS[m[:mo].to_sym]} #{m[:yr]}"
      end

    end
  end
end
