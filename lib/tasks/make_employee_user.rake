namespace :make_employee_user do
  task get_employee: :environment do
    Employee.where.not(password: nil).each do |emp|
      if emp.user_id.nil?
        if emp.company_id.present? and emp.username.present?
          valid_email = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
          if emp.username =~ valid_email
            email = emp.username
          else
            email = emp.email.present? ? emp.email : "#{emp.username}@email.com"
          end
          emp.create_user(
              email: email,
              username: emp.username,
              password: emp.password,
              password_confirmation: emp.password,
              role: 'employee',
              company: emp.company,
              confirmed_at: Time.now
            )
          if emp.user_id.present?
            puts "************** username:#{emp.user.username}, password: #{emp.password} created as user for web application **********************"
          else
            begin
              emp.user.save(validate: false)
            rescue => e
              puts e.message
            end
            puts "************* User for Employee #{emp.full_name} with id #{emp.id} created by making validation false"

          end
        end
      else
        puts "************* Employee #{emp.full_name} with id #{emp.id} has been skipped"
      end
    end
    puts '---------------  TASK COMPLETED -----------------'
  end
end