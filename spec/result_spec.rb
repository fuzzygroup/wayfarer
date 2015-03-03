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

  it "works" do
    result_a = Result[
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
        },
      ]
    ]

    result_b = Result[
      foo: [
        {
          bar: 7,
          baz: 8,
          qux: 9
        },
        {
          bar: 10,
          baz: 11,
          qux: 12
        },
      ]
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
        },
        {
          bar: 7,
          baz: 8,
          qux: 9
        },
        {
          bar: 10,
          baz: 11,
          qux: 12
        }
      ]
    })
  end

end
