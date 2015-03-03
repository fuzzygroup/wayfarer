require "spec_helpers"

describe Scrapespeare::Result do

  it "works" do
    result_a = Result[
      foo: {
        bar: 1,
        baz: 2,
        qux: 3
      }
    ]

    result_b = Result[
      foo: {
        bar: 4,
        baz: 5,
        qux: 6
      }
    ]

    final = result_a << result_b

    expect(final).to eq({
      foo: [
        {
          bar: 1,
          baz: 2,
          qux: 3
        },
        {
          bar: 4,
          baz: 5,
          qux: 6
        }
      ]
    })
  end

end
