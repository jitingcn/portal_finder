class AddIfsZoneToPortals < ActiveRecord::Migration[6.0]
  def change
    add_column :portals, :ifs_zone, :string
  end
end
