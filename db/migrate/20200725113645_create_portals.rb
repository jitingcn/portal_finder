# frozen_string_literal: true

class CreatePortals < ActiveRecord::Migration[6.0]
  def change
    create_table :portals, id: false do |t|
      # t.integer :portal_id, null: false
      t.string :name, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :image_url, null: false
      t.string :image_hash
      t.text :city
      t.string :province

      t.timestamps
    end
    # add_index :portals, :portal_id, unique: true
    add_index :portals, :image_hash  # , unique: true
    add_index :portals, [:latitude, :longitude], unique: true
  end
end
