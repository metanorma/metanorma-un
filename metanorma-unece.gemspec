lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "metanorma/un/version"

Gem::Specification.new do |spec|
  spec.name          = "metanorma-un"
  spec.version       = Metanorma::UN::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "Metanorma for UN."
  spec.description   = <<~DESCRIPTION
    Metanorma for UN documents.

    Formerly known as metanorma-unece
  DESCRIPTION

  spec.homepage      = "https://github.com/metanorma/metanorma-un"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "iso-639"
  spec.add_dependency "roman-numerals"
  spec.add_dependency "twitter_cldr"

  spec.add_dependency "metanorma-standoc", "~> 2.1.0"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "equivalent-xml", "~> 0.6"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rubocop", "~> 1.5.2"
  spec.add_development_dependency "sassc", "2.4.0"
  spec.add_development_dependency "simplecov", "~> 0.15"
  spec.add_development_dependency "timecop", "~> 0.9"
end
