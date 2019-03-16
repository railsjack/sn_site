namespace :company_members do
  task migrate_members: :environment do

    CompanyMember.all.each do |item|
      if item.user.present? and item.company.present?
        p '*'*100 + 'BEFORE ASSIGNMENT'
        p item.user.company
        p '*'*100
        item.user.company = item.company
        item.user.admin = item.admin
        item.user.save
        p '*'*100 + 'AFTER ASSIGNMENT'
        p item.user.company
        p '*'*100
      end
    end

    # Company.all.each do |company|
    #   if company.user_id.present?
    #     existing_member = CompanyMember.find_by_user_id(company.user_id)
    #     if existing_member.present?
    #       p "Member already exists (#{existing_member.user_id})"
    #     else
    #       member = CompanyMember.create(company: company, user_id: company.user_id, admin: true)
    #       if member.present?
    #         p "Migrated Successfully ------ #{company.company_name}"
    #       end
    #     end
    #   end
    # end

  end
end