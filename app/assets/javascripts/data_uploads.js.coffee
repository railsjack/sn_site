# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#du_start_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true

  $('#du_end_date').datetimepicker
    format:'m/d/Y'
    timepicker: false,
    closeOnDateSelect: true

  $('#new_appt_employee').select2()
  $('#new_appt_lovedone').select2()

  $('#new_appt_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    onChangeDateTime: (dp, input) ->
      $(input).datetimepicker('hide')

  $('#new_appt_start_datetime').datetimepicker
    format:'H:i',
    timepicker: true
    datepicker: false
    step: 30
    defaultTime: '07:00'

  $('#new_appt_start_datetime' ).on 'change', ->
    $('#new_appt_end_datetime').datetimepicker
      format:'H:i'
      timepicker: true
      datepicker: false
      step: 30
      defaultTime: $(this).val()

  $('#new_appointment').on 'click', ->
    $('#newEncounterModal').modal
      backdrop: 'static'
      keyboard: false
      show: true

  $('.new_appt_cancel_button').on 'click', ->
    $('#new_appt_employee').select2('val', '')
    $('#new_appt_lovedone').select2('val', '')
    $('#new_appt_date').val('')
    $('#new_appt_start_datetime').val('')
    $('#new_appt_end_datetime').val('')

  $('#new_appt_add_button').on 'click', ->
    employee = $('#new_appt_employee').val()
    lovedone = $('#new_appt_lovedone').val()
    date = $('#new_appt_date').val()
    start_time = $('#new_appt_start_datetime').val()
    end_time = $('#new_appt_end_datetime').val()
    if employee == 'none'
      alert 'Please Select Employee'
      return
    else if lovedone == 'none'
      alert 'Please Select Loved One'
      return
    else if date == ''
      alert 'Please Select Date'
      return
    else if start_time == ''
      alert 'Please Select Start Date and Time'
      return
    else if end_time == ''
      alert 'Please Select End Date and Time'
      return

    $.ajax
      url: '/data_uploads/add_appointment'
      dataType: 'script'
      type: 'POST'
      data:
        employee_id: employee
        lovedone_id: lovedone
        date: date
        start_datetime: start_time
        end_datetime: end_time

  $('#pr_drive').on 'click', ->
    if $('#pr_drive').is(':checked')
      $('#pr_drive_time_based').attr('disabled', false)
      $('#pr_drive_mileage_based').attr('disabled', false)
      $('#pr_base_first_last').attr('disabled', false)
      $('#pr_face_to_face').attr('checked', false)
    else
      $('#pr_drive_time_based').attr('disabled', true)
      $('#pr_drive_mileage_based').attr('disabled', true)
      $('#pr_base_first_last').attr('disabled', true)
      $('#pr_drive_time_based').attr('checked', false)
      $('#pr_drive_mileage_based').attr('checked', false)
      $('#pr_base_first_last').attr('checked', false)

  $('#pr_face_to_face').on 'click', ->
    $('#pr_drive').attr('checked', false)
    $('#pr_drive_time_based').attr('disabled', true)
    $('#pr_drive_mileage_based').attr('disabled', true)
    $('#pr_base_first_last').attr('disabled', true)
    $('#pr_drive_time_based').attr('checked', false)
    $('#pr_drive_mileage_based').attr('checked', false)
    $('#pr_base_first_last').attr('checked', false)


  $('#payroll_upload_preview').on 'click', ->
    scroll_position = $('.dataTables_scrollBody').scrollTop()
    start_date = $('#du_start_date').val()
    end_date = $('#du_end_date').val()
    pr_f2f = $('#pr_face_to_face').is(':checked')
    pr_dtb = $('#pr_drive_time_based').is(':checked')
    pr_dmb = $('#pr_drive_mileage_based').is(':checked')
    pr_base_first_last = $('#pr_base_first_last').is(':checked')
    option_check = pr_f2f || pr_dtb || pr_dmb
    if start_date == ''
      alert('Please select start date')
    else if end_date == ''
      alert('Please select end date')
    else if !(option_check)
      alert 'Please select an export option.'
    else
      $('#billing_upload_preview').addClass('btn-success')
      $('#billing_upload_preview').removeClass('btn-info')
      $('#payroll_upload_preview').removeClass('btn-success')
      $('#payroll_upload_preview').addClass('btn-info')
      $.ajax
        url: '/data_uploads/data_upload_preview'
        dataType: 'script'
        type: 'GET'
        data:
          start_date: start_date
          end_date: end_date
          pr_f2f: pr_f2f
          pr_dtb: pr_dtb
          pr_dmb: pr_dmb
          pr_b_f_l: pr_base_first_last
          type: 'payroll'
        success: (data) ->
          $('#data_upload_table').DataTable
            scrollY: "260px",
            scrollX: true,
            order: [[2, "asc"], [1, "asc"]]
            searching: false,
            paging: false,
            info: false
          if scroll_position != null
            $('div.dataTables_scrollBody').scrollTop(scroll_position)


  $('#billing_upload_preview').on 'click', ->
    scroll_position = $('.dataTables_scrollBody').scrollTop()
    start_date = $('#du_start_date').val()
    end_date = $('#du_end_date').val()
    bl_f2f = $('#bl_face_to_face').is(':checked')
    option_check = bl_f2f
    if start_date == ''
      alert('Please select start date')
    else if end_date == ''
      alert('Please select end date')
    else if !(option_check)
      alert 'Please select an export option.'
    else
      $('#billing_upload_preview').removeClass('btn-success')
      $('#billing_upload_preview').addClass('btn-info')
      $('#payroll_upload_preview').addClass('btn-success')
      $('#payroll_upload_preview').removeClass('btn-info')
      $.ajax
        url: '/data_uploads/data_upload_preview'
        dataType: 'script'
        type: 'GET'
        data:
          start_date: start_date
          end_date: end_date
          bl_f2f: bl_f2f
          type: 'billing'
        success: (data) ->
          $('#data_upload_table').DataTable
            scrollY: "250px",
            scrollX: true,
            order: [[2, "asc"], [1, "asc"]]
            searching: false,
            paging: false,
            info: false
          if scroll_position != null
            $('div.dataTables_scrollBody').scrollTop(scroll_position)
