class CreateIfsSearchResults < ActiveRecord::Migration[6.0]
  def change
    create_table :ifs_search_results do |t|
      t.integer :column, null: false
      t.integer :row, null: false
      t.text :image_hash
      t.float :duplicate, array: true
      t.references :ifs_searches, null: false, foreign_key: true

      t.timestamps
    end
  end
end
