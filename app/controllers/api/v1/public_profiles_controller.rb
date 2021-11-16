module Api::V1
  class PublicProfilesController < ApplicationController
    before_action :set_profile, only: [:show]

    # GET /profiles/1
    def show
      body_widgets = @profile.widgets.where("section_name = 'body'").order(:sort_order)
      banner_widgets = @profile.widgets.where("section_name = 'banner'").order(:sort_order)
      unless @profile.avatar_url
        user_email = @profile.user.email.downcase
        hash = Digest::MD5.hexdigest(user_email)
        image_src = "https://www.gravatar.com/avatar/#{hash}?s=256"
        @profile.avatar_url = image_src
      end

      social_networks = @profile.social_networks.order(:sort_order).map {|x| {id: x.icon_name, name: x.name, url: x.url}}
      tech_skills = @profile.tech_skills.order(:sort_order).map {|x| x.icon_name}
      
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