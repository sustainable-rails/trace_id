class TraceId
  module Method
    def trace_id
      TraceId.get_or_initialize
    end
  end
end
