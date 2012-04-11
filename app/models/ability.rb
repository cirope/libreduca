class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_rules(user) : default_rules
  end
  
  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules", user) if respond_to?("#{role}_rules")
    end
    
    default_rules
  end
  
  def admin_rules(user)
    can :manage, :all
  end
  
  def regular_rules(user)
    # Teachers
    enrollments_restricionts = {
      enrollments: { user_id: user.id, job: 'teacher' }
    }
    
    can :read, Teach, enrollments_restricionts
    can :update, Teach, enrollments_restricionts
    can :read, Course, teaches: enrollments_restricionts
    can :read, Grade, courses: { teaches: enrollments_restricionts }
    can :read, School, users: { id: user.id }
    
    # Janitors
    jobs_restricionts = {
      school: { workers: { user_id: user.id, job: 'janitor' } }
    }
    
    can :manage, Grade, jobs_restricionts
    can :manage, Course, grade: jobs_restricionts
    can :manage, Teach, course: { grade: jobs_restricionts }
    can :read, School, workers: { user_id: user.id, job: 'janitor' }
  end
  
  def default_rules
    can :edit_profile, User
    can :update_profile, User
  end
end
