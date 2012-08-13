Fabricator(:enrollment) do
  teach_id { Fabricate(:teach).id }
  user_id { Fabricate(:user).id }
  job do |attrs|
    teach = Teach.find_by_id attrs[:teach_id]
    institution = teach.try(:grade).try(:institution)
    
    institution ? Fabricate(
      :job, user_id: attrs[:user_id], institution_id: institution.id
    ).job : nil
  end
end
