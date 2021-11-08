module Api::V1
  class SocialNetworksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile, only: [:index, :create, :show, :update, :destroy]
    before_action :set_social_network, only: [:show, :update, :destroy]
    

    # GET /profiles/2/social_networks
    def index
      @social_networks = @profile.social_networks
      render json: @social_networks
    end

    # GET /profiles/2/social_networks/1
    def show
      render json: @social_network
    end

    # POST /profiles/2/social_networks
    def create
      @social_network = @profile.social_networks.new(social_network_params)

      if @social_network.save
        render json: @social_network, status: :created
      else
        render json: @social_network.errors, status: :unprocessable_entity
      end      
    end

    # PATCH/PUT /profiles/2/social_networks/1
    def update
      if @social_network.update(social_network_params)
        render json: @social_network, status: :ok
      else
        render json: @social_network.errors, status: :unprocessable_entity
      end
    end

    # DELETE /profiles/2/social_networks/1
    def destroy
      @social_network.destroy
    end    

    private
    def set_profile
      @profile = current_user.profiles.friendly.find(params[:profile_id])
    end

    def set_social_network
      @social_network = @profile.social_networks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def social_network_params
      params.require(:social_network).permit([:name, :icon_name, :sort_order, :url])
    end    
  end
end # end of module