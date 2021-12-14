module Api::V1
  class TwitterOauthsController < ApplicationController

    # GET /v1/twitter_oauth/get_login_link (login with twitter)
    def get_login_link
      url = TwitterAuth.get_sign_in_redirect_link
      
      if url
        render json: {request_url: url}   
      else
        render json: {message: "Something went wrong."}, status: :bad_request
      end
    end

    # POST /v1/twitter_oauth/sign_in
    def login
      # converting the request token to access token
      oauth_token = params[:oauth_token]
      oauth_verifier = params[:oauth_verifier]
      if oauth_token && oauth_verifier
        user = TwitterAuth.obtain_access_token(oauth_token, oauth_verifier)
        if user
          header = user.create_new_auth_token
          response.set_header('access-token', header["access-token"]) 
          response.set_header('token-type', header["token-type"]) 
          response.set_header('client', header["client"]) 
          response.set_header('expiry', header["expiry"]) 
          response.set_header('uid', header["uid"]) 

          render json: {data: user}, status: :ok
        else
          res = {
            "success": false,
            "errors": [
              "Invalid login credentials. Please try again."
            ]
          }
          render json: res, status: :unauthorized         
        end
      else
        res = {
          "success": false,
          "errors": [
            "Failed to sign in with Twitter"
          ]
        }         
        render json: res, status: :unauthorized
      end

    end

    private
    # Only allow a list of trusted parameters through.
    def twitter_oauth_params
      params.require(:twitter_oauth).permit([:oauth_token, :oauth_verifier])
    end       
  end
end