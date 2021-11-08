class CreateSocialNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :social_networks do |t|
      t.string :name
      t.string :icon_name
      t.string :url

      t.references :profile, foreign_key: true
      t.timestamps
    end
  end
end
