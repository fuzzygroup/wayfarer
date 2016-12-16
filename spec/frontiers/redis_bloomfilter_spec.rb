# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Frontiers::RedisBloomfilter, redis: true do
  it_behaves_like "Frontier", RedisBloomfilter
end
