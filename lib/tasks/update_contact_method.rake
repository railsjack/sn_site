namespace :update_contact_method do
  task update_follower: :environment do
    Follower.all.each do |follower|
      contact_method = 0
      f_c_m = follower.contact_method
      contact_method = f_c_m.reject { |c| c.empty? } if f_c_m.present?
      unless contact_method.eql? 0
        if contact_method.eql? ['text']
          follower.contact_method_setting = 'contact_text'
        elsif contact_method.eql? ['email']
          follower.contact_method_setting = 'contact_email'
        elsif contact_method.eql? ['email', 'text']
          follower.contact_method_setting = 'both'
        end
        follower.save
      end
    end
  end
end