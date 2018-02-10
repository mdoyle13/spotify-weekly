class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "background job running"
    
  end
end
