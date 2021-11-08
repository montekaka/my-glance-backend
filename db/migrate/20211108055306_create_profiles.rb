class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :short_description
      t.string :avatar_url
      t.string :banner_art_url
      
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
