class CreateCsvFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :csv_files do |t|
      t.string :name

      t.timestamps
    end
  end
end
