require "spec_helpers"

describe Wayfarer::Frontiers::MemoryFrontier do
  it_behaves_like "Frontier", MemoryFrontier
end