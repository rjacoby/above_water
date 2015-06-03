attachLookupButtons = ->
  lookupPeriscopes = (e) ->
    e.preventDefault()
    entity = $(@).data('entity')
    action = $(@).data('action')
    query = $("\##{entity}_query_string").val()
    $(@).addClass "active"
    if (query && query.length > 0)
      Turbolinks.visit("/#{entity}/#{query}/#{action}")

  $('#user-list').click lookupPeriscopes
  $('#user-latest').click lookupPeriscopes
  $('#hashtag-list').click lookupPeriscopes
  $('#hashtag-latest').click lookupPeriscopes

$ ->
  $(document).on("ready page:load", attachLookupButtons)
