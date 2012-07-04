Fabricator(:enrollment) do
  teach_id { Fabricate(:teach).id }
  user_id { Fabricate(:user).id }
  job do |attrs|
    teach = Teach.find_by_id attrs[:teach_id]
    school = teach.try(:grade).try(:school)
    
    school ? Fabricate(
      :job, user_id: attrs[:user_id], school_id: school.id
    ).job : nil
  end
end
