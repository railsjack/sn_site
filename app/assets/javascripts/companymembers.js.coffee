# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', 'input[id=check_both]', ->
  b_flag = $(this).get(0).checked
  $('input[type=checkbox]', $(this).parents('div#contact-method')).each ->
    if $(this).attr('id') != 'check_both'
      $(this).get(0).checked = b_flag
    return
  return

$(document).on 'click', '#contact-method input[type=checkbox]', (event) ->
  email = $('#contact-method input[type=checkbox][value=email]').get(0)
  text = $('#contact-method input[type=checkbox][value=text]').get(0)
  both = $('#contact-method input[type=checkbox][value=both]').get(0)
  both.checked = email.checked and text.checked
  return

$(document).on 'click', '#user_company_attributes_lovedone_masking', ->
  $(@form).submit()
  return

$(document).on 'click', '#user_company_attributes_notification_masking', ->
  $(@form).submit()
  return

$ ->
  $('#tooltip_company').tooltip()
  return