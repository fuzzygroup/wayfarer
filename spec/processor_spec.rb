require "spec_helpers"

describe Wayfarer::Processor do
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }

  # TODO Tests
end
