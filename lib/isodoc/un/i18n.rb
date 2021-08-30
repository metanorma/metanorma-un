module IsoDoc
  module UN
    class I18n < IsoDoc::I18n
      def load_yaml1(lang, script)
        y = YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
        super.merge(y)
      end
    end
  end
end
