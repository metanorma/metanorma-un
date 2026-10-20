Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

# isodoc main carries the lazy sassc load that the released 3.7.3 lacks
gem "isodoc", github: "metanorma/isodoc", branch: "main"
