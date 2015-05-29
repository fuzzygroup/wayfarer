module Schablone
  class Crawler
    attr_reader :router

    def initialize(&proc)
      @router = Router.new
      instance_eval(&proc) if block_given?
    end

    def helpers(*modules, &proc)
      Indexer.helpers(*modules, &proc)
    end

    def index(sym, &proc)
      @router.register_payload(sym, &proc)
    end

    def config(*argv, &proc)
      Schablone.configure(*argv, &proc)
    end

    def router(&proc)
      @router.instance_eval(&proc) if block_given?
      @router
    end

    def crawl(*uris)
      Celluloid.boot

      Processor.supervise_as(:processor, @router)
      Navigator.supervise_as(:navigator)

      processor = Celluloid::Actor[:processor]
      navigator = Celluloid::Actor[:navigator]

      navigator.stage(uris)
      navigator.cycle

      processor.run

      Celluloid.shutdown
    end
  end
end
