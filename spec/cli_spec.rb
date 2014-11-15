require "spec_helpers"

module Scrapespeare
  describe CLI do

    before do
      Dir.chdir(Dir.mktmpdir())
    end

    describe "#scraper_from_file" do
      before do
        %x(echo "set :foobar, 42" > foobar)
      end

      it "evalutes the file content in the Scraper's instance context" do
        scraper = subject.send(:scraper_from_file, "foobar")
        expect(scraper.options[:foobar]).to be 42
      end
    end

    describe "#read_file" do
      before do
        %x(echo "Hello!" > foobar)
      end

      it "returns the content of a file in $PWD" do
        file_content = subject.send(:read_file, "foobar")
        expect(file_content).to eq "Hello!\n"
      end
    end

  end
end
