class ActionDispatch::Routing::Mapper
  def draw scope, routes_name
    instance_eval File.read(Rails.root.join("config/routes/#{scope}/#{routes_name}.rb"))
  end
end

Libreduca::Application.routes.draw do
  draw :common, :launchpad
  draw :common, :question
  draw :common, :course
  draw :common, :grade
  draw :common, :devise
  draw :common, :file
  draw :common, :router
  draw :common, :enrollments

  constraints AdminSubdomain do
    draw :admin,  :teach
    draw :admin,  :region
    draw :admin,  :institution
    draw :admin,  :user
  end

  constraints SchoolSubdomain do
    draw :school, :chart
    draw :school, :image
    draw :school, :teach
    draw :school, :content
    draw :school, :forum
    draw :school, :news
    draw :school, :comment
    draw :school, :institution
    draw :school, :group
    draw :school, :tag
    draw :school, :dashboard
    draw :school, :user
    draw :school, :survey
  end

  root to: 'router#index'
end
