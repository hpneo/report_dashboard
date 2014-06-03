ActionDispatch::Callbacks.to_prepare do
  require_dependency 'report_dashboard/issue_patch'
end

Redmine::Plugin.register :report_dashboard do
  name 'Report Dashboard plugin'
  author 'Gustavo Leon'
  description 'Global report dashboard for Redmine'
  version '0.1.0'
  url 'http://github.com/hpneo/report_dashboard'
  author_url 'http://hpneo.github.io'

  permission :view_report_dashboard, report_dashboard: :index
  menu :top_menu, :report_dashboard, { controller: 'report_dashboard', action: 'index' }, caption: 'Dashboard', if: Proc.new { User.current.allowed_to?(:view_report_dashboard, nil, global: true) }
end
