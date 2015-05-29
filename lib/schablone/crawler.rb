module Schablone
  module Crawler
    module_function

    def crawl(task, *uris)
      Celluloid::Actor[:processor] = Processor.new
      Celluloid::Actor[:navigator].stage(*uris)
      Celluloid::Actor[:processor].run(task)
    end
  end
end
