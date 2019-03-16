# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'change', '#employee_lovedone_employee_id', ->
  if $(this).val() != ''
    $('#employee_select').hide();
    $('#all_lovedones').removeClass('hidden');
    $('#add_restriction_button').removeClass('hidden');
    $('#restricted_lovedones').removeClass('no-result');
    $.ajax
      url: '/companies/restricted_lovedones'
      data: 'emp_id': $(this).val()
  else
    $('#restricted_lovedones').html '* Select Employee to display results here'
    $('#employee_select').show();
    $('#all_lovedones').addClass('hidden');
    $('#add_restriction_button').addClass('hidden');
    $('#restricted_lovedones').addClass('no-result');
  return

$(document).on 'ready', ->
  $('#employee_lovedone_employee_id').select2();
