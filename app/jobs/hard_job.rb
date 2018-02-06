class HardJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    50000.times do
      puts 'hi'
    end
  end
end
