require 'rspec'

class Hello
  def handler(name)
    "Hello from #{RUBY_DESCRIPTION}, we can use #{RSpec.name} here, #{name}!"
  end
end
