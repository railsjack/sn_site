class LovedoneValidation
  constructor: ->
    @validator = @validate_lovedone_form()
    @bindAll()

  bindAll: ->
    that = @
    $('#lovedone_setting').on 'change', (e) ->
      that.update_lovedone_settings()


  validate_lovedone_form: ->
    $('.lovedone-form').validate
      errorClass:'has-error'
      validClass:'has-success'

      highlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

      unhighlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

  address_rules: ->
    "lovedone[street]": {required: true}
    "lovedone[city]": {required: true}
    "lovedone[state]": {required: true}
    "lovedone[zip_code]": {required: true}

  email_rules: ->
    "lovedone[email]":
      required: true
      email: true

  all_possible_fields: ->
    ["lovedone[email]",
     "lovedone[street]",
     "lovedone[city]",
     "lovedone[state]",
     "lovedone[zip_code]"]

  remove_all_rules: ->
    $.each @all_possible_fields(), (i,v)->
      element = $(".lovedone-form *[name='#{v}']")
      element.rules('remove') if element.length != 0

  validate_email: ->
    $.each @email_rules(), (k,v) ->
      element = $(".lovedone-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0
    @validator.form()

  validate_address: ->
    $.each @address_rules(), (k,v) ->
      element = $(".lovedone-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  update_lovedone_settings: ->
    console.log('called');

    @validator.resetForm()
    @remove_all_rules()

    changed_value = $('#lovedone_setting').val()
    if changed_value == 'email'
      @validate_email()
    else if changed_value == 'letter'
      @validate_address()
    else if changed_value == 'off'
      @remove_all_rules()

    @validator.form()

window.lovedone_validation = LovedoneValidation