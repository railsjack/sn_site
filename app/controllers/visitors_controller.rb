class VisitorsController < ApplicationController
	before_filter :authenticate_user!
	def index
		if !current_user.nil? and current_user.admin?
			redirect_to admin_dashboard_path and return
		elsif !current_user.nil?
			@company = current_user.company
		end
	end
end
