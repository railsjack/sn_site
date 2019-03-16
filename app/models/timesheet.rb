class Timesheet < ActiveRecord::Base
  belongs_to :employee
  belongs_to :lovedone
  belongs_to :provider
  belongs_to :company
  belongs_to :trip
  #Timesheet.updatetimesheet()
  def self.savetimesheet(lovedone_id,employee_id,trip_id)
    employee = Employee.find(employee_id)
    company_id = employee.company.id
    object = Timesheet.new(:starttime => Time.now,
    # :endtime => Time.now,
    :employee_id => employee_id,
    :company_id => company_id,
    :lovedone_id => lovedone_id,
    :trip_id => trip_id)
    object.save
   end
  
  def self.report_by_employee(company, startdate, enddate)
    timesheets = Timesheet.joins(:lovedone, :employee).where(['timesheets.company_id = ? and 
        starttime between ? and ?', company.id, startdate, enddate+1.days]).order(:lovedone_id, :starttime).select('timesheets.*, 
        lovedones.first_name as lovedone_first_name, lovedones.last_name as lovedone_last_name, 
        employees.first_name as emp_first_name, employees.last_name as emp_last_name')
    emps = []
    emp_timesheets = []
    emp_timesheets_sum = 0
    emp_name = ''
    emp_name_db = ''
    timesheets.each do |timesheet|
      emp_name_db = "#{timesheet.emp_first_name} #{timesheet.emp_last_name}"
      unless emp_name == emp_name_db
        unless emp_name == ''
          puts emp_name
          emps << {
            emp_name: emp_name,
            emp_timesheets: emp_timesheets
          }
        end
        emp_name = emp_name_db
        emp_timesheets = []
      end
      emp_timesheets << timesheet
    end
    if emp_name_db!=''
      emps << {
        emp_name: emp_name_db,
        emp_timesheets: emp_timesheets
      }
    end      

    reports = []
    date_timesheets = []
    emps.each do |emp|
      starttime = ''
      sub_timesheets = []
      date_timesheets = []
      emp[:emp_timesheets].each do |timesheet|
        unless starttime == timesheet.starttime.strftime('%Y/%m/%d')
          unless starttime.blank?
            date_timesheets << {
              "#{starttime}" => sub_timesheets
            }
          end
          starttime = timesheet.starttime.strftime('%Y/%m/%d')
          sub_timesheets = []
        end
        sub_timesheets << timesheet
      end
      if starttime != ''
        date_timesheets << {
          "#{starttime}" => sub_timesheets
        }
      end

      reports << {
        emp_name: emp[:emp_name],
        date_timesheets: date_timesheets
      }
    end


    return reports

 end 

 def self.report_by_lovedone(company, startdate, enddate)
    timesheets = Timesheet.joins(:employee, :lovedone).where(['timesheets.company_id = ? and 
        starttime between ? and ?', company.id, startdate, enddate+1.days]).order(:lovedone_id, :starttime).select('timesheets.*, 
        lovedones.first_name as lovedone_first_name, lovedones.last_name as lovedone_last_name, 
        employees.first_name as emp_first_name, employees.last_name as emp_last_name')



    lovedones = []
    lovedone_timesheets = []
    lovedone_timesheets_sum = 0
    lovedone_name = ''
    lovedone_name_db = ''
    timesheets.each do |timesheet|
      lovedone_name_db = "#{timesheet.lovedone_first_name} #{timesheet.lovedone_last_name}"
      unless lovedone_name == lovedone_name_db
        unless lovedone_name == ''
          puts lovedone_name
          lovedones << {
            lovedone_name: lovedone_name,
            lovedone_timesheets: lovedone_timesheets
          }
        end
        lovedone_name = lovedone_name_db
        lovedone_timesheets = []
      end
      lovedone_timesheets << timesheet
    end
    if lovedone_name_db!=''
      lovedones << {
        lovedone_name: lovedone_name_db,
        lovedone_timesheets: lovedone_timesheets
      }
    end      


    return lovedones




 end

  
end
