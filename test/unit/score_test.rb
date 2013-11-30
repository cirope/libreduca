require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  setup do
    @score = Fabricate(:score)
  end

  test 'create' do
    assert_difference 'Score.count' do
      @score = Score.create(Fabricate.attributes_for(:score))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Score.count' do
        assert @score.update_attributes(score: 99.87)
      end
    end

    assert_equal '99.87', '%.2f' % @score.reload.score
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Score.count', -1) { @score.destroy }
    end
  end

  test 'validates blank attributes' do
    @score.score = ''
    @score.multiplier = nil

    assert @score.invalid?
    assert_equal 2, @score.errors.size
    assert_equal [error_message_from_model(@score, :score, :blank)],
      @score.errors[:score]
    assert_equal [error_message_from_model(@score, :multiplier, :blank)],
      @score.errors[:multiplier]
  end

  test 'validates well formated attributes' do
    @score.score = '12x'
    @score.multiplier = '12.x'

    assert @score.invalid?
    assert_equal 2, @score.errors.size
    assert_equal [error_message_from_model(@score, :score, :not_a_number)],
      @score.errors[:score]
    assert_equal [error_message_from_model(@score, :multiplier, :not_a_number)],
      @score.errors[:multiplier]
  end

  test 'validates attribute boundaries' do
    @score.score = -0.01
    @score.multiplier = -0.01

    assert @score.invalid?
    assert_equal 2, @score.errors.size
    assert_equal [
      error_message_from_model(
        @score, :score, :greater_than_or_equal_to, count: 0
      )
    ], @score.errors[:score]
    assert_equal [
      error_message_from_model(
        @score, :multiplier, :greater_than_or_equal_to, count: 0
      )
    ], @score.errors[:multiplier]

    @score.score = 100.01
    @score.multiplier = 1000

    assert @score.invalid?
    assert_equal 2, @score.errors.size
    assert_equal [
      error_message_from_model(
        @score, :score, :less_than_or_equal_to, count: 100
      )
    ], @score.errors[:score]
    assert_equal [
      error_message_from_model(@score, :multiplier, :less_than, count: 1000)
    ], @score.errors[:multiplier]
  end

  test 'validates length of _long_ attributes' do
    @score.description = 'abcde' * 52

    assert @score.invalid?
    assert_equal 1, @score.errors.count
    assert_equal [
      error_message_from_model(@score, :description, :too_long, count: 255)
    ], @score.errors[:description]
  end

  test 'of user' do
    Fabricate(:score, user_id: @score.user_id)
    Fabricate(:score)

    assert_equal 2, Score.of_user(@score.user).count
    assert Score.of_user(@score.user).all? { |s| s.user_id == @score.user_id }
  end

  test 'weighted average' do
    Score.destroy_all

    Fabricate(:score, score: '90', multiplier: '40')
    Fabricate(:score, score: '80', multiplier: '60')

    assert_equal '84.00', '%.2f' % Score.weighted_average
  end
end
