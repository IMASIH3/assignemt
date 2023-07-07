class CsvFilesController < ApplicationController
    def index
      @csv_files = CsvFile.all
    end
  
    def show
      @csv_file = CsvFile.find(params[:id])
      send_data @csv_file.file.download, filename: @csv_file.name, type: 'text/csv', disposition: 'attachment'
    end
end