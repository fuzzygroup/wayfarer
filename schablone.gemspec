Gem::Specification.new do |s|
  s.name          = "schablone"
  s.version       = "0.0.0"
  s.license       = "MIT"

  s.homepage      = "http://github.com/bauerd/scrapespeare"
  s.description   = "A web scraping library"
  s.summary       = "Schablone is a web scraping library"

  s.date          = "2014-11-12"
  s.authors       = ["Dominic Bauer"]
  s.email         = "bauerdominic@gmail.com"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")

  s.require_paths = ["lib"]
  s.executables   << "scrapespeare"

  s.add_dependency "mustermann"
  s.add_dependency "mustermann-uri-template"
  s.add_dependency "thread"
  s.add_dependency "nokogiri"
  s.add_dependency "selenium-webdriver"
  s.add_dependency "hashie"
  s.add_dependency "rack"
  s.add_dependency "net-http-persistent"
  s.add_dependency "pismo"
  s.add_dependency "mime-types"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "faker"
  s.add_development_dependency "factory_girl"

end
