$ ->
  $('#data_import_selection').select2()

  $('.state_selector').each (e)->
    state_id = $(@).attr('id');
    county_id = state_id.replace('state', 'county')

    state_selector = '#'+state_id
    county_selector = '#'+county_id
    fn_init_state_county state_selector, county_selector

  $('.valid_phone').inputmask('(999) 999-9999').blur (e) ->
    if $(e.target).val() == '(___) ___-____'
      $(e.target).val ''
    return

  $('#data_import_employee_table').DataTable
    columns: [null, { width: "1%" }]
    columnDefs: [ { targets: 1, orderable: false }]
    searching: false
    paging: false
    info: false

  # Employees Import JS section -------------------------------------------------------------------

  temp_emp = $('.temp_employees').validate
    errorClass:'has-error'
    validClass:'has-success'

    highlight: (element, errorClass, validClass) ->
      $(element).addClass('error-border')

    unhighlight: (element, errorClass, validClass) ->
      $(element).removeClass('error-border')

    errorPlacement: (error, element) ->

  $.validator.addClassRules
    required_field: {required: true}
    valid_email: {required: true, email: true}
    state_selector: {required: true}

  $('#company_employee_spoke').on 'change', (e)->
    spoke= e.target.value
    if spoke != ''
      $.ajax
        url: '/data_imports/spoke_changes'
        method: 'GET'
        data:
          spoke: spoke
          type: 'employee'

  if $('#employee_import').length > 0
    temp_emp.form()
  else
    $('#upload_employees').removeClass('hidden')
    $('#employee_import').addClass('hidden')

  spoke_selection = $('.employee_import_form').validate
    errorClass:'has-error'
    validClass:'has-success'
    rules:
      "company[employee_spoke]": 'required'
      "company[document]":  'required'

    highlight: (element, errorClass, validClass) ->
      $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

    unhighlight: (element, errorClass, validClass) ->
      $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

  $('.employee_import_form').submit (ev) ->
    ev.preventDefault()
    if spoke_selection.form()
      new window.SnModal
        title: "<center><h3 class='golden-font-color'>Uploading File</h3></center>"
        body: "<center><div class='three-quarters-loader'></div></center><br>"
        width: '100px;'
      @submit()
    return

  $('.temp_employees').submit (ev) ->
    ev.preventDefault()
    if temp_emp.form()
      new window.SnModal
        title: "<center><h3 class='golden-font-color'>Importing Employees</h3></center>"
        body: "<center><div class='three-quarters-loader'></div></center><br>"
        width: '100px;'
      @submit()
    return

  # Loved Ones Import JS section -------------------------------------------------------------------

  temp_lo = $('.temp_lovedones').validate
    errorClass:'has-error'
    validClass:'has-success'

    highlight: (element, errorClass, validClass) ->
      $(element).addClass('error-border')

    unhighlight: (element, errorClass, validClass) ->
      $(element).removeClass('error-border')

    errorPlacement: (error, element) ->

  $.validator.addClassRules
    required_field: {required: true}
    required_county: {required: true}
    state_selector: {required: true}

  $('#company_lovedone_spoke').on 'change', (e)->
    spoke = e.target.value
    if spoke != ''
      $.ajax
        url: '/data_imports/spoke_changes'
        method: 'GET'
        data:
          spoke: spoke
          type: 'lovedone'


  if $('#lovedone_import').length > 0
    $('#upload_lovedones').addClass('hidden')
    $('#lovedone_import').removeClass('hidden')
    setTimeout ->
      temp_lo.form()
    , 200
  else
    $('#upload_lovedones').removeClass('hidden')

  lo_spoke_selection = $('.lovedone_import_form').validate
    errorClass:'has-error'
    validClass:'has-success'
    rules:
      "company[lovedone_spoke]": 'required'
      "company[document]":  'required'

    highlight: (element, errorClass, validClass) ->
      $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

    unhighlight: (element, errorClass, validClass) ->
      $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

  $('.lovedone_import_form').submit (ev) ->
    ev.preventDefault()
    if lo_spoke_selection.form()
      new window.SnModal
        title: "<center><h3 class='golden-font-color'>Uploading File</h3></center>"
        body: "<center><div class='three-quarters-loader'></div></center><br>"
        width: '100px;'
      @submit()
    return

  $('.temp_lovedones').submit (ev) ->
    ev.preventDefault()
    if temp_lo.form()
      new window.SnModal
        title: "<center><h3 class='golden-font-color'>Importing Loved Ones</h3></center>"
        body: "<center><div class='three-quarters-loader'></div></center><br>"
        width: '100px;'
      @submit()
    return