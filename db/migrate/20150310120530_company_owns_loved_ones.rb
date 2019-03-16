class CompanyOwnsLovedOnes < ActiveRecord::Migration
  def self.up
    add_column :lovedones, :company_id, :integer
    add_index :lovedones, :company_id

    # ActiveRecord::Base.connection.execute('SELECT * FROM providers').each(as: :hash) do |provider|
    #   lovedone = Lovedone.find(provider['lovedone_id'])
    #   # If not an orphan rcord
    #   next if provider['company_id'].blank?
    #
    #   # If loved on not associated to any company
    #   if lovedone.company_id.nil?
    #     lovedone.update_attribute :company_id, provider['company_id']
    #     # Loved one already exists for another company
    #   else
    #     lovedone_params = lovedone.attributes.except('id')
    #     new = Lovedone.create(lovedone_params)
    #     new.save
    #     new.update_attribute :company_id, provider['company_id']
    #   end
    # end
  end

  def self.down
    remove_index :lovedones, :company_id
    remove_column :lovedones, :company_id
    Lovedone.where("id NOT IN (#{ActiveRecord::Base.connection.execute('SELECT lovedone_id from providers').to_a.collect(&:first).join(',')})").destroy_all
  end
end
