class CheckModelService
	def call
=begin
puts "Employee : #{Company.all.count}"
puts "Company : #{Company.all.count}"
puts "Follower : #{Follower.all.count}"
puts "Lead : #{Lead.all.count}"
puts "Lovedone : #{Lovedone.all.count}"
puts "Notification : #{Notification.all.count}"
puts "PrimaryContact : #{PrimaryContact.all.count}"
puts "Profile : #{Profile.all.count}"
puts "Provider : #{Provider.all.count}"
puts "Sponsor : #{Sponsor.all.count}"
puts "Trip : #{Trip.all.count}"
puts "User : #{User.all.count}"
=end
		check(Company)
	end

	def check(model)
		puts "#{model.class_name} : #{model.all.count}"
	end
end