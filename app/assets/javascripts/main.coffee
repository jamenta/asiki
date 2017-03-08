$(document).on 'turbolinks:load', ->
  $(".close-notice-icon").click ->
    $(".good-notice-wrapper").remove()
  setTimeout ->
    $(".good-notice-wrapper").fadeOut("slow")
  , 2000

$(document).on 'turbolinks:load', ->
  $(".close-notice-icon").click ->
    $(".good-results-wrapper").remove()
  setTimeout ->
    $(".good-results-wrapper").fadeOut("slow")
  , 5000

$(document).on 'turbolinks:load', ->
  $(".close-notice-icon").click ->
    $(".bad-alert-wrapper").remove()

$(document).on 'turbolinks:load', ->
  $("#extra-details-link").click ->
    $("#extra-details-link").remove()
    $("#extra-details").show()

$(document).on 'turbolinks:load', ->
  $(".notification-btn").click ->
    $(".notification-btn").toggleClass('active')
    $(".notification-menu").toggle()

$(document).on 'turbolinks:load', ->
  $(".notification-btn-unread").click ->
    $(".notification-btn-unread").toggleClass('active')
    $(".notification-menu").toggle()

$(document).on 'turbolinks:load', ->
  $(".user-comment-container").mouseover ->
    $(this).children('.delete-comment').show()
  $(".user-comment-container").mouseleave ->
    $(this).children('.delete-comment').hide()

$(document).on 'turbolinks:load', ->
  $('div.emoji-option img').click ->
    $('div.emoji-option img').removeClass('active-emoji')
    $(this).addClass('active-emoji')
	
$(document).on 'turbolinks:load', ->
  $('#create-contest-btn').click ->
    x = document.getElementsByClassName('active-emoji')
    $('#contest_emoji_title').val(x[0].id)
    $('form#new_contest').submit()
	
$(document).on 'turbolinks:load', ->
  $('#edit-contest-btn').click ->
    x = document.getElementsByClassName('active-emoji')
    $('#contest_emoji_title').val(x[0].id)
    $('form.edit_contest').submit()

$(document).on 'turbolinks:load', ->
  $("div.profile-header").mouseover ->
    $(this).children('a#settings-icon').show()
  $("div.profile-header").mouseleave ->
    $(this).children('a#settings-icon').hide()

$(document).on 'turbolinks:load', ->
  $('input#workout_rounds').click ->
    $('div.reps-per-round').toggleClass('hidden')
	
$(document).on 'turbolinks:load', ->
  $("div.friend-options").mouseover ->
    $(this).children('div.dropdown').show()
  $("div.friend-options").mouseleave ->
    $(this).children('div.dropdown').hide()
	
$(document).on 'turbolinks:load', ->
  $("div#messages-container div.message").mouseover ->
    $(this).children('div.header').children('a.delete-message').show()
  $("div#messages-container div.message").mouseleave ->
    $(this).children('div.header').children('a.delete-message').hide()


	
	
	

