require "spec_helpers"

describe Schablone do
  describe "::VERSION" do
    it("is present") { expect(defined? Schablone::VERSION).not_to be nil }
  end
end
