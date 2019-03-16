class LovedonePolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @lovedone = model
  end

  def index?
    #user.admin? or not post.published?
    @lovedone.primary_contact = @user
  end
end

=begin
class LovedonePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(:primary_contact => user)
      end
    end
  end
end
=end