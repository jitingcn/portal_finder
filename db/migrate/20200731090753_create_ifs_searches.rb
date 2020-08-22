class CreateIfsSearches < ActiveRecord::Migration[6.0]
  def change
    # enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :ifs_searches do |t|  # , id: :uuid, default: 'gen_random_uuid()'
      t.text :image_hash
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
