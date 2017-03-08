$(document).on 'turbolinks:load', ->
  $(".post-results-btn").click ->
    $(".submit-results").show()
    $('html, body').animate({scrollTop:500}, 1000)
    $(".post-results-btn").hide()

$(document).on 'turbolinks:load', ->
  $("#results-display-section").mouseover ->
    $("p#option-buttons").show()
  $("#results-display-section").mouseleave ->
    $("p#option-buttons").hide()

$(document).on 'turbolinks:load', ->
  $('p#form-comment-link').click ->
    $(this).remove()
    $('div#form-comment-section').show()

$(document).on 'turbolinks:load', ->
  $("textarea#results-comment").keyup ->
    commentLength = $('textarea#results-comment').val().length
    charsRemain = 140 - commentLength
    
    if charsRemain < 0
      $('#submit-results-btn').attr("disabled", true)
      $("div#comment-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else if charsRemain < 20
      $('#submit-results-btn').attr("disabled", false)
      $("div#comment-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else
      $('#submit-results-btn').attr("disabled", false)
      $("div#comment-warnings p.warning").replaceWith("<p></p>")

$(document).on 'turbolinks:load', ->
  $("textarea#add_comment_field").keyup ->
    commentLength = $('textarea#add_comment_field').val().length
    charsRemain = 140 - commentLength    
    if charsRemain < 0
      $('#add-comment-btn').attr("disabled", true)
      $("div#contest-comment-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else if charsRemain < 20
      $('#add-comment-btn').attr("disabled", false)
      $("div#contest-comment-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else
      $('#add-comment-btn').attr("disabled", false)
      $("div#contest-comment-warnings p.warning").replaceWith("<p></p>")

$(document).on 'turbolinks:load', ->
  $("input#contest_contest_name").keyup ->
    commentLength = $('input#contest_contest_name').val().length
    charsRemain = 30 - commentLength    
    if charsRemain < 0
      $('#create-contest-btn').attr("disabled", true)
      $("div#new-contest-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else if charsRemain < 6
      $('#create-contest-btn').attr("disabled", false)
      $("div#new-contest-warnings p").replaceWith("<p class='warning'>#{charsRemain} characters remaining</p>")
    else
      $('#create-contest-btn').attr("disabled", false)
      $("div#new-contest-warnings p.warning").replaceWith("<p></p>")
	  
$(document).on 'turbolinks:load', ->
  $("div#hover-wrapper").mouseover ->
    $("div#hidden-favorites").show()
  $("div#hover-wrapper").mouseleave ->
    $("div#hidden-favorites").hide()



