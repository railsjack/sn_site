class SnModal
  @modal_id: undefined
  @default_properties: undefined
  @properties: undefined

  constructor: (properties={})->
    if $('#lp-modal').length > 0
      @modal_id = '#lp-modal-1'
      $('body').append(@secondary_body())
    else
      @modal_id = '#lp-modal'
      $('body').append(@default_body())
    @default_properties =
      url: ''
      title: ''
      width: ''
      role: ''
      dialog_classes: []
      body:  "<div class='text-center'>
                <div class='three-quarters-loader'>
                  Loading...
               </div>
              </div>"
      footer: '<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
             <button type="button" class="btn btn-primary">OK</button>'
      before_ajax_load: ->
      after_ajax_load:  ->
      before_show: ->
      after_show: ->
      before_submit: ->
        return true
      after_submit: ->
        console.log 'after'

    @properties = $.extend(@default_properties, properties)

    if @properties.url != ''
      @show_ajax_modal()
    else
      @show_modal()
      @submit_binding()

    @bindAll()

  build_modal: (options)->
    that = @

    $("#{that.modal_id} .title").text(if options.title != null then options.title else that.default_properties.title)
    $("#{that.modal_id} .modal-body").html(if options.body != null then options.body  else that.default_properties.body)
    $(that.modal_id).modal('show')

  bindAll: ->
    that = @
    $(document).on 'click','a.btn', (e)->
#      unless typeof $(@).data('url') == 'undefined'
#        that.properties.url   = $(@).data('url')
#        that.properties.title = $(@).data('title')
#        that.show_ajax_modal()

    $(@modal_id).on  'hidden.bs.modal', ->
      that.destroy_modal()

  show_ajax_modal: ->
    that = @
    that.show_modal()
    $.ajax
      url: that.properties.url
      success: (data)->
        that.set_body(data);
        that.update_modal()
        that.properties.after_ajax_load()
        that.submit_binding()

      error: (data)->
        that.set_body("Error: Something went wrong while fecthing view.")

  show_modal: ->
    that = @
    that.update_modal()
    #@properties.before_show()

    if @properties.role == 'alert'
      $("#{that.modal_id} .modal-header").hide()
    else
      $("#{that.modal_id} .modal-header").show()

    $(@modal_id).modal
      backdrop: 'static'
      keyboard: false
      show: true
    @properties.after_show()

    if $('#lp-modal').length > 0 && $('#lp-modal-1').length > 0
      $('#lp-modal').css('z-index', 0)

  update_modal: ->
    that = @
    if that.properties.width != ''
      $("#{that.modal_id} .modal-dialog").css('width',that.properties.width)
    $("#{that.modal_id} .modal-title").html(that.properties.title)
    $("#{that.modal_id} .modal-body").html(that.properties.body)

  set_body: (content)->
    @properties.body = content

  set_title: (content)->
    @properties.title = content

  destroy_modal: ->
    that = @
    $("#{that.modal_id} .modal-dialog").css('width','')
    $("#{that.modal_id}").remove()
    if $('#lp-modal-1').length == 0 && $('#lp-modal').length > 0
      $('#lp-modal').css('z-index', '')


  submit_binding: ->
    that = @
    form = $('.modal-body form')

    $('.modal-body form input[type="submit"]').unbind 'click'
    $('.modal-body form input[type="submit"]').on 'click', (e)->
      e.preventDefault()
      that.submit_form(form)
#

  submit_form: (form)->
    that = @
    if @properties.before_submit()
      form.submit();
      @properties.after_submit();
      $("#{that.modal_id}").modal('hide')

  default_body: ->
    '<div class="modal fade" id="lp-modal" tabindex="-1" role="dialog">
        <div class="modal-dialog ">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
            </div>
          </div>
        </div>
      </div>'

  secondary_body: ->
    '<div class="modal fade" id="lp-modal-1" tabindex="-1" role="dialog">
        <div class="modal-dialog ">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
            </div>
          </div>
        </div>
      </div>'
$ ->
  window.SnModal = SnModal
