Fabricator(:enrollment) do
  teach_id { Fabricate(:teach).id }
  user_id { Fabricate(:user).id }
  job do |e|
    school = e.teach.try(:grade).try(:school)
    
    school ? Fabricate(:job, user_id: e.user_id, school_id: school.id).job : nil
  end
end
