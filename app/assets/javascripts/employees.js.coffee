# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready', ->
  $('#lovedone_location').select2()
  $('.service-provider-list').select2()

$ ->
	$('.employees input[name=check1]').click ->
		$('.employees input[name=check1]').prop 'checked', 0
		$(this).prop 'checked', 1
		window.open $(this).parent().attr('href'), '_self'

####### Start of Travel History script
$ ->
  $('.history-date').datetimepicker
    format:'m/d/Y'
    timepicker: false,
    closeOnDateSelect: true,
    onChangeMonth: (current_time,$input) ->
      $input.val(current_time.dateFormat('m/d/Y'));

  $('#employee_selection').select2()

$(document).on 'click', '#generate_result_button', ->
  if $('#employee_selection').val() == 'none'
    alert 'Please Select Employee'
    return false
  else if $('#history_start_date').val() == ''
    alert 'Please Select Start Date'
    return false
  else if $('#history_end_date').val() == ''
    alert 'Please Select End Date'
    return false

  split_start_date = $('#history_start_date').val().split('/')
  split_end_date = $('#history_end_date').val().split('/')
  start_date = split_start_date[2] + '-' + split_start_date[0] + '-' + split_start_date[1]
  end_date = split_end_date[2] + '-' + split_end_date[0] + '-' + split_end_date[1]
  company_data = document.querySelector('#company_travel_history')

  $('.three-quarters-loader').removeClass('hidden')
  $('.no-result').addClass('hidden')
  $.ajax
    url: '/employees/travel_history_results'
    dataType: 'script'
    type: 'GET'
    data:
      emp_id: $('#employee_selection').val()
      cmp_id: company_data.dataset.company
      start_date: start_date
      end_date: end_date

  return

$(document).on 'click', '#show_leg_map', ->
  $.ajax
    url: '/employees/travel_history_map'
    dataType: 'script'
    type: 'GET'
    data:
      start_lat: $(this).data('startlat')
      start_lng: $(this).data('startlng')
      end_lat: $(this).data('endlat')
      end_lng: $(this).data('endlng')
      leg_color: $(this).data('legcolor')
      emp_string: $(this).data('empstring')
  return

$(document).on 'click', '#show_full_day_map', ->
  $.ajax
    url: '/employees/travel_history_map'
    dataType: 'script'
    type: 'GET'
    data:
      emp_id: $(this).data('empid')
      present_date: $(this).data('presentdate')
  return

####### End of Travel History script

$ ->
  $('#tooltip_employee').tooltip()
  return
