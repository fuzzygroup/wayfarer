require "spec_helpers"

describe Scrapespeare::Extractor do

  let(:html) do
    <<-html
      <h1>Employees</h1>
      <a href="/signup" class="sign-up">Sign up today!</a>
      <ul class="employees">
        <li class="employee" id="albert">
          <span class="name">Albert</span>
          <span class="age">18</span>
        </li>
        <li class="employee" id="bertolt">
          <span class="name">Bertolt</span>
          <span class="age">20</span>
        </li>
      </ul>
    html
  end

  let(:document) { Nokogiri::HTML(html) }

  describe "#initialize" do
    let(:extractor) { Scrapespeare::Extractor.new(:heading, "h1") }

    it "sets @identifier" do
      expect(extractor.identifier).to be :heading
    end

    it "sets @selector" do
      expect(extractor.selector).to eq "h1"
    end

    it "sets arbitrary @options" do
      extractor = Scrapespeare::Extractor.new(
        :heading, "h1", foo: 42, bar: "Hello world!"
      )
      expect(extractor.options[:foo]).to be 42
      expect(extractor.options[:bar]).to eq "Hello world!"
    end

    it "sets @nested_extractors to an empty list" do
      expect(extractor.nested_extractors).to be_empty
    end

    it "evaluates the given block in its instance context" do
      context = nil

      extractor = Scrapespeare::Extractor.new(:heading, "h1") do
        context = self
      end

      expect(context).to be extractor
    end
  end

  describe "#add_nested_extractor" do
    let(:extractor) { Scrapespeare::Extractor.new(:employees, ".employee") }

    it "adds an Extractor to @nested_extractors" do
      expect {
        extractor.add_nested_extractor(:name, ".name")
      }.to change { extractor.nested_extractors.count }.by(1)
    end

    it "initializes the added nested Extractor correctly" do
      extractor.add_nested_extractor(:name, ".name")
      nested_extractor = extractor.nested_extractors.first

      expect(nested_extractor.identifier).to be :name
      expect(nested_extractor.selector).to eq ".name"
    end
  end

  describe "#extract" do
    let(:extractor) { Scrapespeare::Extractor.new(:employees, ".employee") }

    context "with 1 extractor and 1 nested_extractor" do
      before do
        extractor.add_nested_extractor(:name, ".name")
      end

      it "returns the expected data structure" do
        result = extractor.extract(document)
        expect(result).to eq({
          :employees => [
            { :name => "Albert" },
            { :name => "Bertolt" },
          ]
        })
      end
    end

    context "with 1 extractor and 2 nested_extractors" do
      before do
        extractor.add_nested_extractor(:name, ".name")
        extractor.add_nested_extractor(:age, ".age")
      end

      it "returns the expected data structure" do
        result = extractor.extract(document)
        expect(result).to eq({
          :employees => [
            { :name => "Albert", :age => "18" },
            { :name => "Bertolt", :age => "20" },
          ]
        })
      end
    end

    context "with 1 extractor and deep-nested nested_extractors" do
      let(:extractor) do
        extractor = Scrapespeare::Extractor.new(:employees, ".employees")
      end

      before do
        extractor.add_nested_extractor(:albert, "#albert")

        nested_extractor = extractor.nested_extractors.first
        nested_extractor.add_nested_extractor(:name, ".name")
        nested_extractor.add_nested_extractor(:age, ".age")
      end

      it "returns the expected data structure" do
        result = extractor.extract(document)
        expect(result).to eq({
          :employees => [
            :albert => [
              { name: "Albert", age: "18" }
            ]
          ]
        })
      end
    end
  end

  describe "#query" do
    context "with matching @selector" do
      let(:extractor) { Scrapespeare::Extractor.new(:heading, "h1") }

      it "returns a populated NodeSet" do
        nodes = extractor.send(:query, document)
        expect(nodes).not_to be_empty
      end

      it "returns a list of the correct #count" do
        nodes = extractor.send(:query, document)
        expect(nodes.count).to be 1
      end
    end

    context "with mismatching @selector" do
      let(:extractor) { Scrapespeare::Extractor.new(:mismatching, "#mismatching") }

      it "returns an empty list" do
        nodes = extractor.send(:query, document)
        expect(nodes).to be_empty
      end
    end
  end

  describe "#method_missing" do
    let(:extractor) { Scrapespeare::Extractor.new(:employees, ".employee") }

    it "adds an Extractor to @nested_extractors" do
      expect {
        extractor.send(:name, ".name")
      }.to change { extractor.nested_extractors.count }.by(1)
    end
  end

end
