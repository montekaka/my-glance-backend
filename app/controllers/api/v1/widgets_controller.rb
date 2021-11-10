module Api::V1
  class WidgetsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile
    before_action :set_widget, only: [:show, :update, :destroy]
    

    # GET /profiles/2/widgets
    def index
      @widgets = @profile.widgets
      render json: @widgets
    end

    # GET /profiles/2/widgets/1
    def show
      render json: @widget
    end

    # POST /profiles/2/widgets
    def create
      @widget = @profile.widgets.new(widget_params)

      if @widget.save
        render json: @widget, status: :created
      else
        render json: @widget.errors, status: :unprocessable_entity
      end      
    end

    # PATCH/PUT /profiles/2/widgets/1
    def update
      if @widget.update(widget_params)
        render json: @widget, status: :ok
      else
        render json: @widget.errors, status: :unprocessable_entity
      end
    end

    # DELETE /profiles/2/widgets/1
    def destroy
      @widget.destroy
    end   
    
    # post /v1/profiles/:project_id/sync_widgets
    # create or update or delete all-in
    def sync
      if params["items"]
        items = @profile.sync_widgets(params["items"])
        render json: items, status: :ok
      else
        render json: { message: ["widgets are missing"] }, status: :bad_request
      end
    end

    private
    def set_profile
      @profile = current_user.profiles.friendly.find(params[:profile_id])
    end

    def set_widget
      @widget = @profile.widgets.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def widget_params
      params.require(:widget).permit([:type, :name, :icon_name, :sort_order, :url, :is_dynamic_content, :post_title, :post_description, :image_url, :section_name, :link_type, :user_name])
    end    
  end
end # end of module