module Users
  module Jobs
    extend ActiveSupport::Concern

    included do
      has_many :jobs, -> { where active: true }, dependent: :destroy
      has_many :institutions, through: :jobs

      accepts_nested_attributes_for :jobs, allow_destroy: true,
        reject_if: ->(attributes) {
          attributes['job'].blank? && attributes['institution_id'].blank?
        }
    end

    def has_job_in?(institution)
      self.institutions.exists?(institution.id)
    end

    def drop_job_in(institution)
      self.jobs.in_institution(institution).first.tap do |job|
        if job
          job.active = false; job.save!
        end
      end
    end
  end
end
