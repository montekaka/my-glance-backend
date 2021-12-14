module Api::V1
  class OauthTokenSessionsController < ApplicationController

    # post /delete_oauth_token_session
    def delete_sessions
      oauth_token = params[:token]
      provider = params[:provider]
      
      sessions = OauthTokenSession.where("oauth_token = ? and provider = ?", oauth_token, provider)
      if sessions.count > 0
        sessions.delete_all
      end

      render json: { message: ["Ok"] }, status: :ok
    end    
     
  end
end # end of module