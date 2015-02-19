require "spec_helpers"

module Scrapespeare
  describe Evaluator do

    let(:evaluator) { Evaluator }

    describe ".evaluate" do
      context "with empty NodeSet" do
        let(:nodes) { node_set "" }

        it "returns an empty String" do
          evaluated = evaluator.evaluate(nodes)
          expect(evaluated).to eq ""
        end
      end

      context "with NodeSet containing 1 Node" do
        let(:nodes) { node_set %(<span class="foo" id="bar">Foobar</span>) }

        describe "Default content evaluation" do
          it "returns the element's content" do
            evaluated = evaluator.evaluate(nodes)
            expect(evaluated).to eq "Foobar"
          end
        end

        describe "Attribute evaluation" do
          context "with 1 attribute" do
            it "returns the element's attribute value" do
              evaluated = evaluator.evaluate(nodes, "class")
              expect(evaluated).to eq "foo"
            end
          end

          context "with > 1 attributes" do
            it "returns a Hash of mapped attribute values" do
              evaluated = evaluator.evaluate(nodes, "class", "id")
              expect(evaluated).to eq({ class: "foo", id: "bar" })
            end
          end
        end

      end

      context "with NodeSet containing > 1 Nodes" do
        let(:nodes) do
          node_set <<-html
            <span class="foo" id="alpha">Alpha</span>
            <span class="bar" id="beta">Beta</span>
          html
        end

        describe "Default content evaluation" do
          it "returns an Array of the elements' contents" do
            evaluated = evaluator.evaluate(nodes)
            expect(evaluated).to eq ["Alpha", "Beta"]
          end
        end

        describe "Custom attribute evaluation" do
          context "with 1 attribute" do
            it "returns the element's attribute value" do
              evaluated = evaluator.evaluate(nodes, "id")
              expect(evaluated).to eq ["alpha", "beta"]
            end
          end

          context "with > 1 attributes" do
            it "returns a Hash of mapped attribute values" do
              evaluated = evaluator.evaluate(nodes, "class", "id")
              expect(evaluated).to eq([
                {
                  class: "foo",
                  id: "alpha"
                },
                {
                  class: "bar",
                  id: "beta"
                }
              ])
            end
          end
        end
      end

    end

    describe ".evaluate_content" do
      let(:element) { node_set("<span>Hello world!</span>").first }

      it "returns the element's content" do
        evaluated = evaluator.evaluate_content(element)
        expect(evaluated).to eq "Hello world!"
      end

      it "sanitizes the element's content" do
        element = node_set("<span>\n   Hello world!   \n </span>").first

        evaluated = evaluator.evaluate_content(element)
        expect(evaluated).to eq "Hello world!"
      end
    end

    describe ".evaluate_attribute" do
      let(:element) do
        node_set("<em class='greeting'>Hello!</em>").first
      end

      it "returns the attribute's value" do
        evaluated = evaluator.send(:evaluate_attribute, element, :class)
        expect(evaluated).to eq "greeting"
      end
    end

    describe ".evaluate_attributes" do
      let(:element) do
        node_set("<em class='greeting' id='hello'>Hello!</em>").first
      end

      it "returns a Hash of mapped evaluated attributes" do
        evaluated = evaluator.evaluate_attributes(element, "class", "id")
        expect(evaluated).to eq({
          :class => "greeting",
          :id => "hello"
        })
      end

      context "with mismatching attribute" do
        it "returns a an empty value for the mismatching attribute" do
          evaluated = evaluator.send(:evaluate_attributes, element, "foo")
          expect(evaluated).to eq({ :foo => "" })
        end
      end
    end

    describe ".sanitize" do
      it "removes line-breaks" do
        input = "\nHello world!\n"
        output = evaluator.sanitize(input)

        expect(output).to eq "Hello world!"
      end

      it "removes leading and trailing white space" do
        input = "      Hello world!          "
        output = evaluator.sanitize(input)

        expect(output).to eq "Hello world!"
      end

      it "removes both line-breaks, leading and trailing white space" do
        input = "\n      Hello world!     \n     "
        output = evaluator.sanitize(input)

        expect(output).to eq "Hello world!"
      end
    end

  end
end
