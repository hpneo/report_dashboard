require File.dirname(__FILE__) + '/../helpers/report_dashboard_helper'
include ReportDashboardHelper

class ReportDashboardController < ApplicationController
  unloadable

  before_filter :load_fields

  def by_company
    @company = Company.new(params[:company_id])
    @projects = @company.projects

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

    render partial: 'report_dashboard/by_company', layout: false if params[:layout].present?
  end

  def by_project
    project = Project.find(params[:project_id])

    @issues_by_tracker = IssueReport.by(:tracker, project).inject({}) do |hash, (tracker_id, datum)|
      hash[@trackers[tracker_id]] = datum
      hash
    end
    @issues_by_status = IssueReport.by(:status, project).inject({}) do |hash, (status_id, datum)|
      hash[@statuses[status_id]] = datum
      hash
    end
    @issues_by_priority = IssueReport.by(:priority, project).inject({}) do |hash, (priority_id, datum)|
      hash[@priorities[priority_id]] = datum
      hash
    end

    render partial: 'report_dashboard/by_project', layout: false if params[:layout].present?
  end

  def index
    params[:company_id] ||= company_values.first
    by_company
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
