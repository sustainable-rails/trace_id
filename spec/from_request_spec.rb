require "spec_helper"
require "ostruct"
require "trace_id"

RSpec.describe TraceId::FromRequest do
  it "returns the request id of the controller" do
    controller = OpenStruct.new(
      request: OpenStruct.new(
        request_id: "some id"
      )
    )
    TraceId::FromRequest.before(controller)
    expect(TraceId.get).to eq("some id")
  end
end
