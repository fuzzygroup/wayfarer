module Wayfarer
  # Entry-point for initiating a new crawl
  class Crawler
    # Stages URIs for the first cycle and runs a {Processor}
    # @param [Job] klass the job to run.
    # @param [*Array<URI>, *Array<String>] *uris the URIs to stage for the first cycle.
    def crawl(klass, *uris)
      processor = Processor.new(klass.config)

      processor.run(klass, *uris)
    end
  end
end
