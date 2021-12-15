class TwitterAuth < ApplicationRecord
  belongs_to :user

  def self.get_sign_in_redirect_link
    params = {callback: ENV['TWITTER_API_CALLBACK'], app_key: ENV['TWITTER_API_KEY'], app_secret: ENV['TWITTER_API_SECRET']}
    twitter_service = Oauth::Twitter.new(params)
    result = twitter_service.get_redirect_url

    oauth_token = result[:oauth_token]    
    oauth_token_secret = result[:oauth_token_secret]

    # Save the token and secret to the table, so that we can use it later
    twitter_auth_session = OauthTokenSession.where("oauth_token = ? and provider = ?", oauth_token, "Twitter").first
    unless twitter_auth_session
      twitter_auth_session = OauthTokenSession.new()
    end

    twitter_auth_session.oauth_token = oauth_token
    twitter_auth_session.oauth_token_secret = oauth_token_secret
    twitter_auth_session.provider = "Twitter"
    twitter_auth_session.save

    return result[:url]
  end

  def self.obtain_access_token(oauth_token, oauth_verifier)
    params = {callback: ENV['TWITTER_API_CALLBACK'], app_key: ENV['TWITTER_API_KEY'], app_secret: ENV['TWITTER_API_SECRET']}

    # 1. look up the oauth_token_secret by oauth_token
    twitter_auth_session = OauthTokenSession.where("oauth_token = ? and provider = ?", oauth_token, "Twitter").first
    if twitter_auth_session
      twitter_service = Oauth::Twitter.new(params)
      oauth_token_secret = twitter_auth_session.oauth_token_secret
      twitter_resp = twitter_service.obtain_access_token(oauth_token, oauth_token_secret, oauth_verifier)

      access_token = twitter_resp["oauth_token"]
      access_token_secret = twitter_resp["oauth_token_secret"]
      twitter_user_id = twitter_resp["user_id"]
      screen_name = twitter_resp["screen_name"]

      # Here is the fun part
      # 1. we look up if the twitter_user_id exist
      # if yes, then it's an existing user
      # if no, then it's a new user

      # for new user we will create a new account
      # for existing user, we will look up the user info, and return the header for auth

      twitter_auth = TwitterAuth.find_by_twitter_user_id(twitter_user_id)
      if twitter_auth
        # return the user basic on the twitter id
        user = twitter_auth.user        
      else
        # create a new one and also create the user account too        
        str = (0...8).map { (65 + rand(26)).chr }.join
        password = Digest::SHA256.base64digest "#{twitter_user_id}#{screen_name}#{str}".first(8)
        
        user = User.create(email: "#{screen_name}@myglance.co", password: password)
        twitter_auth = TwitterAuth.new()
        twitter_auth.user_id = user.id
        twitter_auth.access_token = access_token
        twitter_auth.access_token_secret = access_token_secret
        twitter_auth.twitter_user_id = twitter_user_id
        twitter_auth.screen_name = screen_name
        twitter_auth.save        
      end
      
      twitter_auth_session.delete

      return user
    else
      return nil
    end
  end
end
