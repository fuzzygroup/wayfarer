require "spec_helpers"

describe Scrapespeare::Result do

  let(:result) { subject.class.new }

  it "works" do
    a = {
      foo: {
        bar: 1,
        baz: 2,
        qux: 3
      }
    }

    b = {
      foo: {
        bar: 4,
        baz: 5,
        qux: 6
      }
    }

    result << a
    result << b

    expect(result.to_h).to eq({
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
    a = {
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
    }

    b = {
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
    }

    result << a
    result << b

    expect(result.to_h).to eq({
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

  it "works" do
    a = {
      foo: {
        bar: [1, 2, 3],
        baz: { a: 4, b: 5 },
        qux: 6
      }
    }

    b = {
      foo: {
        bar: 7,
        baz: 8,
        qux: 9
      },
      qzer: 200
    }

    result << a
    result << b

    expect(result.to_h).to eq({
      foo: [
        {
          bar: [1, 2, 3],
          baz: { a: 4, b: 5 },
          qux: 6
        },
        {
          bar: 7,
          baz: 8,
          qux: 9
        }
      ],
      qzer: 200
    })
  end

end
