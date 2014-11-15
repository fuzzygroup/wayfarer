require "spec_helpers"

module Scrapespeare
  describe Evaluator do

    describe ".evaluate" do

      context "with empty NodeSet" do
        let(:nodes) { node_set "" }

        it "returns an empty String" do
          evaluated = subject.evaluate(nodes)
          expect(evaluated).to eq ""
        end
      end

      context "with NodeSet containing 1 Node" do
        let(:nodes) do
          node_set("<em class='greeting' id='hello'>Hello!</em>")
        end

        describe "Default content evaluation" do
          it "returns the element's content" do
            evaluated = subject.evaluate(nodes)
            expect(evaluated).to eq "Hello!"
          end
        end

        describe "Custom attribute evaluation" do
          context "with 1 attribute" do
            it "returns the element's attribute value" do
              evaluated = subject.evaluate(nodes, "class")
              expect(evaluated).to eq "greeting"
            end
          end

          context "with > 1 attributes" do
            it "returns a Hash of mapped attribute values" do
              evaluated = subject.evaluate(nodes, "class", "id")
              expect(evaluated).to eq({
                :class => "greeting",
                :id => "hello"
              })
            end
          end
        end

      end

      context "with NodeSet containing > 1 Node" do
        let(:nodes) do
          node_set <<-html
            <em class='greeting' id='hello'>Hello!</em>
            <em class='greeting' id='good-bye'>Goodbye!</em>
          html
        end

        describe "Default content evaluation" do
          it "returns an Array of the elements' contents" do
            evaluated = subject.evaluate(nodes)
            expect(evaluated).to eq ["Hello!", "Goodbye!"]
          end
        end

        describe "Custom attribute evaluation" do
          context "with 1 attribute" do
            it "returns the element's attribute value" do
              evaluated = subject.evaluate(nodes, "id")
              expect(evaluated).to eq ["hello", "good-bye"]
            end
          end

          context "with > 1 attributes" do
            it "returns a Hash of mapped attribute values" do
              evaluated = subject.evaluate(nodes, "class", "id")
              expect(evaluated).to eq([
                {
                  :class => "greeting",
                  :id => "hello"
                },
                {
                  :class => "greeting",
                  :id => "good-bye"
                }
              ])
            end
          end
        end
      end

    end

    describe ".evaluate_content" do
      let(:element) do
        node_set("<span>Hello world!</span>").first
      end

      it "returns the element's content" do
        evaluated = subject.evaluate_content(element)
        expect(evaluated).to eq "Hello world!"
      end

      it "sanitizes the element's content" do
        element = node_set("<span>\n   Hello world!   \n </span>").first

        evaluated = subject.evaluate_content(element)
        expect(evaluated).to eq "Hello world!"
      end
    end

    describe ".evaluate_attribute" do
      let(:element) do
        node_set("<em class='greeting'>Hello!</em>").first
      end

      it "returns the attribute's value" do
        evaluated = subject.send(:evaluate_attribute, element, :class)
        expect(evaluated).to eq "greeting"
      end
    end

    describe ".evaluate_attributes" do
      let(:element) do
        node_set("<em class='greeting' id='hello'>Hello!</em>").first
      end

      it "returns a Hash of mapped evaluated attributes" do
        evaluated = subject.evaluate_attributes(element, "class", "id")
        expect(evaluated).to eq({
          :class => "greeting",
          :id => "hello"
        })
      end

      context "with mismatching attribute" do
        it "returns a an empty value for the mismatching attribute" do
          evaluated = subject.send(:evaluate_attributes, element, "foo")
          expect(evaluated).to eq({ :foo => "" })
        end
      end
    end

    describe ".sanitize" do
      it "removes line-breaks" do
        input = "\nHello world!\n"
        output = subject.sanitize(input)

        expect(output).to eq "Hello world!"
      end

      it "removes leading and trailing white space" do
        input = "      Hello world!          "
        output = subject.sanitize(input)

        expect(output).to eq "Hello world!"
      end

      it "removes both line-breaks and leading and trailing white space" do
        input = "\n      Hello world!     \n     "
        output = subject.sanitize(input)

        expect(output).to eq "Hello world!"
      end
    end

  end
end
