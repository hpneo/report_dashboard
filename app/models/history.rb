class History
  def self.trackers
    @trackers ||= Tracker.all.inject({}) do |hash, tracker|
      hash[tracker.id] = tracker.name
      hash
    end
  end

  def self.all(projects = Project.all)
    raw_data_opened = projects.map do |project|
      by_project(project, :opened)
    end

    raw_data_closed = projects.map do |project|
      by_project(project, :closed)
    end

    keys_opened = raw_data_opened.map(&:values).flatten.map(&:keys).flatten
    keys_closed = raw_data_closed.map(&:values).flatten.map(&:keys).flatten

    labels_opened = raw_data_opened.map(&:keys).flatten.map { |label| "#{label} (abiertas)" }
    labels_closed = raw_data_closed.map(&:keys).flatten.map { |label| "#{label} (cerradas)" }

    keys = (keys_opened + keys_closed).uniq.sort
    labels = (labels_opened + labels_closed).uniq
    data = {}

    labels.each do |label|
      data[label] ||= {}
    end

    raw_data_opened.each do |raw_datum|
      raw_datum.each do |label, datum|
        keys.each do |key|
          data["#{label} (abiertas)"][key] ||= 0
          data["#{label} (abiertas)"][key] += (datum || {})[key].to_i
        end
      end
    end

    raw_data_closed.each do |raw_datum|
      raw_datum.each do |label, datum|
        keys.each do |key|
          data["#{label} (cerradas)"][key] ||= 0
          data["#{label} (cerradas)"][key] += (datum || {})[key].to_i
        end
      end
    end

    {
      data: data,
      labels: labels,
      keys: keys
    }
  end

  def self.by_project(project, opened_or_closed = :opened)
    if opened_or_closed == :opened
      statuses = IssueStatus.where(is_closed: false).pluck(:id)
      date = 'created_on'
    else
      statuses = IssueStatus.where(is_closed: true).pluck(:id)
      date = 'closed_on'
    end

    project.issues.where(status_id: statuses).count(group: ['tracker_id', "date(#{date})"]).inject({}) do |hash, (key, value)|
      tracker_name = trackers[key[0]]

      hash[tracker_name] ||= {}
      hash[tracker_name][key[1]] = value

      hash
    end
  end
end