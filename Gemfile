Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

# Canonical line: the relaton 3 finals over the α engine line.
gem "metanorma", "~> 2.5.6.pre.alpha"
gem "metanorma-standoc", "~> 3.5.1.pre.alpha"
gem "metanorma-document", "~> 0.5.2.pre.alpha"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "isodoc", "~> 3.7.4.pre.alpha"
gem "relaton", "~> 3.0"
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "pubid", "~> 2.0"
gem "sassc-embedded", "~> 1.80"
