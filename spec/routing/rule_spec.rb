require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Rule.new(true, "") }

  it "works" do
    expect(rule).to be_allowed
  end

end
