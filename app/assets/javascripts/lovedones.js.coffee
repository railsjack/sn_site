# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#http://stackoverflow.com/questions/13276340/can-i-use-ordinary-javascript-in-coffeescript-file
# using backticks for JS code

$ ->
  user = $("#users th a, #users .pagination a")
  if user and user? and user.length > 0
    user.live "click", ->
      $.getScript @href
      false

  $("#users_search input").keyup ->
    $.get $("#users_search").attr("action"), $("#users_search").serialize(), null, "script"
    false

  $('.assign-primary-contact').click ->
    return unless confirm('Are you sure')
    primary_contact_id = $('.primary-contact-list option:selected').val()
    assign_url = "/lovedones/#{lovedone_id}/assign_primary_contact/#{primary_contact_id}"

    window.open assign_url, "_self"
    return

    $.get assign_url, ->
      return
    ,'json'

  $('.btn-upload-csv').click ->
    if $('.csv-file').val() == ''
      alert 'Please select a CSV file'
      return
    
    if $('.service-provider-list option:selected').val() == ''
      alert 'Please select a Service Provider'
      return
    $('.csv-form').submit()

  return

$(document).on 'click', '#lovedone-submit', ->
  state = $('#lovedone_state').val()
  county = $('#lovedone_county').val()
  name = $('#lovedone_first_name').val()


  if name == ''
    alert('Please Enter Name')
    return false
  else if state == '' or state == 'all'
    alert('Please Select State')
    return false
  else if county == '' or county == 'all'
    alert('Please Select County')
    return false
  else
    $(@form).submit()

  return

$(document).on 'click', '#lovedone_follower_btn', ->
  lovedone_id = $('#lovedone_selection').val()
  if lovedone_id == 'none'
    alert 'Please Select Loved One'
  else
    window.location.href = '/lovedones/' + lovedone_id + '/followers/new'
  return

