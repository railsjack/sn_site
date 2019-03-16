class DataImportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_company, only: [:employees, :lovedones, :import_employees, :import_lovedones]

  def employees
    authorize! :read, DataImportsController
    @employees_import = EmployeeImport.where(company_id: @company.id)
  end

  def lovedones
    authorize! :read, DataImportsController
    @lovedones_import = LovedoneImport.where(company_id: @company.id)
  end

  def import_employees
    service_provider_id = @company.id
    company_params = params[:company]
    @company.update(employee_spoke: company_params[:employee_spoke])
    formats = [".csv", ".xls", ".xlsx"]
    if formats.include?(File.extname(company_params[:document].original_filename))
      if @company.employee_spoke.present? and ApplicationHelper::EMPLOYEE_SPOKES[@company.employee_spoke - 1].first.downcase.eql? 'axxess'
        employees = Employee.axxess_import(company_params[:document], service_provider_id)
      end
      if EmployeeImport.count > 0
        redirect_to employees_data_imports_path, notice: 'Employees have been uploaded successfully.'
      else
        redirect_to employees_data_imports_path, alert: 'No new or updated Employees found.'
      end
    else
      redirect_to employees_data_imports_path, alert: 'This file format is not supported.'
    end
  end

  def confirm_temp_employees
    params.permit!
    params['employee'].keys.each do |id|
      @employee = EmployeeImport.find(id.to_i)
      @employee.update_attributes(params['employee'][id].delete_if { |k, v| v.empty? })
      existing = Employee.where(email: @employee.email)
      if existing.count > 0
        existing.first.update(@employee.attributes.except('status', 'id', 'created_at', 'updated_at'))
      else
        Employee.create(@employee.attributes.except('status', 'id', 'created_at', 'updated_at'))
      end
      @employee.delete
    end
    redirect_to employees_data_imports_path, notice: 'Employees imported successfully'
  end

  def cancel_temp_employees
    if EmployeeImport.destroy_all
      redirect_to employees_data_imports_path, notice: 'Import has been cancelled successfully.'
    else
      redirect_to employees_data_imports_path, alert: 'Import does not cancelled due to system error.'
    end
  end

  def confirm_temp_lovedones
    params.permit!
    params['lovedone'].keys.each do |id|
      @lovedone = LovedoneImport.find(id.to_i)
      @lovedone.update_attributes(params['lovedone'][id].delete_if { |k, v| v.empty? })
      existing = Lovedone.where(email: @lovedone.email, first_name: @lovedone.first_name, last_name: @lovedone.last_name, date_of_birth: @lovedone.date_of_birth)
      if existing.count > 0
        existing.first.update(@lovedone.attributes.except('status', 'id', 'created_at', 'updated_at'))
      else
        Lovedone.create(@lovedone.attributes.except('status', 'id', 'created_at', 'updated_at'))
      end
      @lovedone.delete
    end
    redirect_to lovedones_data_imports_path, notice: 'Loved ones imported successfully'
  end

  def import_lovedones
    service_provider_id = @company.id
    company_params = params[:company]
    @company.update(lovedone_spoke: company_params[:lovedone_spoke])
    formats = [".csv", ".xls", ".xlsx"]
    if formats.include?(File.extname(company_params[:document].original_filename))
      if @company.lovedone_spoke.present? and ApplicationHelper::LOVEDONE_SPOKES[@company.lovedone_spoke - 1].first.downcase.eql? 'axxess'
        employees = Lovedone.axxess_import(company_params[:document], service_provider_id)
      end
      if LovedoneImport.count > 0
        redirect_to lovedones_data_imports_path, notice: 'Loved ones have been uploaded successfully.'
      else
        redirect_to lovedones_data_imports_path, alert: 'No new or updated loved ones found.'
      end
    else
      redirect_to lovedones_data_imports_path, alert: 'This file format is not supported.'
    end
  end

  def cancel_temp_lovedones
    if LovedoneImport.destroy_all
      redirect_to lovedones_data_imports_path, notice: 'Import has been cancelled successfully.'
    else
      redirect_to lovedones_data_imports_path, alert: 'Import does not cancelled due to system error.'
    end
  end

  def spoke_changes
    company = current_user.company
    spoke = params[:spoke]
    type = params[:type]
    if type.eql? 'employee'
      company.update(employee_spoke: spoke)
    elsif type.eql? 'lovedone'
      company.update(lovedone_spoke: spoke)
    end
    render nothing: true
  end


  private
  def set_company
    @company = current_user.company
  end

end
