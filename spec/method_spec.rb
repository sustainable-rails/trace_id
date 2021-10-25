require "spec_helper"
require "trace_id"

RSpec.describe TraceId::Method do
  class SomeClass
    include TraceId::Method
  end

  describe "#trace_id" do
    it "returns the current value" do
      TraceId.set("some trace id")
      trace_id = SomeClass.new.trace_id
      expect(trace_id).to eq("some trace id")
    end
    it "sets a value if there isn't one and returns that" do
      TraceId.set(nil)
      trace_id = SomeClass.new.trace_id
      expect(trace_id).not_to be_nil
    end
  end
end
