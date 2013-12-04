namespace :epilady do
  desc 'Removes institutions with associated models'

  task pluck: :environment do
    PaperTrail.enabled = false
    ActiveRecord::Base.lock_optimistically = false
    ActiveRecord::Base.logger = nil

    identifications = ['cirope', 'um-ing', 'undec-sistemas', 'utn-frm']

    Institution.where(identification: identifications).map(&:destroy)
  end
end
