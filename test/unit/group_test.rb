require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Fabricate(:group)
  end

  test 'create' do
    assert_difference 'Group.count' do
      @group = Group.create(Fabricate.attributes_for(:group))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Group.count' do
        assert @group.update(name: 'Updated')
      end
    end

    assert_equal 'Updated', @group.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Group.count', -1) { @group.destroy }
    end
  end

  test 'validates blank attributes' do
    @group.name = ''
    @group.institution_id = nil

    assert @group.invalid?
    assert_equal 2, @group.errors.size
    assert_equal [error_message_from_model(@group, :name, :blank)],
      @group.errors[:name]
    assert_equal [error_message_from_model(@group, :institution_id, :blank)],
      @group.errors[:institution_id]
  end

  test 'validates unique attributes' do
    new_group = Fabricate(:group, institution_id: @group.institution_id)
    @group.name = new_group.name

    assert @group.invalid?
    assert_equal 1, @group.errors.size
    assert_equal [error_message_from_model(@group, :name, :taken)],
      @group.errors[:name]
  end

  test 'validates length of _long_ attributes' do
    @group.name = 'abcde' * 52

    assert @group.invalid?
    assert_equal 1, @group.errors.count
    assert_equal [
      error_message_from_model(@group, :name, :too_long, count: 255)
    ], @group.errors[:name]
  end

  test 'magick search' do
    5.times { Fabricate(:group, name: 'magick_name') }

    Fabricate(:group, name: 'magick_something')

    groups = Group.magick_search('magick')

    assert_equal 6, groups.count
    assert groups.all? { |u| u.to_s =~ /magick/ }

    groups = Group.magick_search('magick_name')

    assert_equal 5, groups.count
    assert groups.all? { |u| u.to_s =~ /magick_name/ }

    groups = Group.magick_search(
      "magick_something #{I18n.t('magick_columns.or').first} magick_name"
    )

    assert_equal 6, groups.count
    assert groups.all? { |u| u.to_s =~ /magick_name|magick_something/ }

    groups = Group.magick_search('nobody')

    assert groups.empty?
  end
end
