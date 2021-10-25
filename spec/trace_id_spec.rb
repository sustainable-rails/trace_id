require "spec_helper"
require "trace_id"

RSpec.describe TraceId do
  describe "::get" do
    # white box because the other methods depend on this
    it "gets from thread local" do
      trace_id = "some value"
      Thread.current.thread_variable_set(TraceId::TRACE_ID,trace_id)
      expect(TraceId.get).to eq(trace_id)
    end
    it "returns nil if there is no value" do
      trace_id = "some other value"
      Thread.current.thread_variable_set(TraceId::TRACE_ID,nil)
      expect(TraceId.get).to be_nil
    end
  end
  describe "::set" do
    # white box because the other methods depend on this
    it "sets the value in thread local" do
      trace_id = "yet another value"
      TraceId.set(trace_id)
      expect(Thread.current.thread_variable_get(TraceId::TRACE_ID)).to eq(trace_id)
    end
  end
  describe "::reset!" do
    it "changes the value" do
      TraceId.set("some initial value")
      TraceId.reset!
      expect(TraceId.get).not_to be_nil
      expect(TraceId.get).not_to eq("some initial value")
    end
    it "yields the old value" do
      TraceId.set("some initial value")
      yielded_value = nil

      TraceId.reset! do |old_value|
        yielded_value = old_value
      end
      expect(yielded_value).to eq("some initial value")
    end
  end
  describe "::get_or_initialize" do
    it "returns the current value" do
      TraceId.set("some trace id")
      trace_id = TraceId.get_or_initialize
      expect(trace_id).to eq("some trace id")
    end
    it "sets a value if there isn't one and returns that" do
      TraceId.set(nil)
      trace_id = TraceId.get_or_initialize
      expect(trace_id).not_to be_nil
    end
  end
end
