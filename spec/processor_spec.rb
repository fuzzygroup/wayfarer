require "spec_helpers"

describe Wayfarer::Processor do
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }

  # FIXME: TODO No tests at all so far
end
