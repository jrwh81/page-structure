class AddCsvToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :csv, :string
  end
end
