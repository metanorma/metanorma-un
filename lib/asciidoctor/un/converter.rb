require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "validate"

module Asciidoctor
  module UN
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "un-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/un".freeze

      register_for "un"

      def default_publisher
        "United Nations"
      end

      def metadata_committee(node, xml)
        return unless node.attr("committee")
        xml.editorialgroup do |a|
          a.committee node.attr("committee"),
            **attr_code(type: node.attr("committee-type"))
          i = 2
          while node.attr("committee_#{i}") do
            a.committee node.attr("committee_#{i}"),
              **attr_code(type: node.attr("committee-type_#{i}"))
            i += 1
          end
        end
      end

      def asciidoc_sub(text)
        Metanorma::Utils::asciidoc_sub(text)
      end

      def title(node, xml)
        ["en"].each do |lang|
          xml.title **{ type: "main", language: lang,
                        format: "text/plain" } do |t|
            t << (asciidoc_sub(node.attr("title")) || node.title)
          end
          node.attr("subtitle") and
            xml.title **{ type: "subtitle", language: lang,
                          format: "text/plain" } do |t|
              t << asciidoc_sub(node.attr("subtitle"))
            end
        end
      end

      def metadata_id(node, xml)
        dn = node.attr("docnumber")
        if docstatus = node.attr("status")
          abbr = IsoDoc::UN::Metadata.new("en", "Latn", @i18n)
            .stage_abbr(docstatus)
          dn = "#{dn}(#{abbr})" unless abbr.empty?
        end
        xml.docidentifier { |i| i << dn }
        xml.docnumber { |i| i << node.attr("docnumber") }
      end

      def metadata_distribution(node, xml)
        xml.distribution node.attr("distribution") if node.attr("distribution")
      end

      def metadata_session(node, xml)
        xml.session do |session|
          session.number node.attr("session") if node.attr("session")
          session.date node.attr("session-date") if node.attr("session-date")
          node&.attr("item-number")&.split(/,[ ]*/)&.each do |i|
            session.item_number i
          end
          node&.attr("item-name")&.split(/,[ ]*/)&.each do |i|
            session.item_name i
          end
          node&.attr("subitem-name")&.split(/,[ ]*/)&.each do |i|
            session.subitem_name i
          end
          node.attr("collaborator") and
            session.collaborator node.attr("collaborator")
          session.id node.attr("agenda-id") if node.attr("agenda-id")
          node.attr("item-footnote") and
            session.item_footnote node.attr("item-footnote")
        end
      end

      def metadata_language(node, xml)
        languages = node&.attr("language")&.split(/,[ ]*/) ||
          %w(ar ru en fr zh es)
        languages.each { |l| xml.language l }
      end

      def metadata_submission_language(node, xml)
        languages = node&.attr("submissionlanguage")&.split(/,[ ]*/) || []
        languages.each { |l| xml.submissionlanguage l }
      end

      def metadata_ext(node, xml)
        super
        metadata_distribution(node, xml)
        metadata_session(node, xml)
        metadata_submission_language(node, xml)
      end

      def title_validate(root)
        nil
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        @no_number_subheadings =
          node.attributes.has_key?("do-not-number-subheadings")
        super
      end

      def doctype(node)
        d = super
        unless %w{plenary recommendation addendum communication corrigendum 
          reissue agenda budgetary sec-gen-notes expert-report resolution 
          plenary-attachment}.include? d
          @log.add(
            "Document Attributes", nil,
            "#{d} is not a legal document type: reverting to 'recommendation'")
          d = "recommendation"
        end
        d
      end

      def outputs(node, ret)
        File.open(@filename + ".xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert(@filename + ".xml")
        html_converter(node).convert(@filename + ".presentation.xml", 
                                     nil, false, "#{@filename}.html")
        doc_converter(node).convert(@filename + ".presentation.xml", 
                                    nil, false, "#{@filename}.doc")
        pdf_converter(node)&.convert(@filename + ".presentation.xml", 
                                     nil, false, "#{@filename}.pdf")
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "un.rng"))
      end

      def style(n, t)
        return
      end

      def html_extract_attributes(node)
        super.merge(toc: node.attributes.has_key?("toc"))
      end

      def doc_extract_attributes(node)
        super.merge(toc: node.attributes.has_key?("toc"))
      end

      def presentation_xml_converter(node)
        IsoDoc::UN::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def html_converter(node)
        IsoDoc::UN::HtmlConvert.new(html_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::UN::WordConvert.new(doc_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")
        IsoDoc::UN::PdfConvert.new(doc_extract_attributes(node))
      end

      def sections_cleanup(xmldoc)
        super
        no_number_subheadings(xmldoc) if @no_number_subheadings
        para_to_clause(xmldoc)
      end

      def no_number_subheadings(xmldoc)
        xmldoc.xpath("//sections/clause | "\
                     "//sections/definitions | //annex").each do |s|
          s.xpath(".//clause | .//definitions").each do |c|
            c["unnumbered"] = true
          end
        end
      end

      def para_to_clause(xmldoc)
        doctype = xmldoc&.at("//bibdata/ext/doctype")&.text
        %w(plenary agenda budgetary).include?(doctype) or
          para_to_clause1(xmldoc)
      end

      def para_to_clause1(xmldoc)
        xmldoc.xpath("//clause/p | //annex/p").each do |p|
          cl = Nokogiri::XML::Node.new("clause", xmldoc)
          cl["id"] = p["id"]
          cl["inline-header"]="true" 
          p["id"] = "_" + UUIDTools::UUID.random_create
          p.replace(cl)
          p.parent = cl
          while n = cl.next_element and !%w(p clause).include? n.name
            n.parent = cl
          end
        end
      end

      def admonition_attrs(node)
        attr_code(super.merge("unnumbered": node.option?("unnumbered"),
                              "subsequence": node.attr("subsequence")))
      end

      def sectiontype_streamline(ret)
        case ret
        when "foreword" then "donotrecognise-foreword"
        when "introduction" then "donotrecognise-foreword"
        else
          super
        end
      end
    end
  end
end
