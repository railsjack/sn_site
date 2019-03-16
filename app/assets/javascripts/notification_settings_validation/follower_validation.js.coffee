class FollowerValidation
  constructor: ->
    @validator = @validate_follower_form()
    @bindAll()

  bindAll: ->
    that = @
    $('#lovedone_follower_transfer').on 'click', ->
      $('#lovedone_follower_transfer').prop('disabled', true)

    $('#follower_contact_method_setting').on 'change', (e) ->
      that.update_contact_method()

    $('#follower_setting').on 'change', (e) ->
      that.update_follower_settings()

    state_selector = '#follower_state'
    county_selector = '#follower_county'
    fn_init_state_county state_selector, county_selector

    $('#follower_phone_number').inputmask('(999) 999-9999').blur (e) ->
      if $(e.target).val() == '(___) ___-____'
        $(e.target).val ''
      return

  validate_follower_form: ->
    $('.follower-form').validate
      errorClass:'has-error'
      validClass:'has-success'

      highlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

      unhighlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

  address_rules: ->
    "follower[street]": {required: true}
    "follower[city]": {required: true}
    "follower[state]": {required: true}
    "follower[zip_code]": {required: true}

  email_rules: ->
    "follower[email]":
      required: true
      email: true

  text_rules: ->
    "follower[phone_number]": {required: true}

  both_rules: ->
    "follower[phone_number]": {required: true}
    "follower[email]":
      required: true
      email: true

  all_possible_fields: ->
    ["follower[email]",
     "follower[phone_number]",
     "follower[street]",
     "follower[city]",
     "follower[state]",
     "follower[zip_code]"]

  remove_all_rules: ->
    $.each @all_possible_fields(), (i,v)->
      element = $(".follower-form *[name='#{v}']")
      element.rules('remove') if element.length != 0

  validate_email: ->
    $.each @email_rules(), (k,v) ->
      element = $(".follower-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0
    @validator.form()

  validate_address: ->
    $.each @address_rules(), (k,v) ->
      element = $(".follower-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_text: ->
    $.each @text_rules(), (k,v) ->
      element = $(".follower-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  validate_both: ->
    $.each @both_rules(), (k,v) ->
      element = $(".follower-form *[name='#{k}']")
      element.rules('add', v) if element.length != 0

  update_contact_method: ->
    @validator.resetForm()
    @remove_all_rules()

    changed_value = $('#follower_contact_method_setting').val()
    if changed_value == 'contact_email'
      @validate_email()
    else if changed_value == 'contact_text'
      @validate_text()
    else if changed_value == 'both'
      @validate_both()
    else if changed_value == 'no_contact'
      @remove_all_rules()

    @validator.form()

  update_follower_settings: ->
    @validator.resetForm()
    @remove_all_rules()

    changed_value = $('#follower_setting').val()
    if changed_value == 'email'
      @validate_email()
    else if changed_value == 'letter'
      @validate_address()
    else if changed_value == 'off'
      @remove_all_rules()

    @validator.form()

window.follower_validation = FollowerValidation