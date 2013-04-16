class ActionDispatch::Routing::Mapper
  def draw(scope, routes_name)
    instance_eval File.read(Rails.root.join("config/routes/#{scope}/#{routes_name}.rb"))
  end
end

Libreduca::Application.routes.draw do
  constraints(AdminSubdomain) do
    draw :common, :launchpad
    draw :common, :question
    draw :admin,  :teach
    draw :common, :course
    draw :common, :grade
    draw :admin,  :region
    draw :admin,  :institution
    draw :common, :devise
    draw :admin,  :user
    draw :common, :file
    draw :common, :router

    root to: redirect('/users/sign_in')
  end

  constraints(SchoolSubdomain) do
    draw :common, :launchpad
    draw :school, :chart
    draw :school, :image
    draw :common, :question
    draw :school, :teach
    draw :school, :content
    draw :common, :course
    draw :common, :grade
    draw :school, :forum
    draw :school, :news
    draw :school, :comment
    draw :school, :institution
    draw :school, :group
    draw :school, :tag
    draw :school, :dashboard
    draw :common, :devise
    draw :school, :user
    draw :common, :file
    draw :common, :router
    draw :school, :survey

    root to: 'router#index'
  end

  draw :common, :'404'
end
