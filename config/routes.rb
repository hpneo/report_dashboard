get 'dashboard', :to => 'report_dashboard#index'
get 'dashboard/by_company', :to => 'report_dashboard#by_company'
get 'dashboard/by_project', :to => 'report_dashboard#by_project'

get 'timelog_dashboard', :to => 'timelog_dashboard#index'