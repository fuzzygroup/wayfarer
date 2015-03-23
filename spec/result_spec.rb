require "spec_helpers"

describe Schablone::Result do

  let(:result) { subject.class.new }

  describe "#<<" do
    it "builds the expected Hash structure" do
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

    it "builds the expected Hash structure" do
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

    it "builds the expected Hash structure" do
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

    it "builds the expected Hash structure" do
      a = {
        foo: [
          { x: 1, y: { z: [2, 3, 4] } },
          { x: 5, y: { z: 6 } },
        ]
      }

      b = {
        foo: { x: [7, 8], y: { z: 9 } }
      }

      result << a
      result << b

      expect(result.to_h).to eq({
        foo: [
          { x: 1, y: { z: [2, 3, 4] } },
          { x: 5, y: { z: 6 } },
          { x: [7, 8], y: { z: 9 } }
        ]
      })
    end
  end

end
