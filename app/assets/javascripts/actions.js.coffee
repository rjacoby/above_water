attachLookupButtons = ->
  lookupUser = (e) ->
    e.preventDefault()
    handle = $('#user_twitter_handle').val()
    $(@).addClass "active"
    action = $(@).data('action')
    console.log action
    if (handle && handle.length > 0)
      # window.location.replace("/#{action}/#{handle}/")
      Turbolinks.visit("/#{action}/#{handle}/")

  $('#lookup-list').click lookupUser
  $('#lookup-latest').click lookupUser

$ ->
  $(document).on("ready page:load", attachLookupButtons)
