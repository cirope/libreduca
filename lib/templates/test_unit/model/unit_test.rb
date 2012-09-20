require 'test_helper'

<% module_namespacing do -%>
class <%= class_name %>Test < ActiveSupport::TestCase
  def setup
    @<%= singular_table_name %> = Fabricate(:<%= singular_table_name %>)
  end

  test 'create' do
    assert_difference ['<%= class_name %>.count', 'Version.count'] do
      @<%= singular_table_name %> = <%= class_name %>.create(Fabricate.attributes_for(:<%= singular_table_name %>))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference '<%= class_name %>.count' do
        assert @<%= singular_table_name %>.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @<%= singular_table_name %>.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('<%= class_name %>.count', -1) { @<%= singular_table_name %>.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @<%= singular_table_name %>.attr = ''
    
    assert @<%= singular_table_name %>.invalid?
    assert_equal 1, @<%= singular_table_name %>.errors.size
    assert_equal [error_message_from_model(@<%= singular_table_name %>, :attr, :blank)],
      @<%= singular_table_name %>.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_<%= singular_table_name %> = Fabricate(:<%= singular_table_name %>)
    @<%= singular_table_name %>.attr = new_<%= singular_table_name %>.attr

    assert @<%= singular_table_name %>.invalid?
    assert_equal 1, @<%= singular_table_name %>.errors.size
    assert_equal [error_message_from_model(@<%= singular_table_name %>, :attr, :taken)],
      @<%= singular_table_name %>.errors[:attr]
  end
end
<% end -%>
