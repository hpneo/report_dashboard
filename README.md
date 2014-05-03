= ReportDashboard plugin

`RAILS_ENV=production ruby script/rails generate redmine_plugin ReportDashboard`

`RAILS_ENV=production ruby script/rails generate redmine_plugin_controller ReportDashboard report_dashboard index`

= Mock data for issues (Capybara is required)

```ruby
require 'capybara'
require 'capybara/rails'

include Capybara::DSL
visit('/login')

fill_in('Login', with: 'admin')
fill_in('Password', with: 'admin')
click_button('Login')

visit('/projects/proyecto-de-prueba/issues/new')

trackers = [
  "Errores",
  "Tareas",
  "Soporte"
]

statuses = [
  "Nueva",
  "En curso",
  "Resuelta",
  "Comentarios",
  "Cerrada",
  "Rechazada"
]

priorities = [
  "Baja",
  "Normal",
  "Alta",
  "Urgente",
  "Inmediata"
]

trackers.each do |tracker|
  statuses.each do |status|
    priorities.each do |priority|
      select(tracker, from: 'Tracker')
      fill_in('Subject', with: "#{tracker} #{status} con prioridad #{priority}")
      select(status, from: 'Status')
      select(priority, from: 'Priority')
      click_button('Create and continue')
    end
  end
end
```