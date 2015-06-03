attachLookupButtons = ->
  lookupUser = (e) ->
    e.preventDefault()
    query = $('#user_query_string').val()
    $(@).addClass "active"
    entity = $(@).data('entity')
    action = $(@).data('action')
    if (query && query.length > 0)
      Turbolinks.visit("/#{entity}/#{query}/#{action}")

  $('#lookup-list').click lookupUser
  $('#lookup-latest').click lookupUser

$ ->
  $(document).on("ready page:load", attachLookupButtons)
