$:.push File.expand_path("../lib", __FILE__)
require "scrapespeare"

Gem::Specification.new do |s|
  s.name        = "scrapespeare"
  s.homepage    = "http://github.com/bauerd/scrapespeare"
  s.version     = Scrapespeare::VERSION
  s.date        = "2014-11-12"
  s.summary     = <<-summary
    scrapespeare is small Ruby web scraping library built on top of Nokogiri. It supports firing HTTP requests via Net::HTTP and automation of a browser via Selenium"s Ruby Bindings.
  summary
  s.description = "A web scraping library"
  s.authors     = ["Dominic Bauer"]
  s.email       = "bauerdominic@gmail.com"
  s.license     = "MIT"

  s.files       = %x(git ls-files).split("\n")
  s.test_files  = %x(git ls-files -- {spec,features}/*).split("\n")
  s.require_paths = ["lib"]
  
  s.add_dependency "nokogiri", "~> 1.6", ">= 1.6.3"
  s.add_dependency "selenium-webdriver", "~> 2.43", ">= 2.43.0"

  s.add_development_dependency "rspec", "~> 3.1", ">= 3.1.0"
  s.add_development_dependency "faker", "~> 1.4", ">= 1.4.3"
  s.add_development_dependency "webmock", "~> 1.20", ">= 1.20.0"
  s.add_development_dependency "yard", "~> 0.8", ">= 0.8.7.6"
end
