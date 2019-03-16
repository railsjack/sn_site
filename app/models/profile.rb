class Profile < ActiveRecord::Base
    enum user_types: [:default, :family_member]

    belongs_to :user

    has_many :leads, dependent: :destroy

    def self.contact_types
        return  ["email","text"]
    end
    #http://amberonrails.com/storing-arrays-in-a-database-field-w-rails-activerecord/
    serialize :contact_method
    #http://stackoverflow.com/questions/8097750/array-attribute-for-ruby-model
    #serialize :contact_method, Array

    def to_s
        self.user.name if self.user
    end    

    def name
        "#{last_name}, #{first_name}"
    end
end
