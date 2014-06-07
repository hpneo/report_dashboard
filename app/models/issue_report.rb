class IssueReport
  def self.by(field, project)
    method = "by_#{field}".to_sym
    id = "#{field}_id"
    project_data = {}
    data = Issue.send(method, project) || []

    grouped_data = data.group_by{|d| d[id] }

    grouped_data.each do |key, grouped_datum|
      project_data[key] ||= {}

      grouped_datum.each do |datum|
        if datum["closed"] == 1
          project_data[key]["closed"] ||= 0
          project_data[key]["closed"] += datum["total"]
        else
          project_data[key]["opened"] ||= 0
          project_data[key]["opened"] += datum["total"]
        end
      end

      project_data[key]["closed"] ||= 0
      project_data[key]["opened"] ||= 0
      project_data[key]["total"] = project_data[key]["closed"] + project_data[key]["opened"]
    end

    project_data
  end

  def self.all_by(field, projects = Project.all)
    method = "by_#{field}".to_sym
    id = "#{field}_id"
    global_data = {}

    projects.each do |project|
      project_data = Issue.send(method, project) || []
      grouped_project_data = project_data.group_by{|d| d[id] }

      grouped_project_data.each do |key, grouped_datum|
        global_data[key] ||= {}

        grouped_datum.each do |datum|
          if datum["closed"] == 1
            global_data[key]["closed"] ||= 0
            global_data[key]["closed"] += datum["total"]
          else
            global_data[key]["opened"] ||= 0
            global_data[key]["opened"] += datum["total"]
          end
        end

        global_data[key]["closed"] ||= 0
        global_data[key]["opened"] ||= 0
        global_data[key]["total"] = global_data[key]["closed"] + global_data[key]["opened"]
      end
    end

    global_data
  end
end