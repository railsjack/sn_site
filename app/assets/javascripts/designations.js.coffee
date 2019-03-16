# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#new_designation').submit ->
    colors = []
    color = $('#designation_color option:selected').text()
    name = $('#designation_name').val()
    if name == ""
      alert 'Please enter the name'
      return false

    if color == ""
      alert 'Please select the color'
      return false

    $('.category-list .used-color').each ->
      colors.push($(this).text())
    if colors.indexOf(color)>-1
      alert 'The color you selected is already in use. Please select a different color.';
      $('#company_category_color').val("")
      return false
    return true

