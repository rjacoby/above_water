attachLookupButtons = ->
  lookupUser = (e) ->
    e.preventDefault()
    entity = 'user'
    query = $('#user_query_string').val()
    $(@).addClass "active"
    action = $(@).data('action')
    if (query && query.length > 0)
      # window.location.replace("/#{action}/#{handle}/")
      Turbolinks.visit("/#{entity}/#{query}/#{action}")

  $('#lookup-list').click lookupUser
  $('#lookup-latest').click lookupUser

$ ->
  $(document).on("ready page:load", attachLookupButtons)
