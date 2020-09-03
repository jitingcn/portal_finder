class AddTitleAndUuidToIfsSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :ifs_searches, :title, :string
    add_column :ifs_searches, :uuid, :uuid
  end
end
