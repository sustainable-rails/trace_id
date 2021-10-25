require "securerandom"

require_relative "trace_id/version"
require_relative "trace_id/from_request"
require_relative "trace_id/sidekiq_server_middleware"
require_relative "trace_id/sidekiq_client_middleware"
require_relative "trace_id/method"

class TraceId
  TRACE_ID = "__trace_id"

  # Get the current trace id, or nil if one has not been set.
  # You are more likely to want get_or_initialize, which will initialize one for the rest
  # of the thread if one hasn't been set.
  def self.get
    Thread.current.thread_variable_get(TRACE_ID)
  end

  # Resets the current traced.  The block, if given, is
  # called with the old trace id if you want to log it before it 
  # becomes irrelevant.
  def self.reset!(&block)
    original = self.get
    self.set(self.new_trace_id_value)
    if !block.nil?
      block.(original)
    end
  end

  # Get the current trace id, initializing it if there isn't one set.
  def self.get_or_initialize
    trace_id = self.get
    if trace_id.to_s.strip.length == 0
      trace_id = self.new_trace_id_value
      self.set(trace_id)
    end
    self.get
  end

  # Set the new trace id. Note, you might want reset! if you simply want
  # a new value. This method is useful only when you have externalized a trace id
  # you wish to restore, such us in a sidekiq job
  def self.set(new_trace_id)
    Thread.current.thread_variable_set(TRACE_ID, new_trace_id)
  end

private

  def self.new_trace_id_value
    SecureRandom.uuid
  end

end
