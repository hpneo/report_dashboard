Redmine::Plugin.register :report_dashboard do
  name 'Report Dashboard plugin'
  author 'Gustavo Leon'
  description 'Global report dashboard for Redmine'
  version '0.0.1'
  url 'http://github.com/hpneo'
  author_url 'http://hpneo.github.io'

  permission :view_report_dashboard, :report_dashboard => :index
  menu :top_menu, :report_dashboard, { :controller => 'report_dashboard', :action => 'index' }, :caption => 'Report Dashboard'
end
