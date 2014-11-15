require "spec_helpers"

module Scrapespeare
  describe Callbacks do

    subject { Object.new.extend(Scrapespeare::Callbacks) }

    describe "#callbacks" do

      context "with @callbacks" do
        it "exposes @callbacks" do
          subject.instance_variable_set(:@callbacks, "foobar")
          expect(subject.callbacks).to eq "foobar"
        end
      end

      context "without @callbacks" do
        it "returns an empty Hash" do
          expect(subject.callbacks).to eq({})
        end
      end

    end

    describe "#register_callback" do
      let(:callback) do
        Proc.new { 42 }
      end

      context "without existing callbacks" do
        it "adds a key to @callbacks" do
          subject.register_callback(:before, &callback)
          expect(subject.callbacks).to have_key :before
        end

        it "stores the callback in a list" do
          subject.register_callback(:before, &callback)
          expect(subject.callbacks[:before]).to eq [callback]
        end
      end

      context "with existing callbacks" do
        let(:existing_callback) { Proc.new { 96 } }

        before do
          subject.register_callback(:before, &existing_callback)
        end

        it "appends the callback to the list" do
          subject.register_callback(:before, &callback)
          expect(subject.callbacks[:before]).to eq [existing_callback, callback]
        end
      end

    end

    describe "#execute_callbacks" do
      let(:callback_a) { Proc.new { @callback_a_called = true } }
      let(:callback_b) { Proc.new { @callback_b_called = true } }

      before do
        subject.register_callback(:before, &callback_a)
        subject.register_callback(:before, &callback_b)
      end

      it "executes all callbacks for a context" do
        subject.execute_callbacks(:before)
        expect(@callback_a_called).to be true
        expect(@callback_b_called).to be true
      end

      it "passes arguments to the callbacks" do
        a = b = nil
        callback = Proc.new { |x, y| a = x; b = y }

        subject.register_callback(:before, &callback)
        subject.execute_callbacks(:before, 1, 2)

        expect(a).to be 1
        expect(b).to be 2
      end

      context "without callbacks present" do
        it "does not raise an Exception" do
          expect {
            subject.execute_callbacks(:foobar)
          }.not_to raise_error
        end
      end
    end

  end
end
