# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#memberHistoryModal #history_start_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true

  $('#memberHistoryModal #history_end_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true

  $('#selectedHistoryModal #selected_history_start_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true

  $('#selectedHistoryModal #selected_history_end_date').datetimepicker
    format:'m/d/Y',
    timepicker: false,
    closeOnDateSelect: true

  $('#company_members_table').DataTable
    columns: [{ width: "4%" }, { "width": "7%" }, { "width": "7%" }, { "width": "5%" }, { "width": "5%" }, { "width": "5%" }, { "width": "5%" }, { "width": "12%" }, { "width": "5%" }, null, null, null],
    columnDefs: [ { targets: 6, orderable: false }, { targets: 7, orderable: false }, { targets: 8, orderable: false } ],
    sScrollX: "100%",
    sScrollXInner: "110%",
    searching: false,
    paging: false,
    info: false

  $('#new_user').on 'click', ->
    $('#new_member_first_name').val('')
    $('#new_member_last_name').val('')
    $('#new_member_email').val('')
    $('#new_member_password').val('')
    $('#new_member_password_confirm').val('')
    $('#newMemberModal').modal('show')

  $('#selected_history').on 'click', ->
    $('#selected_history_start_date').val('')
    $('#selected_history_end_date').val('')
    $('#selected_history_type').val(0)
    $('#selectedHistoryModal #selectedHistoryContent').html(' ');
    $('#selectedHistoryModal').modal('show')

  $('.member_access').on 'click', ->
    $('#member_selected').html('<h4 style="color:green">' + $(this).closest("tr").find("td.first_name").html() + ' ' + $(this).closest("tr").find("td.last_name").html() + '</h4>')
    user = parseInt($(this).closest("tr").find("td.hidden.user_id").html())
    access_array = $(this).closest("tr").find("td.hidden.access").html().trim()
    access_array = access_array.split(',')
    $(".access_setting_tab .checkbox input").prop("checked",false)
    $(".access_setting_tab .checkbox input").each ->
      $(this).prop('checked', true) if _.contains(access_array, $(this).val())

    $('#access_setting_user').val(user)
    $('#memberAccessModal').modal('show')

  $('.edit_member').on 'click', ->
    user = $(this).closest("tr").find("td.hidden.user_id").html()
    $.ajax
      url: '/access_settings/edit_member'
      dataType: 'script'
      type: 'POST'
      data:
        user_id: parseInt(user)

  $('.delete_member').on 'click', ->
    if confirm('Are you sure you want to delete Member?')
      member = $(this).closest("tr").find("td.hidden.member_id").html()
      user = $(this).closest("tr").find("td.hidden.user_id").html()
      $.ajax
        url: '/access_settings/delete_member'
        dataType: 'script'
        type: 'POST'
        data:
          member_id: parseInt(member)
          user_id: parseInt(user)

  $('.member_history').on 'click', ->
    user = $(this).closest("tr").find("td.hidden.user_id").html()
    $('#memberHistoryModal #member_selected').html('<h4 style="color:green">' + $(this).closest("tr").find("td.first_name").html() + ' ' + $(this).closest("tr").find("td.last_name").html() + '</h4>')
    $('#memberHistoryModal #user_id').val parseInt(user)
    $('#memberHistoryModal #history_start_date').val ''
    $('#memberHistoryModal #history_end_date').val ''
    $('#memberHistoryModal #memberHistoryContent').html ''
    $('#memberHistoryModal').modal 'show'

  $('#history_generate_btn').on 'click', ->
    user = $('#memberHistoryModal #user_id').val()
    start_date = $('#memberHistoryModal #history_start_date').val()
    end_date = $('#memberHistoryModal #history_end_date').val()
    if start_date == ''
      alert 'Please Select Start Date'
      return false
    else if end_date == ''
      alert 'Please Select End Date'
      return false
    else
      $.ajax
        url: '/access_settings/member_history'
        dataType: 'script'
        type: 'POST'
        data:
          user_id: user
          start_date: start_date
          end_date: end_date

  $('#selected_history_generate_btn').on 'click', ->
    start_date = $('#selectedHistoryModal #selected_history_start_date').val()
    end_date = $('#selectedHistoryModal #selected_history_end_date').val()
    type = $('#selectedHistoryModal #selected_history_type').val()
    if start_date == ''
      alert 'Please Select Start Date'
      return false
    else if end_date == ''
      alert 'Please Select End Date'
      return false
    else
      $.ajax
        url: '/access_settings/selected_history'
        dataType: 'script'
        type: 'POST'
        data:
          start_date: start_date
          end_date: end_date
          type: type

  $('#new_member_button').on 'click', ->
    first_name = $('#new_member_first_name').val()
    last_name = $('#new_member_last_name').val()
    email = $('#new_member_email').val()
    password = $('#new_member_password').val()
    password_confirm = $('#new_member_password_confirm').val()
    if first_name == ''
      alert 'Please Enter First Name'
      return false
    else if last_name == ''
      alert 'Please Enter Last Name'
      return false
    else if email == ''
      alert 'Please Enter Email'
      return false
    else if password == ''
      alert 'Please Enter Password'
      return false
    else if password.length < 8
      alert 'Please Enter Password with minimum 8 Characters'
      return false
    else if password_confirm == ''
      alert 'Please Enter Confirmation Password'
      return false
    else if password != password_confirm
      alert 'Your Password do not match, please Enter again'
      return false
    else
      $.ajax
        url: '/access_settings/new_member'
        dataType: 'script'
        type: 'POST'
        data:
          first_name: first_name
          last_name: last_name
          email: email
          password: password