class CreateTechSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :tech_skills do |t|
      t.string :name
      t.string :icon_name
      t.string :url
      t.integer :sort_order

      t.references :profile, foreign_key: true      
      t.timestamps
    end
  end
end
