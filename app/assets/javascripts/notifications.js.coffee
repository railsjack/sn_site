class Notifications
  constructor: ->
    @bindAll()

  bindAll: ->
    $('#new_notification input[type=submit]').click ->
      $(this).addClass 'disabled'

    $('#sponsor_billing_table').DataTable()
    $('#provider_billing_table').DataTable()

    $('#new_monthly_billing').validate
      errorClass:'has-error'
      validClass:'has-success'
      rules:
        "monthly_billing[month(2i)]": 'required'
        "monthly_billing[year(1i)]":  'required'
      messages:
        "monthly_billing[month(2i)]": '&nbsp;* required'
        "monthly_billing[year(1i)]":  '&nbsp;* required'

      highlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").addClass(errorClass).removeClass(validClass);

      unhighlight: (element, errorClass, validClass) ->
        $(element).parents("div.form-group").removeClass(errorClass).addClass(validClass);

$ ->
  window.notifications = new Notifications
  window.Notifications = Notifications
