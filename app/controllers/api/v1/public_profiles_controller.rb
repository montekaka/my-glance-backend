module Api::V1
  class PublicProfilesController < ApplicationController
    before_action :set_profile, only: [:show]

    # GET /profiles/1
    def show
      body_widgets = @profile.widgets.where("section_name = 'body'").order(:sort_order)
      banner_widgets = @profile.widgets.where("section_name = 'banner'").order(:sort_order)

      social_networks = @profile.social_networks.order(:sort_order)
      tech_skills = @profile.tech_skills.order(:sort_order)
      
      render json: {
        profile: @profile,
        social_networks: social_networks,
        tech_skills: tech_skills,
        body_widgets: body_widgets,
        banner_widgets: banner_widgets
      }
      # @user.as_json(only: [:picture, :age], methods: [:name]) to fewer fileds
    end

    private
    def set_profile
      @profile = Profile.friendly.find(params[:id])
    end  
  end
end # end of module