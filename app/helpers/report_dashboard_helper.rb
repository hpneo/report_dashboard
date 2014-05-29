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

  def line_categories(history)
    history[:keys]
  end

  def line_data(history)
    data = []

    history[:data].each do |label, history_item|
      datum = {
        name: label,
        data: history_item.values
      }

      data << datum
    end

    data
  end

  def project_values
    @project_values ||= Project.select('name, identifier').map{ |p| [p.name, p.identifier] }
  end

  def company_values
    @company_values ||= ProjectCustomField.where(name: 'Empresa').first.possible_values
  end
end
