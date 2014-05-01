module ReportDashboardHelper
  def donut_data(report)
    data = []

    report.each do |key, report_datum|
      datum = {}
      datum['y'] = report_datum['opened'] + report_datum['closed']
      datum['name'] = key
      datum['drilldown'] = {
        'name' => "Estados para #{key}",
        'categories' => ['Abiertas', 'Cerradas'],
        'data' => [report_datum['opened'], report_datum['closed']]
      }

      data << datum
    end

    data
  end
end
