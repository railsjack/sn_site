module SchedulersHelper

  def self.find_letter_template(person_type, person, start_date, end_date)
    file_content = nil
    main_data = ''
    if person_type.eql? Lovedone
      Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? and lovedone_id=?", start_date, end_date, person.id).order('start_time ASC').each do |appt|
        main_data += "<tr> <td class='text-center'> #{appt.start_time.strftime('%m-%d-%y')} </td> <td class='text-center'>#{appt.start_time.strftime('%A')}</td> <td class='text-center'> #{appt.start_time.strftime('%H:%M')} - #{appt.end_time.strftime('%H:%M')} </td> <td class='text-center'> #{appt.employee.full_name} </td> <td class='text-center'> #{appt.employee.phone_number} </td> </tr>"
      end
      file_content="<html style='margin: .2in;'>
            <style>
              .font-size-14{
                font-size:18px;
              }
              .font-size-12{
                font-size:14px;
              }
              .text-center{
                text-align:center;
              }
              table tr td{
                border-style: solid;
                border-width:1px;
              }
            </style>
            <p align='center'>
              <strong class='font-size-14'>{{business_name}}</strong><br>
              <strong class='font-size-12'>{{business_address}}</strong><br>
              <strong class='font-size-12'>{{business_city}}, {{business_state}} {{business_zip}}</strong><br>
              <strong class='font-size-12'>{{business_phone}}</strong>
            </p>
            <br>
            <p class='font-size-12'> {{current_date}} </p>
            <p class='font-size-12'>
              {{lovedone_first_last}}<br>
              {{lovedone_address}}<br>
              {{lovedone_city}}, {{lovedone_state}} {{lovedone_zip}}
            </p>
            <p class='font-size-12'> Re: Your Home Health Visit Schedule </p>

            <p class='font-size-12'> Hello {{lovedone_first}}! </p>
            <p class='font-size-12'>
              We have established our upcoming visitation schedule for you between {{start_date}} and {{end_date}}. Below is a summary of when one of our home health caregivers will visit you:
            </p>
              <div class='row' class='font-size-12'>
              <table width='100%' class='font-size-12'>
                <thead> <tr> <th> Date </th> <th> Day </th> <th> Time </th> <th> Caregiver </th><th> Caregiver Phone </th> </tr> </thead>
                <tbody>
                  #{main_data.html_safe}
                </tbody>


              </table>
              </div>
            <p class='font-size-12'>
              {{lovedone_first}}, ideally these appointment times will work for you. If you have a schedule conflict, please contact the caregiver directly to
              modify the appointment.
            </p>

            <p class='font-size-12'>
              We do our very best to be punctual. However, conditions may arise where our caregiver could be a few minutes late. Your understanding in this instance is
              certainly appreciated.
            </p>

            <p class='font-size-12'> Thank you!</p>
        </html>"

    elsif person_type.eql? Follower
      Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? and lovedone_id=?", start_date, end_date, person.lovedone.id).order('start_time ASC').each do |appt|
        main_data += "<tr> <td class='text-center'> #{appt.start_time.strftime('%m-%d-%y')} </td> <td class='text-center'>#{appt.start_time.strftime('%A')}</td> <td class='text-center'> #{appt.start_time.strftime('%H:%M')} - #{appt.end_time.strftime('%H:%M')} </td> <td class='text-center'> #{appt.employee.full_name} </td> <td class='text-center'> #{appt.employee.phone_number} </td> </tr>"
      end
      file_content="<html style='margin: .2in;'>
            <style>
              .font-size-14{
                font-size:18px;
              }
              .font-size-12{
                font-size:14px;
              }
              .text-center{
                text-align:center;
              }
              table tr td{
                border-style: solid;
                border-width:1px;
              }
            </style>
            <p align='center'>
              <strong class='font-size-14'>{{business_name}}</strong><br>
              <strong class='font-size-12'>{{business_address}}</strong><br>
              <strong class='font-size-12'>{{business_city}}, {{business_state}} {{business_zip}}</strong><br>
              <strong class='font-size-12'>{{business_phone}}</strong>
            </p>
            <br>
            <p class='font-size-12'> {{current_date}} </p>
            <p class='font-size-12'>
              {{follower_first_last}}<br>
              {{follower_address}}<br>
              {{follower_city}}, {{follower_state}} {{follower_zip}}
            </p>
            <p class='font-size-12'> Re: Home Health Visit Schedule for {{lovedone_first_last}} </p>

            <p class='font-size-12'> Hello {{follower_first}}! </p>
            <p class='font-size-12'>
              We have established our upcoming visitation schedule for {{lovedone_first}} between {{start_date}} and {{end_date}}. Below is a summary of when one of our home health caregivers will visit {{lovedone_first}}:
            </p>
              <div class='row' class='font-size-12'>
              <table width='100%' class='font-size-12'>
                <thead> <tr> <th> Date </th> <th> Day </th> <th> Time </th> <th> Caregiver </th><th> Caregiver Phone </th> </tr> </thead>
                <tbody>
                  #{main_data.html_safe}
                </tbody>
              </table>
              </div>
            <p class='font-size-12'>
              {{follower_first}}, if you feel {{lovedone_first}} may have a conflict with any of the above-referenced times, please contact the caregiver directly to reschedule.
            </p>

            <p class='font-size-12'>
              We do our very best to be punctual. However, conditions may arise where our caregiver could be a few minutes late. Your understanding in this instance is certainly appreciated.
            </p>

            <p class='font-size-12'> Thank you!</p>
        </html>"
    end
    return file_content
  end

  # def self.render_lovedone_letter_partial
  #   view = ApplicationController.new.view_context
  #   view.render(partial: "share/lovedone_letter_template")
  # end
  #
  # def self.render_follower_letter_partial
  #   view = ApplicationController.new.view_context
  #   view.render(partial: "share/lovedone_letter_template")
  # end
end
