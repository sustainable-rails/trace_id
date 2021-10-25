require "spec_helper"
require "trace_id"

RSpec.describe TraceId::SidekiqClientMiddleware do
  context "when there is a current value" do
    it "sets the value in the job" do
      job = {}
      yieled = false

      TraceId.set("some id")

      described_class.new.call(nil, job, nil, nil) do
        yieled = true
      end

      expect(job[TraceId::TRACE_ID]).to eq("some id")
      expect(yieled).to eq(true)
    end
  end
  context "when there is no current value" do
    it "initializes a value and sets it on the job" do
      job = {}
      yieled = false

      TraceId.set(nil)

      described_class.new.call(nil, job, nil, nil) do
        yieled = true
      end

      expect(job[TraceId::TRACE_ID]).not_to be_nil
      expect(yieled).to eq(true)
    end
  end
end
