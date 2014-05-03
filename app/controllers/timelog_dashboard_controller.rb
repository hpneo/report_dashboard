class TimelogDashboardController < ApplicationController
  unloadable

  def index
    @users = User.all
  end
end