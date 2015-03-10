require "spec_helpers"

describe Scrapespeare::Processor do

  let(:scrapers) { Hash[default: Object.new] }
  let(:router)   { Router.new { register "/*" } }

end
