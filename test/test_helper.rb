#require "codeclimate-test-reporter"
#CodeClimate::TestReporter.start

gem "minitest"
require "minitest/autorun"
require "securerandom"
require "benchmark"
$: << 'lib' << 'test'
require "chef_steps"

# doubles generated emails so 50% will be duplicate
# randomizes placement via Array#shuffle!
def generate_emails(num=50000)
  y = num.times.map {|x| SecureRandom.uuid.delete('-') + x.to_s + '@' + SecureRandom.uuid.delete('-') + '.com'}
  y += y
  y.shuffle!
end

def create_test_file(filename, array)
  File.open(filename, "w+") do |file|
    file.print(array.join("\n"))
  end
end
