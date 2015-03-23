require "spec_helpers"

describe Schablone::Extraction::Evaluator do

  let(:evaluator) { Evaluator }

  describe ".evaluate" do
    context "with empty NodeSet" do
      let(:nodes) { node_set "" }

      it "returns an empty String" do
        result = evaluator.evaluate(nodes)
        expect(result).to eq ""
      end
    end

    context "with NodeSet containing 1 Node" do
      let(:nodes) { node_set %(<span class="foo" id="bar">Foobar</span>) }

      context "without target attributes" do
        it "returns the element's content" do
          result = evaluator.evaluate(nodes)
          expect(result).to eq "Foobar"
        end
      end

      context "with target attributes" do
        context "with 1 target attribute" do
          it "returns the element's attribute value" do
            result = evaluator.evaluate(nodes, :class)
            expect(result).to eq "foo"
          end
        end

        context "with > 1 target attributes" do
          it "returns a Hash of mapped attribute values" do
            result = evaluator.evaluate(nodes, :class, :id)
            expect(result).to eq({ class: "foo", id: "bar" })
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

      context "without target attributes" do
        it "returns an Array of the elements' contents" do
          result = evaluator.evaluate(nodes)
          expect(result).to eq ["Alpha", "Beta"]
        end
      end

      context "with target attributes" do
        context "with 1 target attribute" do
          it "returns the element's attribute value" do
            result = evaluator.evaluate(nodes, :id)
            expect(result).to eq ["alpha", "beta"]
          end
        end

        context "with > 1 target attributes" do
          it "returns a Hash of mapped attribute values" do
            result = evaluator.evaluate(nodes, :class, :id)
            expect(result).to eq([
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
    let(:element) do
      node_set(%(<span class="foo" id="bar">Foobar</span>)).first
    end

    it "returns the element's content" do
      result = evaluator.evaluate_content(element)
      expect(result).to eq "Foobar"
    end

    context "when config.sanitize_node_content is `true`" do
      before { Schablone.config.sanitize_node_content = true }
      after { Schablone.config.reset! }

      it "sanitizes the element's content" do
        element = node_set("<span>\n   Foobar   \n</span>").first

        result = evaluator.evaluate_content(element)
        expect(result).to eq "Foobar"
      end
    end

    context "when config.sanitize_node_content is `false`" do
      before { Schablone.config.sanitize_node_content = false }
      after { Schablone.config.reset! }

      it "does not sanitize the element's content" do
        element = node_set("<span>\n   Foobar   \n</span>").first

        evaluated = evaluator.evaluate_content(element)
        expect(evaluated).to eq "\n   Foobar   \n"
      end
    end
  end

  describe ".evaluate_attribute" do
    let(:element) do
      node_set(%(<span class="foo" id="bar">Foobar</span>)).first
    end

    it "returns the attribute's value" do
      result = evaluator.evaluate_attribute(element, :class)
      expect(result).to eq "foo"
    end
  end

  describe ".evaluate_attribute" do
    let(:element) do
      node_set(%(<span class="foo" id="bar">Foobar</span>)).first
    end

    it "returns the attribute's value" do
      result = evaluator.evaluate_attribute(element, :class)
      expect(result).to eq "foo"
    end
  end

  describe ".evaluate_reserved_attribute" do
    let(:element) do
      node_set(%(<span class="foo" id="bar">Foobar</span>)).first
    end

    context "when attribute is `:content!`" do
      it "returns the element's content" do
        result = evaluator.evaluate_attribute(element, :content!)
        expect(result).to eq "Foobar"
      end
    end

    context "when attribute is `:html!`" do
      it "returns the element's inner HTML" do
        result = evaluator.evaluate_attribute(element, :html!)
        expect(result).to eq %(<span class="foo" id="bar">Foobar</span>)
      end
    end
  end

  describe ".evaluate_attributes" do
    let(:element) do
      node_set(%(<span class="foo" id="bar">Foobar</span>)).first
    end

    it "returns a Hash of mapped evaluated attributes" do
      result = evaluator.evaluate_attributes(element, :class, :id)
      expect(result).to eq({ class: "foo", id: "bar" })
    end

    context "with mismatching attribute" do
      it "maps the attribute to an empty String" do
        result = evaluator.send(:evaluate_attributes, element, :baz)
        expect(result).to eq({ :baz => "" })
      end
    end
  end

  describe ".sanitize" do
    it "removes line-breaks" do
      input = "\nFoobar\n"
      output = evaluator.sanitize(input)

      expect(output).to eq "Foobar"
    end

    it "removes leading and trailing white space" do
      input = "      Foobar          "
      output = evaluator.sanitize(input)

      expect(output).to eq "Foobar"
    end

    it "removes both line-breaks, leading and trailing white space" do
      input = "    \n      Foobar     \n     "
      output = evaluator.sanitize(input)

      expect(output).to eq "Foobar"
    end
  end

  describe "::RESERVED_ATTRIBUTES" do
    it "contains all reserved attributes" do
      expect(evaluator::RESERVED_ATTRIBUTES).to eq([:content!, :html!])
    end
  end

end
