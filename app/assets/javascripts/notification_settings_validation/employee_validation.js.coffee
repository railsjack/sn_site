class EmployeeValidation
  constructor: ->
    @validator = @validate_employee_form()
    @bindAll()

  bindAll: ->
    that = @
    $('#employee_setting').on 'change', (e) ->
      that.update_employee_settings()

    $('.employee-form').on 'submit', ->
      that.validate_employee_data()

    state_selector = '#employee_state'
    county_selector = '#employee_county'
    fn_init_state_county state_selector, county_selector

    $('#employee_phone_number').inputmask('(999) 999-9999').blur (e) ->
      if $(e.target).val() == '(___) ___-____'
        $(e.target).val ''
      return

  validate_employee_form: ->
    $('.employee-form').validate
      errorClass:'has-error'
      validClass:'has-success'

      highlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

      unhighlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

  form_rules: ->
    "employee[first_name]": {required: true}
    "employee[last_name]": {required: true}
    "employee[address]": {required: true}
    "employee[state]": {required: true}
    "employee[city]": {required: true}

  password_rules: ->
    "employee[password]": {required: true, minlength: 8}

  text_rules: ->
    "employee[phone_number]": {required: true}

  email_rules: ->
    "employee[email]":
      required: true
      email: true

  both_rules: ->
    "employee[phone_number]": {required: true}
    "employee[email]":
      required: true
      email: true

  all_possible_fields: ->
    ["employee[first_name]",
    "employee[last_name]",
    "employee[address]",
    "employee[state]",
    "employee[city]",
    "employee[email]",
    "employee[password]",
    "employee[phone_number]"]

  remove_all_rules: ->
    $.each @all_possible_fields(), (i,v)->
      element = $(".employee-form *[name='#{v}']")
      element.rules('remove') if element.length != 0

  validate_form_rules: ->
    $.each @form_rules(), (k,v) ->
      element = $(".employee-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_password: ->
    $.each @password_rules(), (k,v) ->
      element = $(".employee-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_email: ->
    $.each @email_rules(), (k,v) ->
      element = $(".employee-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_text: ->
    $.each @text_rules(), (k,v) ->
      element = $(".employee-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_both: ->
    $.each @both_rules(), (k,v) ->
      element = $(".employee-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  update_employee_settings: ->
    @validator.resetForm()
    @remove_all_rules()

    changed_value = $('#employee_setting').val()
    if changed_value == 'email'
      @validate_email()
    else if changed_value == 'text'
      @validate_text()
    else if changed_value == 'both'
      @validate_both()
    else if changed_value == 'off'
      @remove_all_rules()

    @validator.form()

  validate_employee_data: ->
    @remove_all_rules()
    @validate_form_rules()
    if $('.username').val().length > 0
      @validate_password()
    @validator.form()

window.employee_validation = EmployeeValidation