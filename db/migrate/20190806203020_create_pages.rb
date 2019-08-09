class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :relative_path
      t.string :parent_path
      t.string :slug

      t.timestamps
    end
  end
end
