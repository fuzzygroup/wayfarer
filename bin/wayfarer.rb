#!/usr/bin/env ruby

require_relative "../lib/wayfarer"

require "pathname"
require "active_support/inflector"
require "thor"

module Wayfarer
  class CLI < Thor
    desc "exec", "an example task"
    def exec(file_name, uri)
      klass = load_class_from_file(file_name)

      crawler = Wayfarer::Crawler.new
      crawler.crawl(klass, uri)
    end

    desc "route", "an example task"
    def route(file_name, uri)
      klass = load_class_from_file(file_name)

      method, params = klass.router.route(URI(uri))

      if method
        puts "Dispatching to :#{method} with parameters: #{params}"
      else
        puts "No matching route."
      end
    end

    private

    def load_class_from_file(file_path)
      path = File.join(Dir.pwd, file_path.chomp(".rb"))
      base_name = Pathname.new(path).basename.to_s

      require path
      base_name.camelize.constantize
    end
  end
end

Wayfarer::CLI.start(ARGV)
