require "spec_helpers"

describe Wayfarer::Frontiers::RedisFrontier do
  it_behaves_like "Frontier", RedisFrontier
end
