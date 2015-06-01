$ ->
  lookupUser = (e) ->
    e.preventDefault()
    console.log($('#user_twitter_handle').val())
    $(@).addClass "active"

  $('#lookup-list').click lookupUser
