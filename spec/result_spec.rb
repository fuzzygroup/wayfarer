require "spec_helpers"

describe Scrapespeare::Result do

  it "works" do
    result_a = Result[a: 1, b: 2]
    result_b = Result[a: 3, b: 4]

    merged = result_a << result_b
    expect(merged).to eq({ a: [1, 3], b: [2, 4] })
  end

end
