# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#sp_fee_selection').select2 width: '400px'
  $('#sponsor_fee_selection').select2 width: '400px'

  $('#sp_fee_selection').on 'change', ->
    company_id = $(this).val()
    if company_id == 'none'
      $('#sp_fees_fields').addClass 'hidden'
    else
      $('#sp_fees_fields').removeClass 'hidden'
      $.ajax
        url: '/fees/sp_fees_fields'
        dataType: 'script'
        type: 'GET'
        data:
          company_id: company_id

  $('#sponsor_fee_selection').on 'change', ->
    sponsor_id = $(this).val()
    if sponsor_id == 'none'
      $('#sponsor_fees_fields').addClass 'hidden'
    else
      $('#sponsor_fees_fields').removeClass 'hidden'
      $.ajax
        url: '/fees/sponsor_fees_fields'
        dataType: 'script'
        type: 'GET'
        data:
          sponsor_id: sponsor_id



