Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

# Canonical line: the relaton 3.x prerelease monogem over the gem mains.
# isodoc main also carries the lazy sassc load that released 3.7.3 lacks.
gem "metanorma", github: "metanorma/metanorma", branch: "main"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "relaton", "~> 3.0.0.pre.alpha"
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "pubid", github: "pubid/pubid", branch: "main"
gem "sassc-embedded", "~> 1.80"
