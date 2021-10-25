class TraceId
  class SidekiqServerMiddleware
    def call(worker, job, queue)
      TraceId.set(job[TraceId::TRACE_ID])
      yield
    end
  end
end
