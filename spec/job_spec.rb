require "spec_helpers"

describe Wayfarer::Job do
  let(:adapter) { NetHTTPAdapter.instance }
  subject(:job) { Job.new }

  describe "::config" do
    it "allows manipulating the configuration" do
      job.class.config do |c|
        c.http_adapter = :selenium
      end

      expect(job.config.http_adapter).to be :selenium
    end

    it "does not manipulate the global configuration" do
      job.class.config do |c|
        c.http_adapter = :selenium
      end

      expect(Wayfarer.config.http_adapter).to be :net_http
    end
  end

  describe "::draw" do
    it "draws routes" do
      job.class.instance_eval do
        class_eval do
          draw host: "example.com"
          def example; end
        end
      end

      expect(job.class.router.routes.any? { |(method, _)| method == :example })
    end
  end

  describe "#invoke" do
    context "with matching route" do
      it "returns a Stage" do
        job.class.instance_eval do
          class_eval do
            draw path: "/hello_world"
            def foo
              stage("http://example.com")
            end
          end
        end

        uri = test_app("/hello_world")
        returned = job.invoke(uri, adapter)
        expect(returned).to be_a Job::Stage
        expect(returned.uris).to eq ["http://example.com"]
      end
    end

    context "with mismatching routes" do
      it "returns a Mismatch" do
        job.class.instance_eval do
          class_eval do
            route.draw :foobar, path: "/foobar"
          end
        end

        uri = test_app("/hello_worlssd")
        returned = job.invoke(uri, adapter)
        expect(returned).to be_a Job::Mismatch
        expect(returned.uri).to be uri
      end
    end

    context "with failing instance method" do
      it "returns an Error" do
        job.class.class_eval do
          draw path: "/hello_world"
          def foo
            fail
          end
        end

        uri = test_app("/hello_world")
        returned = job.invoke(uri, adapter)
        expect(returned).to be_a Job::Error
        expect(returned.exception).to be_a RuntimeError
      end
    end
  end

  describe "#halt" do
    it "enforces a Halt to be returned" do
      job.class.class_eval do
        draw path: "/hello_world"
        def foo
          stage("http://example.com")
          halt
        end
      end

      uri = test_app("/hello_world")
      expect(job.invoke(uri, adapter)).to be_a Job::Halt
    end
  end

  describe "#config" do
    it "allows manipulating the configuration" do
      job.config do |c|
        c.http_adapter = :selenium
      end

      expect(job.config.http_adapter).to be :selenium
    end

    it "does not manipulate the global configuration" do
      job.config do |c|
        c.http_adapter = :selenium
      end

      expect(Wayfarer.config.http_adapter).to be :net_http
    end
  end

  describe "#stage" do
    it "stages URIs" do
      expect do
        job.send(:stage, "http://google.com")
      end.to change { job.staged_uris.count }.by(1)
    end
  end
end
