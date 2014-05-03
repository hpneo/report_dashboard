require File.dirname(__FILE__) + '/../helpers/report_dashboard_helper'
include ReportDashboardHelper

class ReportDashboardController < ApplicationController
  unloadable

  before_filter :load_fields

  def index
    @projects = Project.all

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

    @project_issues_by_tracker = IssueReport.by(:tracker, @projects.first).inject({}) do |hash, (tracker_id, datum)|
      hash[@trackers[tracker_id]] = datum
      hash
    end
    @project_issues_by_status = IssueReport.by(:status, @projects.first).inject({}) do |hash, (status_id, datum)|
      hash[@statuses[status_id]] = datum
      hash
    end
    @project_issues_by_priority = IssueReport.by(:priority, @projects.first).inject({}) do |hash, (priority_id, datum)|
      hash[@priorities[priority_id]] = datum
      hash
    end
  end

  def show
    @project = Project.find(params[:project_id])

    @project_issues_by_tracker = IssueReport.by(:tracker, @project).inject({}) do |hash, (tracker_id, datum)|
      hash[@trackers[tracker_id]] = datum
      hash
    end
    @project_issues_by_status = IssueReport.by(:status, @project).inject({}) do |hash, (status_id, datum)|
      hash[@statuses[status_id]] = datum
      hash
    end
    @project_issues_by_priority = IssueReport.by(:priority, @project).inject({}) do |hash, (priority_id, datum)|
      hash[@priorities[priority_id]] = datum
      hash
    end

    render json: {
      project_issues_by_tracker: donut_data(@project_issues_by_tracker),
      project_issues_by_status: donut_data(@project_issues_by_status),
      project_issues_by_priority: donut_data(@project_issues_by_priority)
    }
  end

  private

  def load_fields
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
  end
end
