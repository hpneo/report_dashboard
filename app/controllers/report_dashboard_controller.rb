class ReportDashboardController < ApplicationController
  unloadable

  def index
    @projects = Project.all
    @trackers = Tracker.all.inject({}) do |hash, tracker|
      hash[tracker.id] = tracker.name
      hash
    end
    @statuses = IssueStatus.all.inject({}) do |hash, tracker|
      hash[tracker.id] = tracker.name
      hash
    end
    @priorities = IssuePriority.all.inject({}) do |hash, tracker|
      hash[tracker.id] = tracker.name
      hash
    end

    @issues_by_tracker = IssueReport.all_by(:tracker, @projects).inject({}) do |hash, (tracker_id, datum)|
      hash[@trackers[tracker_id]] = datum
      hash
    end

    @issues_by_status = IssueReport.all_by(:status, @projects).inject({}) do |hash, (status_id, datum)|
      hash[@statuses[status_id]] = datum
      hash
    end

    @issues_by_priority = IssueReport.all_by(:priority, @projects).inject({}) do |hash, (priority_id, datum)|
      hash[@priorities[priority_id]] = datum
      hash
    end
  end
end
