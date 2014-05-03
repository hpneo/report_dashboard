ActionDispatch::Callbacks.to_prepare do
  require_dependency 'report_dashboard/issue_patch'
end

Redmine::Plugin.register :report_dashboard do
  name 'Report Dashboard plugin'
  author 'Gustavo Leon'
  description 'Global report dashboard for Redmine'
  version '0.0.1'
  url 'http://github.com/hpneo'
  author_url 'http://hpneo.github.io'

  permission :view_report_dashboard, :report_dashboard => :index
  menu :top_menu, :report_dashboard, { :controller => 'report_dashboard', :action => 'index' }, :caption => 'Report Dashboard'
  menu :top_menu, :timelog_dashboard, { :controller => 'timelog_dashboard', :action => 'index' }, :caption => 'Timelog Dashboard'
end
