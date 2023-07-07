require 'sidekiq'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    CsvGenerationWorker.perform_async
    ScheduleCsvGenerationJob.perform_in(24.hours)
  end
end

class ScheduleCsvGenerationJob
  include Sidekiq::Worker

  def perform
    CsvGenerationWorker.perform_async
    ScheduleCsvGenerationJob.perform_in(24.hours)
  end
end
