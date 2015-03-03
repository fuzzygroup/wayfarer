require "spec_helpers"

describe Scrapespeare::Result do

  it "works" do
    result_a = Result[a: 1, b: 2]
    result_b = Result[a: 3, b: 4]

    merged = result_a.deep_merge(result_b)
    expect(merged).to eq({
      a: 3, b: 4
    })
  end

end
