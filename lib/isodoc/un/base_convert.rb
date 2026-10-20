require "fileutils"

module IsoDoc
  module UN
    module BaseConvert
      def middle_clause(_docxml)
        "//clause[parent::sections]"
      end

      def norm_ref_xpath
        "//null"
      end

      def bibliography_xpath
        "//bibliography/clause[.//references] | " \
          "//bibliography/references"
      end

      def inline_header_title(out, _node, title)
        out.span class: "zzMoveToFollowing inline-header" do |s|
          title&.children&.each { |c2| parse(c2, s) }
          clausedelimspace(_node, out) if /\S/.match?(title&.text)
        end
      end

      def plenary?(docxml)
        return true if %w(plenary agenda budgetary).include?(@doctype)
        return true if docxml&.at(ns("//bibdata/ext/session/*"))

        false
      end

      def norm_ref(node, out)
        bibliography(node, out)
      end

      def convert_i18n_init1(docxml)
        super
        docxml.xpath(ns("//bibdata/language")).size > 1 and @lang = "en"
      end
    end
  end
end
