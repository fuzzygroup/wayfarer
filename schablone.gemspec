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

  s.add_dependency "mustermann",                 "~> 0.4"
  s.add_dependency "mustermann-uri-template",    "~> 0.4"
  s.add_dependency "thread",                     "~> 0.1"
  s.add_dependency "nokogiri",                   "~> 1.6"
  s.add_dependency "selenium-webdriver",         "~> 2.43"
  s.add_dependency "hashie",                     "~> 3.4"
  s.add_dependency "rack",                       "~> 1.6"
  s.add_dependency "ansi",                       "~> 1.5"
  s.add_dependency "net-http-persistent",        "~> 2.9"
  s.add_dependency "pismo",                      "~> 0.7"
  s.add_dependency "mime-types"
  

  s.add_development_dependency "rake",           "~> 10.4"
  s.add_development_dependency "rspec",          "~> 3.1"
  s.add_development_dependency "yard",           "~> 0.8"
  s.add_development_dependency "cucumber",       "~> 1.3"
  s.add_development_dependency "sinatra",        "~> 1.4"
  s.add_development_dependency "rubocop",        "~> 0.29"
  s.add_development_dependency "faker",          "~> 1.4"

end
