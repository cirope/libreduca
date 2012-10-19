Fabricator(<%= class_name.match(/::/) ? "'#{class_name}'" : ":#{singular_name}" %>) do
<% attributes.each do |attribute| -%>
  <%- random = case attribute.type.to_s -%>
    <%- when 'string' then attribute.name.match(/name/).present? ?
      'Faker::Name.name' : ( 
        attribute.name.match(/email/).present? ? 'Faker::Internet.email' : 'Faker::Lorem.sentence'
      ) -%>
    <%- when 'text' then 'Faker::Lorem.paragraph' -%>
    <%- when *['date', 'datetime'] then 'rand(1.year).ago' -%>
    <%- when *['decimal', 'float'] then '100.0 * rand' -%>
    <%- when 'integer' then '100 * rand' -%>
    <%- else  attribute.type -%>
  <%- end -%>
  <%= "#{attribute.name} { #{random} }" %>
<% end -%>
end
