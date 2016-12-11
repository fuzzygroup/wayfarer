require "securerandom"

module Wayfarer
  # Entry-point for initiating a new crawl
  class Crawler
    # Stages URIs for the first cycle and runs a {Processor}
    # @param [Job] klass the job to run.
    # @param [*Array<URI>, *Array<String>] *uris the URIs to stage for the first cycle.
    def crawl(klass, *uris)
      job_klass = klass.clone
      config = job_klass.config
      config.uuid = SecureRandom.uuid
    end
  end
end
