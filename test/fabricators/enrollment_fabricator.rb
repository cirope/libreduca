Fabricator(:enrollment) do
  transient :with_job
  teach_id { Fabricate(:teach).id }
  enrollable_id { Fabricate(:user).id }
  enrollable_type 'User'
  job do |attrs|
    teach = Teach.find_by_id attrs[:teach_id]
    institution = teach.try(:grade).try(:institution)
    job_args = {
      user_id: attrs[:enrollable_id], institution_id: institution.try(:id)
    }
    job_args[:job] = attrs[:with_job] if attrs[:with_job]

    institution ? Fabricate(:job, job_args).job : nil
  end
end
