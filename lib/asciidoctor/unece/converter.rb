require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"

module Asciidoctor
  module Unece

    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Standoc::Converter

      register_for "unece"

      def metadata_author(node, xml)
        xml.contributor do |c|
          c.role **{ type: "author" }
          c.organization do |a|
            a.name Metanorma::Unece::ORGANIZATION_NAME_SHORT
          end
        end
      end

      def metadata_publisher(node, xml)
        xml.contributor do |c|
          c.role **{ type: "publisher" }
          c.organization do |a|
            a.name Metanorma::Unece::ORGANIZATION_NAME_SHORT
          end
        end
      end

      def metadata_committee(node, xml)
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

      def title(node, xml)
        ["en"].each do |lang|
          xml.title **{ type: "main", language: lang, format: "text/plain" } do |t|
            t << asciidoc_sub(node.attr("title"))
          end
          node.attr("subtitle") and
            xml.title **{ type: "subtitle", language: lang, format: "text/plain" } do |t|
            t << asciidoc_sub(node.attr("subtitle"))
          end
        end
      end

      def metadata_status(node, xml)
        xml.status(**{ format: "plain" }) { |s| s << node.attr("status") }
      end

      def metadata_id(node, xml)
        dn = node.attr("docnumber")
        if docstatus = node.attr("status")
          abbr = IsoDoc::Unece::Metadata.new("en", "Latn", {}).status_abbr(docstatus)
          dn = "#{dn}(#{abbr})" unless abbr.empty?
        end
        xml.docidentifier { |i| i << dn }
        xml.docnumber { |i| i << node.attr("docnumber") }
      end

      def metadata_copyright(node, xml)
        from = node.attr("copyright-year") || Date.today.year
        xml.copyright do |c|
          c.from from
          c.owner do |owner|
            owner.organization do |o|
              o.name Metanorma::Unece::ORGANIZATION_NAME_SHORT
            end
          end
        end
      end

      def metadata_distribution(node, xml)
        xml.distribution node.attr("distribution") if node.attr("distribution")
      end

      def metadata_session(node, xml)
        xml.session do |session|
          session.number node.attr("session") if node.attr("session")
          session.date node.attr("session-date") if node.attr("session-date")
          node&.attr("item-number")&.split(/,[ ]*/)&.each { |i| session.item_number i }
          node&.attr("item-name")&.split(/,[ ]*/)&.each { |i| session.item_name i }
          node&.attr("subitem-name")&.split(/,[ ]*/)&.each { |i| session.subitem_name i }
          session.collaborator node.attr("collaborator") if node.attr("collaborator")
          session.id node.attr("agenda-id") if node.attr("agenda-id")
          session.item_footnote node.attr("item-footnote") if node.attr("item-footnote")
        end
      end

      def metadata_language(node, xml)
        languages = node&.attr("language")&.split(/,[ ]*/) || %w(ar ru en fr zh es)
        languages.each { |l| xml.language l }
        languages = node&.attr("submissionlanguage")&.split(/,[ ]*/) || []
        languages.each { |l| xml.submissionlanguage l }
      end

      def metadata(node, xml)
        super
        metadata_distribution(node, xml)
        metadata_session(node, xml)
      end

      def title_validate(root)
        nil
      end

      def makexml(node)
        result = ["<?xml version='1.0' encoding='UTF-8'?>\n<unece-standard>"]
        @draft = node.attributes.has_key?("draft")
        result << noko { |ixml| front node, ixml }
        result << noko { |ixml| middle node, ixml }
        result << "</unece-standard>"
        result = textcleanup(result)
        ret1 = cleanup(Nokogiri::XML(result))
        validate(ret1)
        ret1.root.add_namespace(nil, Metanorma::Unece::DOCUMENT_NAMESPACE)
        ret1
      end

      def doctype(node)
        d = node.attr("doctype")
        unless %w{plenary recommendation addendum communication corrigendum reissue
          agenda budgetary sec-gen-notes expert-report resolution}.include? d
          warn "#{d} is not a legal document type: reverting to 'recommendation'"
          d = "recommendation"
        end
        d
      end

      def document(node)
        init(node)
        ret1 = makexml(node)
        ret = ret1.to_xml(indent: 2)
        unless node.attr("nodoc") || !node.attr("docfile")
          filename = node.attr("docfile").gsub(/\.adoc/, ".xml").
            gsub(%r{^.*/}, "")
          File.open(filename, "w") { |f| f.write(ret) }
          html_converter(node).convert filename unless node.attr("nodoc")
          word_converter(node).convert filename unless node.attr("nodoc")
        end
        @files_to_delete.each { |f| FileUtils.rm f }
        ret
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "unece.rng"))
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

      def html_converter(node)
        IsoDoc::Unece::HtmlConvert.new(html_extract_attributes(node))
      end

      def word_converter(node)
        IsoDoc::Unece::WordConvert.new(doc_extract_attributes(node))
      end

      def sections_cleanup(xmldoc)
        super
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

      def clause_parse(attrs, xml, node)
        abstract_parse(attrs, xml, node) && return if node.attr("style") == "abstract"
        super
      end
    end
  end
end
