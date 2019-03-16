namespace :db do
  task swipe: :environment do
  	puts 'Clean users...'
		User.where.not(email: ENV['ADMIN_EMAIL']).each{|u| u.destroy}
		puts 'Done'

		puts 'Clean invitations...'
		Invitation.destroy_all
		ActiveRecord::Base.connection.execute("truncate invitations")
		puts 'Done'

		puts 'Clean invoices...'
		Invoice.destroy_all
		puts 'Done'
		puts 'Clean Lovedones...'
		Lovedone.destroy_all
		puts 'Done'

		puts 'Clean notifications...'
		Notification.destroy_all
		puts 'Done'

		puts 'Clean providers...'
		Provider.destroy_all
		puts 'Done'

		puts 'Clean Sponsors...'
		Sponsor.destroy_all
		puts 'Done'

		puts 'Clean Trips...'
		Trip.destroy_all
		puts 'Done'
  end


  task company: :environment do
  	puts 'Creating companies'
  	provider_types = ['Home_Health', 'Transport']
  	featured = [true, false]
  	20.times do
	    user = User.find_or_create_by!(email: ('a'..'z').to_a.shuffle[0,9].join+'@a.com') do |user|
	    	company_name = (('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0,9].join
	    	city = (('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0,9].join
	    	county = (('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0,9].join
	    	state = (('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0,9].join
	    	zip = (0..9).to_a.shuffle[0,9].join
	      user.company = Company.create company_name: company_name, business_name: company_name, 
	      	city: city,
	      	county: county,
	      	state: state,
	      	zip: zip,
	      	provider_type: provider_types.shuffle[0, 1][0], 
	      	featured: featured.shuffle[0, 1][0]
	      user.password = 'abcd1234'
	      user.password_confirmation = 'abcd1234'
	      user.confirm!
	    end
	  end
  end


  task empname_conv: :environment do
  	Employee.all.each{ |employee| 
  		next if employee.name_no_use.nil?
  		r = employee.name_no_use.split; 
  		employee.first_name=r[0]; 
  		employee.last_name=r[1]; 
  		employee.save
  	}
  end

  task clean_notification: :environment do
  	Notification.all.each{|notification| 
  		notification.destroy if notification.sponsor.nil? 
  	}
  end

  task auto_confirm_for_pc: :environment do
  	PrimaryContact.all.each do |pc|
  		pc.user.confirm!
  	end
  end

end
