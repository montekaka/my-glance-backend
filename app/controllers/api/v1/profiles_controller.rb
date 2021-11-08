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
      @profile = current_user.profiles.new(project_params)

      if @profile.save
        render json: @profile, status: :created
      else
        render json: @profile.errors, status: :unprocessable_entity
      end      
    end

    # PATCH/PUT /profiles/1
    def update
    end


    # DELETE /profiles/1
    def destroy
      @profile.destroy
    end    

    private
    def set_project
      @profile = current_user.profiles.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:profile).permit([:slug, :name, :short_description, :avatar_url, :banner_art_url, :primary_color, :secondary_color, :success_color, :danger_color, :warning_color, :info_color, :light_color, :dark_color])
    end    
  end
end # end of module