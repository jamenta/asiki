class FriendInvitationsController < ApplicationController
  def create
    @invite_success = false
	@user_exists = false
    @email = params[:friend_invitation][:email].downcase
    if @email == nil || @email == ""
      @resulting_message = "Email can't be blank."
    else
      @user = User.where(email: @email).first
	  if @user == nil
        @invite = FriendInvitation.create(user_id: current_user.id, email: @email)
        if @invite.save
          @invite_success = true
          @resulting_message = "Invitation sent!"
        else
          errorString = @invite.errors.full_messages[0]
        end
        if @invite_success == false
	      if errorString == "Email has already been taken"
            @resulting_message = "You've already invited this person!"
		  else
		    @resulting_message = errorString
		  end
        end
	  else
	    @user_exists = true
	    @friend1 = Friend.create(user_id: current_user.id, friend_id: @user.id, status: 'requested')
	    @friend2 = Friend.create(user_id: @user.id, friend_id: current_user.id, status: 'pending')
	    if @friend1.save && @friend2.save
	      @invite_success = true
	      Notification.create(user_id: @user.id, notification_type: "FRIEND REQUEST", description: "#{current_user.first_name} #{current_user.last_name} wants to be your fitness friend!", link_url: "/friends")
	      @resulting_message = "Invitation sent to #{@user.first_name}!"
		else
		  if @friend1.errors.full_messages.length > 0
		    @resulting_message = @friend1.errors.full_messages[0]
		  else
		    @resulting_message = @friend2.errors.full_messages[0]
		  end
		  if @resulting_message = "Friend has already been taken"
		    @resulting_message = "You're already friends with this person!"
		  end
	    end
	  end
    end
	respond_to do |format|
	  format.html
	  format.js
	end
  end
end
