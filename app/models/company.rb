class Company
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def projects
    @projects ||= ProjectCustomField.where(name: 'Empresa').first.custom_values.where(customized_type: 'Project', value: self.name).map(&:customized)
  end
end