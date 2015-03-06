require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Rule.new(true, "/{foo}") }

  it "works" do
    expect(rule).to be_allowed
  end

  it "works" do
    uri = URI("http://google.com/bar")
    expect(rule === uri)
  end

end
