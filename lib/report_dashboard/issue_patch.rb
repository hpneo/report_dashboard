require_dependency 'issue'

module ReportDashboard
  module IssuePatch
    def self.included(base)
      base.class_eval do
        unloadable

        def self.by_status(project)
          count_and_group_by(:project => project,
                             :field => 'status_id',
                             :joins => IssueStatus.table_name)
        end
      end
    end
  end
end

unless Issue.included_modules.include? ReportDashboard::IssuePatch
  Issue.send(:include, ReportDashboard::IssuePatch)
end