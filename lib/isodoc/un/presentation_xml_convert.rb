require_relative "init"
require "isodoc"

module IsoDoc
  module UN
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        super
        @toc = options[:toc]
      end

      include Init
    end
  end
end

