module Surveys::CurrentCheck
  extend ActiveSupport::Concern

  included do
    delegate :past?, to: :teach

    before_save :check_past_teach
  end

  def check_past_teach
    raise 'You can not do this' if past?
  end
end
