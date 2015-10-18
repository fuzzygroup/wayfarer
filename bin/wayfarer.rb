#!/usr/bin/env ruby

require "pathname"
require "active_support/inflector"
require "thor"
# require_relative "../lib/wayfarer"

module Wayfarer
  class CLI < Thor
    desc "exec", "an example task"
    def exec(file_name, uri)
      puts load_class_from_file(file_name)
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
