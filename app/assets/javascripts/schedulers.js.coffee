# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  checkEmployee = () ->
    if($('#employee_id').length > 0)
      employee_id = $('#employee_id').data('employee-id');
      setTimeout ->
        $('#employee_cal').addClass('hidden')
        $('#lovedone_cal').addClass('hidden')
        $('#employee_calendar').val(employee_id).change();
      , 200
    else
      $('#appointment_selection').removeClass('hidden')

  $('#employee_calendar').select2()
  $('#lovedone_calendar').select2()

  setTimeout (->
    $('.scheduler_option:first').trigger('click')
    checkEmployee()
    return
  )

  $('.reloading_events_button').on 'click', ->
    $('#calendar').fullCalendar('refetchEvents')

  $('#employee_calendar').on 'change', ->
    employeeId = $(this).val()
    $('#scheduler_calendar').addClass('hidden')
    $('#scheduler_calendar').removeClass('hidden')
    $('.reloading_events_button').removeClass('hidden')
    $.ajax
      url: '/schedulers/scheduler_calendar'
      dataType: 'script'
      type: 'GET'
      data:
        employee_id: employeeId
    return

  $('#lovedone_calendar').on 'change', ->
    lovedoneId = $(this).val()
    $('#scheduler_calendar').addClass('hidden')
    $('#scheduler_calendar').removeClass('hidden')
    $('.reloading_events_button').removeClass('hidden')
    $.ajax
      url: '/schedulers/scheduler_calendar'
      dataType: 'script'
      type: 'GET'
      data:
        lovedone_id: lovedoneId
    return

  $('.scheduler_option').on 'click', ->
    checkEmployee()
    optionType = $(this).val()
    $('#mode_text').html('View Mode')
    $('#new_schedule_employee').select2("val", ' ')
    $('#new_sch').addClass('hidden')
    if optionType == 'company'
      $('#employee_cal').addClass('hidden')
      $('#employee_calendar').select2("val", ' ')
      $('#lovedone_cal').addClass('hidden')
      $('#lovedone_calendar').select2("val", ' ')
      $('#scheduler_calendar').removeClass('hidden')
      $.ajax
        url: '/schedulers/scheduler_calendar'
        dataType: 'script'
        type: 'GET'
        data:
          company_id: 'all'
      return
    if optionType == 'employee'
      $('#employee_cal').removeClass('hidden')
      $('.reloading_events_button').addClass('hidden')
      $('#lovedone_cal').addClass('hidden')
      $('#lovedone_calendar').select2("val", ' ')
      $('#employee_calendar').select2("val", ' ')
      $('#scheduler_calendar').addClass('hidden')
      return
    if optionType == 'lovedone'
      $('#employee_cal').addClass('hidden')
      $('.reloading_events_button').addClass('hidden')
      $('#employee_calendar').select2("val", ' ')
      $('#lovedone_calendar').select2("val", ' ')
      $('#lovedone_cal').removeClass('hidden')
      $('#scheduler_calendar').addClass('hidden')
      return

    return
$ ->
  $('.transfer-date').datepicker
    'dateFormat': 'mm/dd/yy'
    yearRange: '1900:' + (new Date).getFullYear()
    changeMonth: true
    changeYear: true
    showButtonPanel: true
    currentText: '',
    minDate: 0,
    closeText: 'Done'
    onChangeMonthYear: (year, month, instance) ->
      d = if instance.currentDay > 0 then instance.currentDay else 1
      instance.input.get(0).value = month + '/' + d + '/' + year
      return

  $('#transfer_employee').select2();

$(document).on 'click', '#transfer_preview_button', ->
  if $('#transfer_employee').val() == 'none' && $('#employee_user').length < 1
    alert 'Please Select Employee'
    return false
  else if $('#transfer_start_date').val() == ''
    alert 'Please Select Start Date'
    return false
  else if $('#transfer_end_date').val() == ''
    alert 'Please Select End Date'
    return false

  split_start_date = $('#transfer_start_date').val().split('/')
  split_end_date = $('#transfer_end_date').val().split('/')
  start_date = split_start_date[2] + '-' + split_start_date[0] + '-' + split_start_date[1]
  end_date = split_end_date[2] + '-' + split_end_date[0] + '-' + split_end_date[1]

  $.ajax
    url: '/transfer_appointments/preview'
    dataType: 'script'
    type: 'GET'
    data:
      start_date: start_date
      end_date: end_date
      employee_id: $('#transfer_employee').val()
  return

$(document).on 'change', '#transfer_end_date', ->
  if $('#transfer_start_date').val() != ''
    split_start_date = $('#transfer_start_date').val().split('/')
    split_end_date = $('#transfer_end_date').val().split('/')
    start_date = split_start_date[2] + '-' + split_start_date[0] + '-' + split_start_date[1]
    end_date = split_end_date[2] + '-' + split_end_date[0] + '-' + split_end_date[1]
    $.ajax
      url: '/transfer_employees'
      dataType: 'script'
      type: 'GET'
      data:
        start_date: start_date
        end_date: end_date
    return

$(document).on 'change', '#transfer_start_date', ->
  if $('#transfer_end_date').val() != ''
    split_start_date = $('#transfer_start_date').val().split('/')
    split_end_date = $('#transfer_end_date').val().split('/')
    start_date = split_start_date[2] + '-' + split_start_date[0] + '-' + split_start_date[1]
    end_date = split_end_date[2] + '-' + split_end_date[0] + '-' + split_end_date[1]
    $.ajax
      url: '/transfer_employees'
      dataType: 'script'
      type: 'GET'
      data:
        start_date: start_date
        end_date: end_date
    return