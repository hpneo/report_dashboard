get 'report_dashboard', :to => 'report_dashboard#index'
get 'report_dashboard/:project_id', :to => 'report_dashboard#show'

get 'timelog_dashboard', :to => 'timelog_dashboard#index'