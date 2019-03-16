class Setting < ActiveRecord::Base
	def self.setting_keys
		['notification_fee']
	end

	def self.get_value(key)
		if !where(key: key).nil? and !where(key: key).first.nil?
			where(key: key).first.value
		else
			nil
		end
	end
end
