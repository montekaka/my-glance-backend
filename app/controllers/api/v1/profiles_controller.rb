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
  end
end # end of module