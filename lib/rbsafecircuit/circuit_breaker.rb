
require 'event_emitter'

module CircuitBreakerState
  CLOSED = 'closed'
  OPEN = 'open'
  HALF_OPEN = 'half_open'
end

class CircuitBreaker
  include EventEmitter

  def initialize(max_failures, timeout, pause_time, max_consecutive_successes)
    super()
    @state = CircuitBreakerState::CLOSED
    @consecutive_failures = 0
    @total_failures = 0
    @total_successes = 0
    @max_failures = max_failures
    @timeout = timeout
    @open_timeout = Time.at(0)
    @pause_time = pause_time
    @consecutive_successes = 0
    @max_consecutive_successes = max_consecutive_successes
  end

  def execute(&fn)
    thread = Thread.new do
      begin
        result = fn.call
        handle_success
        emit('success', result)
      rescue StandardError => error
        handle_failure
        emit('failure', error)
      end
    end

    thread.join

    case @state
    when CircuitBreakerState::OPEN
      if Time.now > @open_timeout
        @state = CircuitBreakerState::HALF_OPEN
        emit('halfOpen')
      else
        emit('open')
        raise RuntimeError.new("Circuit breaker is open")
      end
    when CircuitBreakerState::HALF_OPEN
      delay(@pause_time)
      return
    end
  end

  def handle_failure
    @consecutive_failures += 1
    @total_failures += 1
    trip if @consecutive_failures >= @max_failures
  end

  def handle_success
    reset
    @total_successes += 1
  end

  def trip
    @state = CircuitBreakerState::OPEN
    @consecutive_failures = 0
    @consecutive_successes = 0
    @open_timeout = Time.now + @timeout
    emit('open')
  end

  def reset
    @state = CircuitBreakerState::CLOSED
    @consecutive_failures = 0
    @consecutive_successes = 0
    emit('close')
  end

  def delay(ms)
    sleep(ms / 1000.0)
  end

  def on_success(&block)
    on('success', &block)
  end

  def on_failure(&block)
    on('failure', &block)
  end

  def set_on_open(callback)
    on('open', &callback)
  end

  def set_on_close(callback)
    on('close', &callback)
  end

  def set_on_half_open(callback)
    on('halfOpen', &callback)
  end
end
