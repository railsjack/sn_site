class StaticPagesController < ApplicationController
  before_filter :authenticate_user!, except: [:thankyou]

  def thankyou
  end

  def training_videos
    authorize! :read, StaticPagesController

  	redirect_to root_path if current_user.nil? or !current_user.serviceprovider?
    @page = params[:page]
  	@video_id = params[:id]
    @tab_id = params[:tab_id]
  end

  def user_guides

  end
end
