require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module UN
    module Init
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:toc, @toc)
      end

      def xref_init(lang, script, klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script)
        super
        @labels["admonition"] = "Box"
        @admonition_lbl = "Box"
        @labels["abstract"] = "Box"
        @abstract_lbl = "Summary"
      end
    end
  end
end

