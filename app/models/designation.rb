class Designation < ActiveRecord::Base
	acts_as_paranoid
	belongs_to :company

	validates :name, :presence => true
	validates :color, :presence => true

	validates :name, uniqueness_without_deleted: {scope: [:color, :company_id]}

	def self.colors
		colors = []
		"red, green, blue, black, brown, pink, orange, yellow, purple, gold".split(", ").each do |color|
			color = color.humanize
			colors.push([color, color])
		end
		colors
	end

	# def self.categories
	# 	categories = []
	# 	"RN, LPN, CNA, RPT, PTA, MD, DO, DC, Other".split(", ").each do |ceatory|
	# 		categories.push([ceatory, ceatory])
	# 	end
	# 	categories
	# end

end
