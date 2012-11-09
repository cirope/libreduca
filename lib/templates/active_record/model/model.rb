class <%= class_name %> < ActiveRecord::Base
  has_paper_trail

  attr_accessible <%= attributes.map { |a| ":#{a.name}" }.join(', ') %>

  <% if attributes.any?(&:has_uniq_index?) -%>
    <% uniqueness_attrs = [] -%>
    <% attributes.map { |a| uniqueness_attrs << ":#{a.name}" if a.has_uniq_index? } %>
  validates <%= uniqueness_attrs.join(', ') %>, uniqueness: true
  <% end -%>
end
