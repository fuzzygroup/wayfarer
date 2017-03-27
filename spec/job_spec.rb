# frozen_string_literal: true
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

  describe "#halt" do
    it "sets the halting flag" do
      expect {
        job.send(:halt)
      }.to change { job.halts? }.to(true)
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
