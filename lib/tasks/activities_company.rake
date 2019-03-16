namespace :activities_company do
  task company_check: :environment do
    activities = Activity.all.each do |act|
      if act.company.nil?
        act.company_id = act.employee.company.id if act.employee.present?
        act.save
        p '*'*100
        p 'Saved Successfully'
        p '*'*100
      else
        p '*'*100
        p 'Company already assigned'
        p '*'*100
      end
    end
  end
end
