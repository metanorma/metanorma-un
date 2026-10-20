module Metanorma
  module UN
    class Cleanup < Standoc::Cleanup
      def boilerplate_file(_xmldoc)
        File.join(@libdir, "boilerplate.adoc")
      end
    end
  end
end
