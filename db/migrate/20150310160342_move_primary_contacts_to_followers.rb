class MovePrimaryContactsToFollowers < ActiveRecord::Migration
  def self.up
    add_column :followers, :contact_method, :text
    # ActiveRecord::Base.connection.execute('select * from primary_contacts').each(as: :hash) do |pc|
    #   user = User.find(pc['user_id'])
    #   follower = Follower.new
    #   follower.lovedone_id = pc['lovedone_id']
    #   follower.first_name = user.profile.first_name
    #   follower.last_name = user.profile.last_name
    #   follower.email = user.email
    #   follower.phone_number = user.profile.phone_number
    #   follower.contact_method = user.profile.contact_method
    #   follower.user_id = pc['user_id']
    #   puts "Can't save follower due to : #{follower.errors.full_messages.to_sentence}" unless follower.save
    # end
  end

  def self.down
    remove_column :followers, :contact_method
  end
end
