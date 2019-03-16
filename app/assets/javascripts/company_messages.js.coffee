$ ->
  $('#new_company_message').submit ->
    if $.trim($('#company_message_message').val()) == ""
      alert 'Enter message'
      return false

    if $('input[name="company_message[company_message_employees][]"]:checked').size() == 0
      alert 'No employees have been identified to receive the message.'
      return false
    return true

  $('.all-designation').click ->
    $('.designation-id').prop 'checked', $(this).prop('checked')

  $('.all-designation').trigger 'click'

  window.showModal = (content, header)->
    $('#messagesModal .modal-body').html content
    $('#messagesModal .modal-title').html header
    $('#messagesModal').modal('show')

  $('.btn-search').click ->
    distance = $('#distance').val()

    designation_ids = []
    $('.designation-id:checked').each ->
      designation_ids.push $(this).val()
    $('#employees_list .col-lg-10').html ''

    street = $('#street').val()
    city = $('#city').val()
    state = $('#state').val()
    zip = $('#zip').val()

    if state == 'all'
      state = null

    if !street
      alert 'Please enter street in order to search'
      return
    else if !city
      alert 'Please enter city in order to search'
      return
    else if !state
      alert 'Please select state in order to search'
      return
    if !distance
      alert 'Please enter the distance'
      return

    address = "#{street}, #{city}, #{state} #{zip}"
    $('#company_message_address').val address

    address = encodeURI(address)


    url = "#{company_employees_search_path}?distance=#{distance}&address=#{address}&designation_id=#{designation_ids.join(',')}"
    if window.xhr
      window.xhr.abort()
    $('.btn-search').button 'loading'
    window.xhr = $.get url, (employees)->
      html = ""
      $('.btn-search').button 'reset'
      for employee in employees
        html += "<span class='checkbox'><label for='company_message_company_message_employees_#{employee.id}'><input class='check_boxes optional' id='company_message_company_message_employees_#{employee.id}' name='company_message[company_message_employees][]' type='checkbox' value='#{employee.id}' checked>#{employee.name}</label></span>"

      if html==""
        html = "There are no employees that meet this selection criteria. Please expand the distance or modify the designation."
        $('#employees_list')
        .html html
        .addClass 'no-result'
      else
        if employees.length > 1
#          html = "<span class='checkbox'><label for='select_all_employees'><h5><b><input class='check_boxes optional' id='select_all_employees' type='checkbox'>Select all</b></h5></label></span>" + html
          $('input[id=select_all_employees]').trigger 'click'

        $('#employees_list .col-lg-10').html html
        $('input[id=select_all_employees]').trigger 'click'

        $('input[id=select_all_employees]').unbind('click').click ->
          $("input[name='company_message[company_message_employees][]']").prop 'checked', $(this).prop('checked')

    , 'json'


