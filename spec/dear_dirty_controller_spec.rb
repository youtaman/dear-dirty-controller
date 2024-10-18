# frozen_string_literal: true

RSpec.describe DearDirtyController do
  let(:klass) do
    Class.new do
      include DearDirtyController::Mixin
      def initialize(param1, param2)
        @param1 = param1
        @param2 = param2
      end

      def execute
        { param1: @param1, param2: @param2 }
      end
    end
  end

  describe "Mixin module" do
    describe ".call" do
      it "calls the controller" do
        instance = klass.new(1, 2)
        expect(klass).to receive(:new).with(1, 2).and_return(instance)
        expect_any_instance_of(klass).to receive(:call)
        klass.call(1, 2)
      end
    end

    describe "#call" do
      it "runs callbacks" do
        instance = klass.new(1, 2)
        expect(instance).to receive(:run_before_callbacks)
        expect(instance).to receive(:run_after_callbacks)
        instance.call
      end

      it "sets serialized result to body" do
        instance = klass.new(1, 2)
        expect(instance).to receive(:serialize).and_return("serialized")
        expect(instance).to receive(:body).with("serialized")
        instance.call
      end

      it "builds rack response" do
        instance = klass.new(1, 2)
        expect(instance).to receive(:build_rack_response)
        instance.call
      end

      it "rescues errors" do
        error = StandardError.new("test")
        klass.send(:before) { raise error }
        instance = klass.new(1, 2)

        expect(instance).to receive(:try_rescue).with(error).and_return("rescued")
        instance.call
      end
    end
  end

  describe "#execute and #initialize" do
    just_included_klass = Class.new do
      include DearDirtyController::Mixin
    end

    it "need implement" do
      just_included_klass = Class.new do
        include DearDirtyController::Mixin
      end
      expect { just_included_klass.new }.to raise_error(NotImplementedError)

      initializable_klass = Class.new do
        include DearDirtyController::Mixin
        def initialize; end
      end
      expect { initializable_klass.new.execute }.to raise_error(NotImplementedError)
    end
  end
end
