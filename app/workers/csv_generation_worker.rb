class CsvGenerationWorker
  include Sidekiq::Worker

  def perform
    CsvGeneratorService.generate_csv
  end
end
