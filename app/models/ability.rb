class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_rules(user) : default_rules(user)
  end
  
  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules", user) if respond_to?("#{role}_rules")
    end
    
    default_rules(user)
  end
  
  def admin_rules(user)
    can :manage, :all
  end
  
  def regular_rules(user)
    teacher_rules(user)
    janitor_rules(user)
    headmaster_rules(user)
  end
  
  def default_rules(user)
    can :edit_profile, User
    can :update_profile, User
    can :manage, Forum
    can :manage, Comment
    can :read, Teach, enrollments: { user_id: user.id }
    can :read, Content
  end

  def teacher_rules(user)
    enrollments_restricionts = {
      enrollments: { user_id: user.id, job: 'teacher' }
    }
    
    can :read, Enrollment, teach: enrollments_restricionts
    can :send_email_summary, Enrollment, teach: enrollments_restricionts
    can :update, Teach, enrollments_restricionts
    can :manage, Content, teach: enrollments_restricionts
    can :send_email_summary, Teach, enrollments_restricionts
    can :read, Course, teaches: enrollments_restricionts
    can :read, Grade, courses: { teaches: enrollments_restricionts }
    can :read, School, users: { id: user.id }
    can :read, User, enrollments_restricionts
  end

  def janitor_rules(user)
    jobs_restrictions = {
      school: { workers: { user_id: user.id, job: 'janitor' } }
    }
    
    can :manage, Grade, jobs_restrictions
    can :manage, Course, grade: jobs_restrictions
    can :manage, Teach, course: { grade: jobs_restrictions }
    can :manage, Content, teach: { course: { grade: jobs_restrictions } }
    can :read, School, workers: { user_id: user.id, job: 'janitor' }
  end

  def headmaster_rules(user)
    jobs_restrictions = {
      school: { workers: { user_id: user.id, job: 'headmaster' } }
    }
    
    can :read, Grade, jobs_restrictions
    can :read, Course, grade: jobs_restrictions
    can :read, School, workers: { user_id: user.id, job: 'headmaster' }
  end
end
