module Api::V1
  class ProfilesController < ApplicationController
    before_action :set_profile, only: [:show, :update, :destroy]
    before_action :authenticate_user!

    # GET /profiles
    def index
      @profiles = current_user.profiles.all
      render json: @profiles
    end

    # GET /profiles/1
    def show
      render json: @profile
    end

    # POST /profiles
    def create
      @profile = current_user.profiles.new(profile_params)
      # try to pull twitter profile photo down if user connect with twitter
      twitter_auth = current_user.twitter_auth

      if twitter_auth
        @profile.avatar_url = twitter_auth.get_profile_image
      end

      if @profile.save
        render json: @profile, status: :created
      else
        render json: @profile.errors, status: :unprocessable_entity
      end      
    end

    # PATCH/PUT /profiles/1
    def update
      if @profile.update(profile_params)
        render json: @profile, status: :ok
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end


    # DELETE /profiles/1
    def destroy
      @profile.destroy
    end    

    private
    def set_profile
      @profile = current_user.profiles.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit([:slug, :name, :short_description, :avatar_url, :banner_art_url, :primary_color, :secondary_color, :success_color, :danger_color, :warning_color, :info_color, :light_color, :dark_color])
    end    
  end
end # end of module