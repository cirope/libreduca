class Ability
  include CanCan::Ability

  def initialize(user, institution)
    @job = user.jobs.in_institution(institution).first if user && institution

    user ? user_rules(user, institution) : default_rules(user, institution)
  end
  
  def user_rules(user, institution)
    user.roles.each do |role|
      send("#{role}_rules", user, institution) if respond_to?("#{role}_rules")
    end
  end
  
  def admin_rules(user, institution)
    can :manage, :all
  end
  
  def regular_rules(user, institution)
    if @job
      teacher_rules(user, institution)    if @job.teacher?
      janitor_rules(user, institution)    if @job.janitor?
      headmaster_rules(user, institution) if @job.headmaster?
    end

    default_rules(user, institution) if institution
  end
  
  def default_rules(user, institution)
    can :edit_profile, User
    can :update_profile, User
    can :manage, Forum
    can :manage, Comment
    can :read, Teach, enrollments: { user_id: user.id }
    can :read, Institution, workers: { user_id: user.id }
    can :read, Content
    can :read, Document
    can :read, Question
    can :read, Reply, user_id: user.id
    can :create, Reply, user_id: user.id
    can :update, Reply, user_id: user.id
    can :read, Image
  end

  def teacher_rules(user, institution)
    enrollments_restrictions = {
      enrollments: { user_id: user.id, job: 'teacher' }
    }
    teach_restrictions = { teach: enrollments_restrictions }
    
    can :read, Enrollment, teach_restrictions
    can :send_email_summary, Enrollment, teach_restrictions
    can :update, Teach, enrollments_restrictions
    can :manage, Content, teach_restrictions
    can :read, Survey # TODO: really check if can read, now is through teaches, so is checked from there...
    can :send_email_summary, Teach, enrollments_restrictions
    can :read, Course, teaches: enrollments_restrictions
    can :read, Grade, courses: { teaches: enrollments_restrictions }
    can :read, User, enrollments_restrictions
    can :manage, Image, institution_id: institution.id
  end

  def janitor_rules(user, institution)
    jobs_restrictions = {
      institution: { workers: { user_id: user.id, job: 'janitor' } }
    }
    
    can :manage, Grade, jobs_restrictions
    can :manage, Course, grade: jobs_restrictions
    can :manage, Teach, course: { grade: jobs_restrictions }
    can :manage, Content, teach: { course: { grade: jobs_restrictions } }
    can :read, Survey # TODO: really check if can read, now is through teaches, so is checked from there...
    can :manage, Image, jobs_restrictions
    can :read, Job, institution_id: institution.id
    can :read, User, jobs: { institution_id: institution.id }
    can :create, User do |user|
      job_conditions = user.jobs.empty?
      job_conditions ||= user.jobs.all? { |j| j.institution_id == institution.id }
      
      user.is?(:regular) && job_conditions
    end
    can :update, User do |user|
      user.jobs.in_institution(institution).exists?
    end
  end

  def headmaster_rules(user, institution)
    jobs_restrictions = {
      institution: { workers: { user_id: user.id, job: 'headmaster' } }
    }
    
    can :read, Grade, jobs_restrictions
    can :read, Course, grade: jobs_restrictions
    can :manage, Image, jobs_restrictions
  end
end
