# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Frontiers::MemoryTrieFrontier, redis: true do
  it_behaves_like "Frontier", MemoryTrieFrontier
end
