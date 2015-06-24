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
  s.executables   << "schablone"

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "celluloid"
  s.add_runtime_dependency "connection_pool"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "selenium-webdriver"
  s.add_runtime_dependency "selenium-emulated_features", "~> 2.0"
  s.add_runtime_dependency "net-http-persistent"
  s.add_runtime_dependency "mime-types"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "rubocop"
end
