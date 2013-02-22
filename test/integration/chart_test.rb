require 'test_helper'

class ChartTest < ActionDispatch::IntegrationTest
  test 'should interact with chart' do
    institution = Fabricate(:institution)
    job1 = Fabricate(:job, institution_id: institution.id)

    10.times do
      job2 = Fabricate(:job, institution_id: institution.id)

      Fabricate(
        :kinship,
        user_id: job2.user_id,
        relative_id: job1.user_id,
        kin: Kinship::CHART_KINDS.sample
      )
    end

    Capybara.app_host = "http://#{institution.identification}.lvh.me:54163"

    visit chart_path

    assert page.has_css?('.users-row')
    assert page.has_no_css?('[data-kinship-container] .users-row')

    find("a[data-user=\"#{job1.user_id}\"]").click

    assert page.has_css?('[data-kinship-container] .users-row')
  end
end
