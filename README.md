# rbsafecircuit

rbsafecircuit is a Ruby gem for implementing a circuit breaker pattern with event handling capabilities using `event_emitter`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbsafecircuit'
```
And then execute:
```ruby
bundle install
```
Or install it yourself as: 
```ruby
gem install rbsafecircuit
```
### Example Usage

```ruby
require 'rbsafecircuit'

# Example usage of CircuitBreaker
max_failures = 3
timeout = 10
pause_time = 5  # in seconds for simplicity
max_consecutive_successes = 2

cb = CircuitBreaker.new(max_failures, timeout, pause_time, max_consecutive_successes)

# Define a function to be executed (replace with your actual function)
test_function = lambda do
  # Simulate some work that might succeed or fail
  if rand < 0.8  # 80% success chance
    puts "Function succeeded!"
    "Success"
  else
    puts "Function failed!"
    raise StandardError.new("Function failed")
  end
end

# Execute the function with CircuitBreaker protection
cb.execute(&test_function)

# Event handling examples
cb.on_success { |result| puts "Success: #{result}" }
cb.on_failure { |error| puts "Error: #{error.message}" }
cb.set_on_open(lambda { puts "Circuit breaker is open!" })
cb.set_on_close(lambda { puts "Circuit breaker is closed." })
cb.set_on_half_open(lambda { puts "Circuit breaker is half-open." })

# Example: Let's wait for a while to see the events (just for demonstration)
sleep(15)

# Cleanup or final operations
# ...
```

### License
The gem is available as open source under the terms of the MIT License.
