class CreateWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets do |t|
      t.string :title
      t.string :type
      t.string :icon_name
      t.string :post_title
      t.text :post_description      
      t.string :url
      t.integer :sort_order
      t.boolean :is_dynamic_content
      t.string :image_url
      t.string :section_name # banner vs body
      t.string :link_type # e.g. general, rss_feed,  github, medium, dev_to, hashnode
      t.string :user_name

      t.references :profile, foreign_key: true 
      t.timestamps
    end
  end
end
