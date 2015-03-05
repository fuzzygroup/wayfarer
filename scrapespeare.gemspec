$:.push(File.expand_path("../lib", __FILE__))
require "scrapespeare"

Gem::Specification.new do |s|
  s.name          = "scrapespeare"
  s.version       = Scrapespeare::VERSION
  s.license       = "MIT"

  s.homepage      = "http://github.com/bauerd/scrapespeare"
  s.description   = "A web scraping library"
  s.summary       = <<-summary
    scrapespeare is a web scraping library
  summary

  s.date          = "2014-11-12"
  s.authors       = ["Dominic Bauer"]
  s.email         = "bauerdominic@gmail.com"

  s.files         = %x(git ls-files).split("\n")
  s.test_files    = %x(git ls-files -- {spec,features}/*).split("\n")

  s.require_paths = ["lib"]
  s.executables   << "scrapespeare"

  s.add_dependency "thread",                     "~> 0.1",  ">= 0.1.5"
  s.add_dependency "nokogiri",                   "~> 1.6",  ">= 1.6.3"
  s.add_dependency "selenium-webdriver",         "~> 2.43", ">= 2.43.0"
  s.add_dependency "selenium-emulated_features", "~> 0.0",  ">= 0.0.2"
  s.add_dependency "hashie",                     "~> 3.4",  ">= 3.4.0"
  s.add_dependency "rack",                       "~> 1.6",  ">= 1.6.0"

  s.add_development_dependency "rake",           "~> 10.4", ">= 10.4.2"
  s.add_development_dependency "rspec",          "~> 3.1",  ">= 3.1.0"
  s.add_development_dependency "yard",           "~> 0.8",  ">= 0.8.7.6"
  s.add_development_dependency "cucumber",       "~> 1.3",  ">= 1.3.17"
  s.add_development_dependency "sinatra",        "~> 1.4",  ">= 1.4.5"
end
