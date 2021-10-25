class TraceId
  class FromRequest
    def self.before(controller)
      TraceId.set(controller.request.request_id)
    end
  end
end

