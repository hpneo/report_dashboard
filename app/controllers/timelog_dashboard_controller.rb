class TimelogDashboardController < ApplicationController
  unloadable

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
end