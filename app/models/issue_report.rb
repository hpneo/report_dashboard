class IssueReport
  def self.all_by(field, projects = Project.all)
    method = "by_#{field}".to_sym
    id = "#{field}_id"
    global_data = {}

    projects.each do |project|
      project_data = Issue.send(method, project) || []

      project_data.each do |project_datum|
        project_datum["opened"] ||= project_datum["total"]

        global_data[project_datum[id]] ||= {}
        global_data[project_datum[id]]["opened"] ||= 0
        global_data[project_datum[id]]["opened"] += project_datum["opened"]
        global_data[project_datum[id]]["closed"] ||= 0
        global_data[project_datum[id]]["closed"] += project_datum["closed"]
      end
    end

    global_data
  end
end