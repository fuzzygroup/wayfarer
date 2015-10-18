#!/usr/bin/env ruby

require_relative "../lib/wayfarer"

require "pathname"
require "active_support/inflector"
require "thor"
require "ruby-progressbar"

module Wayfarer
  class CLI < Thor
    desc "exec FILE_NAME", "Run FILE_NAME starting with URI"
    def exec(file_name, uri)
      klass = load_class_from_file(file_name)

      bar = Wayfarer::Util::ProgressBar.new

      crawler = Wayfarer::Crawler.new
      crawler.processor.add_observer(bar)
      crawler.crawl(klass, uri)
    end

    desc "route", "Display the matching route in FILE_NAME for URI"
    def route(file_name, uri)
      klass = load_class_from_file(file_name)

      method, params = klass.router.route(URI(uri))

      if method
        puts "Dispatching to :#{method} with parameters: #{params}"
      else
        puts "No matching route."
      end
    end

    desc "enqueue", "Display the matching route in FILE_NAME for URI"
    def enqueue(file_name, uri)
      load_class_from_file(file_name).perform_later
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
