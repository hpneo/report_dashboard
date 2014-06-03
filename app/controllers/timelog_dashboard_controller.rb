class TimelogDashboardController < ApplicationController
  unloadable

  before_filter :check_permissions

  def index
    @users = User.all
    
    @projects = Project.all.inject({}) do |hash, project|
      hash[project.id] = project
      hash
    end

    @time_entries = @users.inject({}) do |hash, user|
      hash[user.id] = TimeEntry.where(user_id: user.id).group(:project_id).sum(:hours)
      hash
    end
  end

  private
  
  def check_permissions
    (render_403; return false) unless User.current.allowed_to?(:view_report_dashboard, nil, global: true)
  end
end