# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma/un/document"
require_relative "support/roundtrip_helper"
require_relative "support/shared_roundtrip_examples"

RSpec.describe "UN document XML round-trip" do
  it_behaves_like "xml round-trip", flavor_dir: "un",
                                    doc_class: Metanorma::Un::Document::Root
end
