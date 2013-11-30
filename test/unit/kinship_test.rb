require 'test_helper'

class KinshipTest < ActiveSupport::TestCase
  setup do
    @kinship = Fabricate(:kinship)
  end

  test 'create' do
    assert_difference 'Kinship.count' do
      @kinship = Kinship.create(Fabricate.attributes_for(:kinship))
    end
  end

  test 'update' do
    new_kin = @kinship.kin == Kinship::KINDS.first ?
      Kinship::KINDS.last : Kinship::KINDS.first

    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Kinship.count' do
        assert @kinship.update_attributes(kin: new_kin)
      end
    end

    assert_equal new_kin, @kinship.reload.kin
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Kinship.count', -1) { @kinship.destroy }
    end
  end

  test 'validates blank attributes' do
    @kinship.kin = ''

    assert @kinship.invalid?
    assert_equal 1, @kinship.errors.size
    assert_equal [error_message_from_model(@kinship, :kin, :blank)],
      @kinship.errors[:kin]
  end

  test 'validates included attributes' do
    @kinship.kin = 'no_kin'

    assert @kinship.invalid?
    assert_equal 1, @kinship.errors.size
    assert_equal [error_message_from_model(@kinship, :kin, :inclusion)],
      @kinship.errors[:kin]
  end

  test 'validates length of _long_ attributes' do
    @kinship.kin = 'abcde' * 52

    assert @kinship.invalid?
    assert_equal 2, @kinship.errors.count
    assert_equal [
      error_message_from_model(@kinship, :kin, :too_long, count: 255),
      error_message_from_model(@kinship, :kin, :inclusion)
    ].sort, @kinship.errors[:kin].sort
  end

  test 'update inverse kinship count' do
    kinship = Fabricate(:kinship, kin: Kinship::CHART_KINDS.sample)
    user = kinship.user
    relative = kinship.relative

    assert_equal 1, user.reload.kinships_in_chart_count
    assert_equal 0, user.inverse_kinships_in_chart_count
    assert_equal 0, relative.reload.kinships_in_chart_count
    assert_equal 1, relative.inverse_kinships_in_chart_count

    Fabricate(
      :kinship,
      user_id: user.id,
      kin: (Kinship::KINDS - Kinship::CHART_KINDS).sample
    )

    # Do not alter the counts
    assert_equal 1, user.reload.kinships_in_chart_count
    assert_equal 0, user.inverse_kinships_in_chart_count
    assert_equal 0, relative.reload.kinships_in_chart_count
    assert_equal 1, relative.inverse_kinships_in_chart_count

    assert kinship.destroy

    assert_equal 0, user.reload.kinships_in_chart_count
    assert_equal 0, user.inverse_kinships_in_chart_count
    assert_equal 0, relative.reload.kinships_in_chart_count
    assert_equal 0, relative.inverse_kinships_in_chart_count
  end
end
