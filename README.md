# ReportDashboard plugin

## Creation steps

`RAILS_ENV=production ruby script/rails generate redmine_plugin ReportDashboard`

`RAILS_ENV=production ruby script/rails generate redmine_plugin_controller ReportDashboard report_dashboard index`

## Mock data for issues (Capybara is required)

```ruby
require 'capybara'
require 'capybara/rails'

include Capybara::DSL
visit('/login')

fill_in('Login', with: 'admin')
fill_in('Password', with: 'admin')
click_button('Login')

visit('/projects/proyecto-de-prueba-8/issues/new')

trackers = [
  "Errores",
  "Tareas",
  "Soporte",
  "Tracker caprichoso"
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
  if Random.rand(1..100) > 50
    statuses.each do |status|
      if Random.rand(1..100) > 50
        priorities.each do |priority|
          if Random.rand(1..100) > 50
            select(tracker, from: 'Tracker')
            fill_in('Subject', with: "#{tracker} #{status} con prioridad #{priority}")
            select(status, from: 'Status')
            select(priority, from: 'Priority')
            click_button('Create and continue')
          end
        end
      end
    end
  end
end
```

## Mock data for time entries (Capybara is required)

```ruby
require 'capybara'
require 'capybara/rails'

include Capybara::DSL
visit('/login')

fill_in('Login', with: 'admin')
fill_in('Password', with: 'admin')
click_button('Login')

project = Project.find('proyecto-de-prueba')
issues = project.issues

issues.each do |issue|
  visit("/issues/#{issue.id}/time_entries/new")
  fill_in('Hours', with: Random.rand(1..10))
  select('Desarrollo', from: 'Activity')
  click_button('Create and continue')
end
```