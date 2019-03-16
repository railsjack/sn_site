namespace :company_tabs do
  task create_tabs: :environment do
    tabs = ['Employees', 'Loved Ones', 'Scheduler', 'My Company', 'Track', 'Reports', 'Data Import', 'Data Export', 'LifePatient', 'Help']
    tabs.each do |tab|
      existing = Tab.where(name: tab)
      if existing.count < 1
        created_tab = Tab.create(name: tab)
        if created_tab.present?
          p "Tab created ------ (#{tab})"
        end
      else
        p "Tab already Exists"
      end
    end

  end
end