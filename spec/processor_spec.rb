require "spec_helpers"

describe Schablone::Processor do
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }

  describe "#run" do
    it "works" do
      entry_uri = URI("http://localhost:9876/graph/index.html")

      klass = Class.new(Task) do
        draw host: "localhost"
        def foobar
          page.links("a")
        end
      end

      Celluloid::Actor[:navigator].stage(*entry_uri)
      processor.run(klass)

      expect(klass.uris).to eq %w(
        http://localhost:9876/graph/index.html
        http://localhost:9876/graph/details/a.html
        http://localhost:9876/graph/details/b.html
        http://localhost:9876/status_code/400
        http://localhost:9876/status_code/403
        http://localhost:9876/status_code/403
        http://bro.ken
        http://localhost:9876/redirect_loop
      ).map { |uri| URI(uri) }

      expect(klass.yetis_seen).to be 8
    end
  end
end
