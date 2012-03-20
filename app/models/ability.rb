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
  end
  
  def coordinator_rules
  end
  
  def headmaster_rules
  end
  
  def teacher_rules
  end
  
  def parent_rules
  end
  
  def student_rules
  end
  
  def default_rules
    can :edit_profile, User
    can :update_profile, User
  end
end
