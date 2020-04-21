require "metanorma/input"

module Metanorma
  module UN
    module Input
      class Asciidoc < ::Metanorma::Input::Asciidoc
        def extract_options(file)
          head = file.sub(/\n\n.*$/m, "\n")
          /\n(?<toc>:toc:)/ =~ head
          new_options = {
            toc: defined?(toc)
          }.reject { |_, val| val.nil? }
          super.merge(new_options)
        end
      end
    end
  end
end
