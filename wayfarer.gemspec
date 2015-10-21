Gem::Specification.new do |s|
  s.name          = "wayfarer"
  s.version       = "0.0.0"
  s.license       = "MIT"

  s.homepage      = "http://github.com/bauerd/wayfarer"
  s.description   = "A web crawling/scraping framework"
  s.summary       = s.description

  s.date          = "2014-11-12"
  s.authors       = ["Dominic Bauer"]
  s.email         = "bauerdominic@gmail.com"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.require_paths = ["lib"]

  s.executables << "wayfarer"

  s.add_runtime_dependency "celluloid",                  "~> 0.17"
  s.add_runtime_dependency "connection_pool",            "~> 2.2"
  s.add_runtime_dependency "nokogiri",                   "~> 1.6"
  s.add_runtime_dependency "selenium-webdriver",         "~> 2.47"
  s.add_runtime_dependency "selenium-emulated_features", "~> 2.0"
  s.add_runtime_dependency "net-http-persistent",        "~> 2.9"
  s.add_runtime_dependency "mime-types",                 "~> 2.6"
  s.add_runtime_dependency "pismo",                      "~> 0.7"
  s.add_runtime_dependency "mustermann",                 "~> 0.4"
  s.add_runtime_dependency "activejob",                  "~> 4.2"
  s.add_runtime_dependency "ruby-progressbar",           "~> 1.7"
  s.add_runtime_dependency "thor",                       "~> 0.19"
  s.add_runtime_dependency "activesupport",              "~> 4.2"
  s.add_runtime_dependency "capybara",                   "~> 2.5"
  s.add_runtime_dependency "chronic",                    "~> 0.10"
  s.add_runtime_dependency "redis",                      "~> 3.2"
  s.add_runtime_dependency "pry"
  s.add_runtime_dependency "thread_safe",                "~> 0.3"

  s.add_development_dependency "oj",      "~> 2.12"
  s.add_development_dependency "rake",    "~> 10.4"
  s.add_development_dependency "rspec",   "~> 3.3"
  s.add_development_dependency "sinatra", "~> 1.4"
  s.add_development_dependency "rubocop", "~> 0.34"
  s.add_development_dependency "yard",    "~> 0.8"
end
