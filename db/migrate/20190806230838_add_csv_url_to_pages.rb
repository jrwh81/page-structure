class AddCsvUrlToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :csv_id, :string
  end
end
