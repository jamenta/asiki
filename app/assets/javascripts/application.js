// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function(){
  $('div#privacy-info a#hide').click(function(){
    $('div#privacy-info').animate( {left: "-601px"}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#show-privacy-info').click(function(){
    $('div#privacy-info').animate( {left: 0}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#add-invitations').click(function(){
    $('#contest-menu-icon').removeClass('icon-selected')
    $('#contest-menu').animate( {left: "-402px"}, 500);
    $('#invite-form').animate( {left: "500px"}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#hide-invitations').click(function(){
    $('#invite-form').animate( {left: "0px"}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#contest-menu-icon').click(function(){
    $('#contest-menu').animate( {left: 0}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#hide-menu').click(function(){
    $('#contest-menu-icon').removeClass('icon-selected')
    $('#contest-menu').animate( {left: "-402px"}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('#invite-friends').click(function(){
    $('#invite-form').animate( {left: "500px"}, 500);
   });
});

$(document).on('turbolinks:load', function(){
  $('div#gravatar-checkbox input').change(function(){
    if (this.checked){
	  $('div.emoji-option img').removeClass('active-emoji');
	  $('div#gravatar').show();
	  $('div#gravatar-display').show();
	}
	else {
	  $('div.emoji-option img').removeClass('active-emoji');
	  $('div.emoji-option img').first().addClass('active-emoji');
	  $('div#gravatar').hide();
	  $('div#gravatar-display').hide();
	}
  });
});

$(document).on('turbolinks:load', function(){
  $('div.emoji-option').click(function(){
    $('div#gravatar-checkbox input').attr('checked', false);
	$('div#gravatar').hide();
	$('div#gravatar-display').hide();
  });
});

$(document).on('turbolinks:load', function(){
  $('#edit-user-btn').click(function(){
    var x = document.getElementsByClassName('active-emoji');
	if (x.length > 0){
      $('#user_emoji_title').val(x[0].id);
	}
	else {
      $('#user_emoji_title').val(null);
	}
    $('form.edit_user').submit();
  });
});



