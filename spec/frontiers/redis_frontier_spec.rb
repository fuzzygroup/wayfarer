# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Frontiers::RedisFrontier, redis: true do
  it_behaves_like "Frontier", RedisFrontier
end
