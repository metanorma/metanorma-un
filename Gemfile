Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

# Canonical line: the relaton 3 finals over the α engine line.
gem "metanorma", "~> 2.5.14"
gem "metanorma-standoc", "~> 3.5.7"
gem "metanorma-document", "~> 0.5.3"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "isodoc", "~> 3.7.9"
gem "relaton", "~> 3.0"
gem "pubid", "~> 2.0"
gem "sassc-embedded", "~> 1.80"
