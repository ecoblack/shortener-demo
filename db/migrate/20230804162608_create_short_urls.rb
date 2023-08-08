class CreateShortUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :short_urls do |t|
      t.references :user, foreign_key: true, null: true
      t.string :original_url, null: false
      t.string :code, null: false, unique: true

      t.timestamps
    end
  end
end
