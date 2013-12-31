class Ability
  include CanCan::Ability

  def initialize(user, institution)
    @job = user.jobs.in_institution(institution).first if user && institution

    user ? user_rules(user, institution) : public_rules(institution)

    alias_action :find_user_or_group, to: :read
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
      student_rules(user, institution)    if @job.student?
      teacher_rules(user, institution)    if @job.teacher?
      janitor_rules(user, institution)    if @job.janitor?
      headmaster_rules(user, institution) if @job.headmaster?
    end

    if institution
      default_rules(user, institution)
      public_rules(institution)
    end
  end

  def default_rules(user, institution)
    can :edit_profile, User
    can :update_profile, User
    can :read, Forum
    can [:read, :create], Comment
    can :read, Teach, enrollments: { enrollable_id: user.id, enrollable_type: 'User' }
    can :read, Institution, workers: { user_id: user.id }
    can :read, Content
    can :read, Document
    can :read, Question
    can [:read, :create, :update, :dashboard], Reply, user_id: user.id
    can :read, Image
    can [:read, :create, :destroy], Vote, user_id: user.id
  end

  def public_rules(institution)
    can :read, Institution
    can :read, News
    can :read, Tag, institution_id: institution.id if institution
  end

  def student_rules(user, institution)
    can [:read, :create], Presentation
  end

  def teacher_rules(user, institution)
    enrollments_restrictions = {
      enrollments: { enrollable_id: user.id, enrollable_type: 'User', job: 'teacher' }
    }
    teach_restrictions = { teach: enrollments_restrictions }
    jobs_restrictions = {
      institution: { workers: { user_id: user.id, job: 'teacher' } }
    }

    can :read, Enrollment, teach_restrictions
    can :send_email_summary, Enrollment, teach_restrictions
    can :manage, Teach, jobs_restrictions # TODO: check access
    cannot :destroy, Teach, enrollments_restrictions
    can :manage, Content, teach: { course: { grade: jobs_restrictions } }
    can :create, Survey # TODO: fix
    can [:read, :update, :destroy], Survey, institution: { id: institution.id }
    can :send_email_summary, Teach, enrollments_restrictions
    can :read, Course, teaches: enrollments_restrictions
    can :read, Grade, courses: { teaches: enrollments_restrictions }
    can :read, User, enrollments_restrictions
    can :manage, Image, institution_id: institution.id
    can :read, Presentation # TODO: check for proper access
    can [:read, :dashboard], Reply
    can :manage, Forum
  end

  def janitor_rules(user, institution)
    jobs_restrictions = {
      institution: { workers: { user_id: user.id, job: 'janitor' } }
    }

    can :manage, Grade, jobs_restrictions
    can :manage, Course, grade: jobs_restrictions
    can :manage, Teach, course: { grade: jobs_restrictions }
    can :manage, Content, teach: { course: { grade: jobs_restrictions } }
    can :create, Survey # TODO: fix
    can [:read, :update, :destroy], Survey, grade: { institution_id: institution.id }
    can :manage, Image, institution_id: institution.id
    can :read, Job, institution_id: institution.id
    can :create, Job, institution_id: institution.id
    can :read, User, jobs: { institution_id: institution.id }
    can :destroy, User, jobs: { institution_id: institution.id }
    can :create, User do |user|
      job_conditions = user.jobs.empty?
      job_conditions ||= user.jobs.all? { |j| j.institution_id == institution.id }

      user.is?(:regular) && job_conditions
    end
    can :update, User do |user|
      user.jobs.in_institution(institution).exists?
    end
    can :find_by_email, User
    can :manage, Presentation # TODO: check for proper access
    can :manage, News, institution_id: institution.id
    can :manage, Group, institution_id: institution.id
    can :manage, Membership
    can :read, Enrollment
    can :manage, Tag, institution_id: institution.id
    can [:read, :dashboard], Reply # TODO: fix
    can :manage, Forum
  end

  def headmaster_rules(user, institution)
    jobs_restrictions = {
      institution: { workers: { user_id: user.id, job: 'headmaster' } }
    }

    can :read, Grade, jobs_restrictions
    can :read, Course, grade: jobs_restrictions
    can :manage, Image, institution_id: institution.id
    can :manage, Forum
  end
end
