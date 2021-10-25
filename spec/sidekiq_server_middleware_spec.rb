require "spec_helper"
require "trace_id"

RSpec.describe TraceId::SidekiqServerMiddleware do
  it "sets the value from the job" do
    TraceId.set(nil)
    job = {
      TraceId::TRACE_ID => "some id"
    }
    yieled = false

    described_class.new.call(nil, job, nil) do
      yieled = true
    end

    expect(TraceId.get).to eq("some id")
    expect(yieled).to eq(true)
  end
end
