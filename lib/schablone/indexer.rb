require "thread"

module Schablone
  class Indexer
    include Celluloid
    include Celluloid::Notifications

    attr_reader :adapter, :page, :params

    def initialize(router, adapter, page, params)
      @adapter = adapter
      @page    = page
      @params  = params
    end

    def self.helpers(*modules, &proc)
      include(*modules) if modules.any?
      class_eval(&proc) if block_given?
    end

    def evaluate(payload)
      wrapped_object.instance_eval(&payload)
    end

    private

    def halt
      publish("halt")
    end

    def visit(*uris)
      Celluloid::Actor[:navigator].async.stage(*uris)
    end

    def index(sym)
      evaluate(@processor.router.payloads[sym])
    end
  end
end
