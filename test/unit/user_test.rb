require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = Fabricate(:user)
  end

  test 'create' do
    assert_difference ['User.count', 'PaperTrail::Version.count'] do
      @user = User.create(Fabricate.attributes_for(:user))
    end
  end

  test 'create with jobs' do
    assert_difference ['User.count', 'Job.count'] do
      @user = User.create(
        Fabricate.attributes_for(:user).merge(
          jobs_attributes: {
            new_1: Fabricate.attributes_for(:job, user_id: nil)
          }
        )
      )
    end
  end

  test 'create with kinships' do
    relative = Fabricate(:user)

    assert_difference ['User.count', 'Kinship.count'] do
      @user = User.create(
        Fabricate.attributes_for(:user).merge(
          kinships_attributes: {
            new_1: Fabricate.attributes_for(
              :kinship, user_id: nil, relative_id: relative.id
            )
          }
        )
      )
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'User.count' do
        assert @user.update(name: 'Updated')
      end
    end

    assert_equal 'Updated', @user.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('User.count', -1) { @user.destroy }
    end
  end

  test 'validates blank attributes' do
    @user.name = ''
    @user.email = ''

    assert @user.invalid?
    assert_equal 2, @user.errors.size
    assert_equal [error_message_from_model(@user, :name, :blank)],
      @user.errors[:name]
    assert_equal [error_message_from_model(@user, :email, :blank)],
      @user.errors[:email]
  end

  test 'validates well formated attributes' do
    @user.email = 'incorrect@format'

    assert @user.invalid?
    assert_equal 1, @user.errors.size
    assert_equal [error_message_from_model(@user, :email, :invalid)],
      @user.errors[:email]
  end

  test 'validates unique attributes' do
    new_user = Fabricate(:user)
    @user.email = new_user.email

    assert @user.invalid?
    assert_equal 1, @user.errors.size
    assert_equal [error_message_from_model(@user, :email, :taken)],
      @user.errors[:email]
  end

  test 'validates confirmed attributes' do
    @user.password = 'admin124'
    @user.password_confirmation = 'admin125'
    assert @user.invalid?
    assert_equal 1, @user.errors.count
    assert_equal [
      error_message_from_model(@user, :password_confirmation, :confirmation)
    ], @user.errors[:password_confirmation]
  end

  test 'validates length of _short_ attributes' do
    @user.password = @user.password_confirmation = '12345'

    assert @user.invalid?
    assert_equal 1, @user.errors.count
    assert_equal [
      error_message_from_model(@user, :password, :too_short, count: 6)
    ], @user.errors[:password]
  end

  test 'validates length of _long_ attributes' do
    @user.name = 'abcde' * 52
    @user.lastname = 'abcde' * 52
    @user.email = "#{'abcde' * 52}@test.com"

    assert @user.invalid?
    assert_equal 3, @user.errors.count
    assert_equal [
      error_message_from_model(@user, :name, :too_long, count: 255)
    ], @user.errors[:name]
    assert_equal [
      error_message_from_model(@user, :lastname, :too_long, count: 255)
    ], @user.errors[:lastname]
    assert_equal [
      error_message_from_model(@user, :email, :too_long, count: 255)
    ], @user.errors[:email]
  end

  test 'has job in' do
    institution = Fabricate(:institution)

    assert !@user.has_job_in?(institution)

    Fabricate(:job, user_id: @user.id, institution_id: institution.id)

    assert @user.has_job_in?(institution)
  end

  test 'drop job in' do
    institution = Fabricate(:institution)
    Fabricate(:job, user_id: @user.id, institution_id: institution.id)

    assert @user.has_job_in?(institution)

    @user.drop_job_in(institution)

    assert !@user.reload.has_job_in?(institution)
  end

  test 'magick search' do
    5.times { Fabricate(:user) { name { 'magick_name' } } }
    3.times { Fabricate(:user) { lastname { 'magick_lastname' } } }
    Fabricate(:user) {
      name { 'magick_name' }
      lastname { 'magick_lastname' }
    }

    users = User.magick_search('magick')

    assert_equal 9, users.count
    assert users.all? { |u| u.to_s =~ /magick/ }

    users = User.magick_search('magick_name')

    assert_equal 6, users.count
    assert users.all? { |u| u.to_s =~ /magick_name/ }

    users = User.magick_search('magick_name magick_lastname')

    assert_equal 1, users.count
    assert users.all? { |u| u.to_s =~ /magick_name magick_lastname/ }

    users = User.magick_search(
      "magick_name #{I18n.t('magick_columns.or').first} magick_lastname"
    )

    assert_equal 9, users.count
    assert users.all? { |u| u.to_s =~ /magick_name|magick_lastname/ }

    users = User.magick_search('nobody')

    assert users.empty?
  end

  test 'self find by email and subdomain' do
    @user = Fabricate(:job).user
    institution = @user.institutions.first
    located = User.find_by_email_and_subdomain(
      @user.email, institution.identification
    )

    assert_equal @user, located
    assert_nil User.find_by_email_and_subdomain(@user.email, 'no-institution')
  end

  test 'self find for authentication' do
    @user = Fabricate(:job).user
    institution = @user.institutions.first
    located = User.find_for_authentication(
      email: @user.email, subdomains: [institution.identification]
    )

    assert_equal @user, located

    located = User.find_for_authentication(
      email: @user.email, subdomains: ['admin']
    )

    assert_equal @user, located
    assert_nil User.find_for_authentication(
      email: @user.email, subdomains: ['no-institution']
    )

    @user.update(role: :normal)
    # No longer admin...
    assert_equal @user, User.find_for_authentication(
      email: @user.email, subdomains: ['admin']
    )

    # With no jobs
    @user.jobs.destroy_all
    assert_equal 0, @user.jobs.reload.count
    assert_nil User.find_for_authentication(
      email: @user.email, subdomains: ['admin']
    )
  end

  test 'kin relations' do
    Fabricate(:kinship, user_id: @user.id)

    assert_equal 1, @user.kinships.count
    assert_equal 1, @user.relatives.first.dependents.count
    assert_not_equal @user, @user.relatives.first
    assert_equal @user, @user.relatives.first.dependents.first
  end
end
