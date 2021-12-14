class CreateOauthTokenSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_token_sessions do |t|

      t.string :provider
      t.string :oauth_token
      t.string :oauth_token_secret
      t.string :oauth_verifier

      t.timestamps
    end
  end
end
