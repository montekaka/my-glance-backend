module Api::V1
  class TechSkillsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile
    before_action :set_tech_skill, only: [:show, :update, :destroy]
    

    # GET /profiles/2/tech_skills
    def index
      @tech_skills = @profile.tech_skills
      render json: @tech_skills
    end

    # GET /profiles/2/tech_skills/1
    def show
      render json: @tech_skill
    end

    # POST /profiles/2/tech_skills
    def create
      @tech_skill = @profile.tech_skills.new(tech_skill_params)

      if @tech_skill.save
        render json: @tech_skill, status: :created
      else
        render json: @tech_skill.errors, status: :unprocessable_entity
      end      
    end

    # PATCH/PUT /profiles/2/tech_skills/1
    def update
      if @tech_skill.update(tech_skill_params)
        render json: @tech_skill, status: :ok
      else
        render json: @tech_skill.errors, status: :unprocessable_entity
      end
    end

    # DELETE /profiles/2/tech_skills/1
    def destroy
      @tech_skill.destroy
    end   
    
    # post /v1/profiles/:project_id/sync_tech_skills
    # create or update or delete all-in
    def sync
      if params["items"]
        items = @profile.sync_tech_skills(params["items"])
        render json: items, status: :ok
      else
        render json: { message: ["tech skills are missing"] }, status: :bad_request
      end
    end

    private
    def set_profile
      @profile = current_user.profiles.friendly.find(params[:profile_id])
    end

    def set_tech_skill
      @tech_skill = @profile.tech_skills.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tech_skill_params
      params.require(:tech_skill).permit([:name, :icon_name, :sort_order, :url])
    end    
  end
end # end of module