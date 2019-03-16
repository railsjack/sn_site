# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#sponsor_selection').select2 width: '400px'

  $('#sponsor_selection').on 'change', ->
    company_id = $(this).val()
    if company_id == 'none'
      $('#sponsor_type_fields').addClass 'hidden'
    else
      $('#sponsor_type_fields').removeClass 'hidden'
      $.ajax
        url: '/fees/sp_fees_fields'
        dataType: 'script'
        type: 'GET'
        data:
          company_id: company_id

#  $('#sponsor_state').select2()
#  $('#sponsor_county').select2()
#  $('#sponsor_nation').select2()
#  $('#sponsor_company_id').select2()

  $('#sponsor_start_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true
  $('#sponsor_end_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true


  $('#sponsor_state option').css 'color', 'green'
  $('#sponsor_state option:disabled').css 'color', 'red'
  $('#sponsor_state option:disabled').prop 'disabled', false

  $('#sponsor_company_id option').css 'color', 'green'
  $('#sponsor_company_id option:disabled').css 'color', 'red'

  if $('#sponsor_nation').val() != 'undefined'
    if $('#sponsor_nation').val() == 'State'
      $('#spon_state').removeClass 'hidden'
      $('#spon_specific').addClass 'hidden'
    else if $('#sponsor_nation').val() == 'County'
      $('#spon_state').removeClass 'hidden'
      $('#spon_county').removeClass 'hidden'
      $('#spon_specific').addClass 'hidden'
    else if $('#sponsor_nation').val() == 'National'
      $('#spon_state').addClass 'hidden'
      $('#spon_county').addClass 'hidden'
      $('#spon_specific').addClass 'hidden'
    else if $('#sponsor_nation').val() == 'Specific'
      $('#spon_state').addClass 'hidden'
      $('#spon_county').addClass 'hidden'
      $('#spon_specific').removeClass 'hidden'

  $('#sponsor_nation').on 'change', ->
    if $('#sponsor_nation').val() == 'State'
      $('#spon_state').removeClass 'hidden'
      $('#spon_county').addClass 'hidden'
      $('#spon_specific').addClass 'hidden'
      $('#sponsor_company_id').val('')
      $('#sponsor_county').val('')
    else if $('#sponsor_nation').val() == 'County'
      $('#spon_state').removeClass 'hidden'
      $('#spon_county').removeClass 'hidden'
      $('#spon_specific').addClass 'hidden'
      $('#sponsor_company_id').val('')
    else if $('#sponsor_nation').val() == 'National'
      $('#spon_state').addClass 'hidden'
      $('#spon_county').addClass 'hidden'
      $('#spon_specific').addClass 'hidden'
      $('#sponsor_company_id').val('')
      $('#sponsor_county').val('')
      $('#sponsor_state').val('')
    else if $('#sponsor_nation').val() == 'Specific'
      $('#spon_state').addClass 'hidden'
      $('#spon_county').addClass 'hidden'
      $('#spon_specific').removeClass 'hidden'
      $('#sponsor_state').val('')
      $('#sponsor_county').val('')

  $('#sponsor_submit').on 'click', ->
    if $('#sponsor_nation').val() == 'State'
      if $('#sponsor_state').val() == ""
        alert 'Please Select State'
        return false
    else if $('#sponsor_nation').val() == 'County'
      if $('#sponsor_county').val() == ""
        alert 'Please Select County'
        return false
    else if $('#sponsor_nation').val() == 'Specific'
      if $('#sponsor_company_id').val() == ""
        alert 'Please Select Provider'
        return false
    else if $('#sponsor_nation').val() == ""
      alert 'Please Select Sponsor Type'
      return false


