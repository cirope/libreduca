class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_rules(user) : default_rules
  end
  
  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules") if respond_to?("#{role}_rules")
    end
    
    default_rules
  end
  
  def admin_rules
    can :manage, :all
    can :assign_roles, User
    can :edit_profile, User
    can :update_profile, User
  end
  
  def regular_rules
    can :create, :all
    can :update, :all
    can :destroy, :all
    can :edit_profile, User
    can :update_profile, User
  end
  
  def default_rules
    can :read, :all
  end
end
