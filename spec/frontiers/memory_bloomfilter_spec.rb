# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Frontiers::MemoryBloomfilter do
  it_behaves_like "Frontier", MemoryBloomfilter
end
