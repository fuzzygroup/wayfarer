require "spec_helpers"

module Scrapespeare
  describe Callbacks do

    let(:object_with_callbacks) { Object.new.extend(Callbacks) }

    describe "#callbacks" do
      context "with @callbacks set" do
        before do
          object_with_callbacks.instance_variable_set(:@callbacks, "set")
        end

        it "exposes @callbacks" do
          expect(object_with_callbacks.callbacks).to eq "set"
        end
      end

      context "without @callbacks set" do
        it "sets @callbacks to an empty Hash" do
          expect(object_with_callbacks.callbacks).to eq({})
        end
      end
    end

    describe "#register_callback" do
      let(:callback) { Proc.new { 42 } }

      context "without existing callbacks" do
        it "adds a key to @callbacks" do
          object_with_callbacks.register_callback(:context, &callback)
          expect(object_with_callbacks.callbacks).to have_key :context
        end

        it "stores the callback in a list" do
          object_with_callbacks.register_callback(:context, &callback)
          expect(object_with_callbacks.callbacks[:context]).to eq [callback]
        end
      end

      context "with existing callbacks" do
        let(:existing_callback) { Proc.new { 96 } }

        before do
          object_with_callbacks.register_callback(:before, &existing_callback)
        end

        it "appends the callback to the list" do
          object_with_callbacks.register_callback(:before, &callback)
          expect(object_with_callbacks.callbacks[:before]).to eq \
            [existing_callback, callback]
        end
      end

    end

    describe "#execute_callbacks" do
      let(:callback_a) { Proc.new { @callback_a_called = true } }
      let(:callback_b) { Proc.new { @callback_b_called = true } }

      before do
        object_with_callbacks.register_callback(:context, &callback_a)
        object_with_callbacks.register_callback(:context, &callback_b)
      end

      it "executes all callbacks in a context" do
        object_with_callbacks.execute_callbacks(:context)
        expect(@callback_a_called).to be true
        expect(@callback_b_called).to be true
      end

      it "passes arguments to the callbacks" do
        a = b = nil
        callback = Proc.new { |x, y| a = x; b = y }

        object_with_callbacks.register_callback(:context, &callback)
        object_with_callbacks.execute_callbacks(:context, 1, 2)

        expect(a).to be 1
        expect(b).to be 2
      end

      context "without callbacks for a context present" do
        it "does not raise an Exception" do
          expect {
            object_with_callbacks.execute_callbacks(:unknown_context)
          }.not_to raise_error
        end
      end
    end

  end
end
