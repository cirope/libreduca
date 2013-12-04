require_relative '../epilady/logger'

namespace :epilady do
  desc 'Removes institutions with associated models'

  task pluck: :environment do
    PaperTrail.enabled = false
    ActiveRecord::Base.lock_optimistically = false
    ActiveRecord::Base.logger = nil

    identifications = ['cirope', 'um-ing', 'undec-sistemas', 'utn-frm']
    institutions = Institution.where(identification: identifications)
    institutions_ids = institutions.map(&:id)

    institutions.map(&:destroy)

    PaperTrail::Version.find_each do |version|
      begin
        model = version.reify

        if model.respond_to?(:institution_id) &&
          institutions_ids.include?(model.institution_id)

          version.destroy
        end
      rescue Exception => e
        Epilady::Logger.log e.message

        version.destroy
      end
    end
  end
end
