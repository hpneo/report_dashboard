class IssueReport
  def self.by(field, project)
    method = "by_#{field}".to_sym
    id = "#{field}_id"
    project_data = {}
    data = Issue.send(method, project) || []

    data.each do |datum|
      datum["opened"] ||= datum["total"].to_i

      project_data[datum[id]] ||= {}
      project_data[datum[id]]["opened"] ||= 0
      project_data[datum[id]]["opened"] += datum["opened"].to_i
      project_data[datum[id]]["closed"] ||= 0
      project_data[datum[id]]["closed"] += datum["closed"].to_i
      project_data[datum[id]]["total"] = project_data[datum[id]]["opened"] + project_data[datum[id]]["closed"]
    end

    project_data
  end

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
        global_data[project_datum[id]]["opened"] += project_datum["opened"].to_i
        global_data[project_datum[id]]["closed"] ||= 0
        global_data[project_datum[id]]["closed"] += project_datum["closed"].to_i
      end
    end

    global_data
  end

  def self.history(projects = Project.all, opened_or_closed = :opened)
    projects.map do |project|
      project_history(project, opened_or_closed)
    end
  end

  def self.project_history(project, opened_or_closed = :opened)
    if opened_or_closed == :opened
      statuses = IssueStatus.where(is_closed: false).pluck(:id)
      date = 'created_on'
    else
      statuses = IssueStatus.where(is_closed: true).pluck(:id)
      date = 'closed_on'
    end

    project.issues.where(status_id: statuses).count(group: ['tracker_id', "date(#{date})"]).inject({}) do |hash, (key, value)|
      hash[key[0]] ||= {}
      hash[key[0]][key[1]] = value

      hash
    end
  end
end