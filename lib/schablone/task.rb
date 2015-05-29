module Schablone
  class Task

    def self.router
      @router ||= Routing::Router.new
      @router.instance_eval(&proc) if block_given?
      @router
    end

    def invoke
      
    end

  end
end
