class CreateTwitterAuths < ActiveRecord::Migration[6.1]
  def change
    create_table :twitter_auths do |t|
      t.string :access_token
      t.string :access_token_secret
      t.string :twitter_user_id
      t.string :screen_name
      
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
