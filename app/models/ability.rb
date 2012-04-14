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
    
    can :read, Enrollment, teach: enrollments_restricionts
    can :send_email_summary, Enrollment, teach: enrollments_restricionts
    can :read, Teach, enrollments_restricionts
    can :update, Teach, enrollments_restricionts
    can :send_email_summary, Teach, enrollments_restricionts
    can :read, Course, teaches: enrollments_restricionts
    can :read, Grade, courses: { teaches: enrollments_restricionts }
    can :read, School, users: { id: user.id }
    can :read, User, enrollments: { teach: enrollments_restricionts }
    
    # Janitors
    jobs_restricionts = {
      school: { workers: { user_id: user.id, job: 'janitor' } }
    }
    
    can :manage, Grade, jobs_restricionts
    can :manage, Course, grade: jobs_restricionts
    can :manage, Teach, course: { grade: jobs_restricionts }
    can :read, School, workers: { user_id: user.id, job: 'janitor' }
    
    # Headmasters
    jobs_restricionts = {
      school: { workers: { user_id: user.id, job: 'headmaster' } }
    }
    
    can :read, Grade, jobs_restricionts
    can :read, Course, grade: jobs_restricionts
    can :read, Teach, course: { grade: jobs_restricionts }
    can :read, School, workers: { user_id: user.id, job: 'headmaster' }
  end
  
  def default_rules
    can :edit_profile, User
    can :update_profile, User
  end
end
