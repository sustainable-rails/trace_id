class TraceId
  class SidekiqClientMiddleware
    def call(worker_class, job, queue, redis_pool)
      job[TraceId::TRACE_ID] = TraceId.get_or_initialize
      yield
    end
  end
end

