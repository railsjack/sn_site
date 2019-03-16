class SettingsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@setting = Setting.new
		@setting_values = {}
		Setting.all.each do |setting|
			@setting_values["#{setting.key}"] = setting.value
		end
	end
  def show
  end

  def create
  	Setting.destroy_all
  	keys = setting_params[:key]
  	values = setting_params[:value]
  	keys.each_with_index do |value, index|
  		setting = Setting.new key: keys[index], value: values[index]
  		setting.save
  	end
  	redirect_to settings_url
  end

  def edit
  end


  def setting_params
    params.require(:setting).permit({key: []},{value: []})
  end
end
