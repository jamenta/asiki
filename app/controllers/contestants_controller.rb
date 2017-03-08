class ContestantsController < ApplicationController
  def create
    @email = params[:contestant][:email]
    @contest = Contest.find_by_id(params[:id])
    @user = User.where(email: @email).first
    @inviter = current_user.first_name+' '+current_user.last_name[0,1].upcase+'.'
    @invite_display = { :user_id => nil, :email => nil, :name => nil, :style => "font-weight:normal;" }
    @invite_success = false

  if @email == nil || @email == ""
    @resulting_message = "Email can't be blank."
  else
    if @user == nil
      @invitation = Invitation.create(email: @email, contest_id: @contest.id, expiration: @contest.end_date)
      if @invitation.save
        @invite_success = true
        @resulting_message = "Invitation sent!"
        @invite_display[:name] = @email
      else
        errorString = ""
        @invitation.errors.full_messages.each do |message|
          errorString = errorString + message + ", "
        end
        errorString = errorString.chomp(", ")
      end
    else
      @contestant = Contestant.create(user_id: @user.id, contest_id: @contest.id)
      if @contestant.save
        @invite_success = true
        @resulting_message = "Invitation sent to #{@user.first_name}!"
        @invite_display[:email] = @email
        @invite_display[:name] = @user.first_name + " " + @user.last_name
        @invite_display[:user_id] = @user.id
        @invite_display[:style] = "font-weight:bold;"
	    @notification = Notification.create(user_id: @user.id, notification_type: "INVITATION", description: "#{@inviter} has invited you to join a new contest!", link_url: "/contests/#{@contest.id}")
      else
        errorString = ""
        @contestant.errors.full_messages.each do |message|
          errorString = errorString + message + ", "
        end
        errorString = errorString.chomp(", ")
      end
    end
    if @invite_success == false
      if errorString.include?("User has already been taken")
        @resulting_message = "This person has already been invited!"
      elsif errorString.include?("Email has already been taken")
        @resulting_message = "This person has already been invited!"
      else
        @resulting_message = errorString + "."
      end
    end

  end

    respond_to do |format|
      format.html { redirect_to "/contests/#{@contest.id}" }
      format.js
    end

  end

  def update
   @contestant = Contestant.update(params[:contestant_id], accepted: params[:value])
	if @contestant.save
	  if params[:value] == "true"
	    flash[:notice] = "You joined the contest!"
	  else
	    flash[:notice] = "You declined joining the contest."
	  end
	else
	  flash[:alert] = "There was an error joining the contest. Please try again later."
	end
     redirect_to "/contests/#{params[:id]}"
  end

  def destroy
	@contestant = Contestant.destroy(params[:id])
	if @contestant.save
	  flash[:notice] = "You left the contest."
	  redirect_to "/contests"
	else
	  flash[:alert] = "There was a problem leaving the contest. Please try again later."
	  redirect_to "/contests"
	end
  end
end
