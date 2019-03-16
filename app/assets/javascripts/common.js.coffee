window.fn_init_state_county = (state_selector, county_selector) ->
  $(state_selector).change ->
    text = $("option:selected", this).text()
    $(county_selector).empty()
    if states[text]
      html = ""
      selected_item = $(county_selector).attr("data-selected-item")
#      html += "<option value='all'>All</option>"
      html += "<option> </option>"
      states[text].map (o) ->
        selected = (if (selected_item is o) then "selected" else "")
        html += "<option value='"+o+"' "+selected+" >" + o + "</option>"
        return

      $(county_selector).append html
    return

  $(state_selector).trigger "change"
  return


window.stringSorter = (a, b) ->
  if stripTags(a.toLowerCase()) < stripTags(b.toLowerCase())
    -1
  else
    1

window.numberSorter = (a, b) ->
  if a < b
    -1
  else
    1

window.stripTags = (html) ->
  $.trim $("<p>" + html + "</P>").text()
