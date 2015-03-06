require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Rule.new(true, "/bar") }

  it "works" do
    expect(rule).to be_allowed
  end

  it "allows" do
    uri = URI("http://google.com/bar")
    matched = (rule === uri)
    expect(matched).to be true
  end

  it "disallows" do
    uri = URI("http://google.com/foo.bar")
    matched = (rule === uri)
    expect(matched).to be false
  end

end
