class FriendsController < ApplicationController

  def index
    if params[:user] == nil
      @user = User.find(current_user.id)
    else
      @user = User.find_by_id(params[:user].to_i)
    end
	if @user
	  @friends = @user.friends.where(status: 'accepted').joins("JOIN users ON users.id = friends.friend_id LEFT JOIN posts ON posts.user_id = friends.friend_id").select([:id, :friend_id, :first_name, :last_name, :state, "COUNT(posts.id) AS workouts"]).group([:id, :friend_id, :first_name, :last_name, :state]).limit(100)
	  @requests = @user.friends.where(status: 'pending').joins("JOIN users ON users.id = friends.friend_id LEFT JOIN posts ON posts.user_id = friends.friend_id").select([:id, :friend_id, :first_name, :last_name, :state, "COUNT(posts.id) AS workouts"]).group([:id, :friend_id, :first_name, :last_name, :state]).limit(100)
	  if current_user.id == @user.id
	    @outstanding_invites = current_user.friend_invitations
	  else
		@currentFriends = Hash[current_user.friends.select(:friend_id, :status).map{|i|[i.friend_id, i]}]
	  end
	end
  end
  
  def create
    @friend1 = Friend.create(user_id: current_user.id, friend_id: params[:friend_id], status: 'requested')
	@friend2 = Friend.create(user_id: params[:friend_id], friend_id: current_user.id, status: 'pending')
	if @friend1.save && @friend2.save
	  @success_bool = true
	  Notification.create(user_id: params[:friend_id], notification_type: "FRIEND REQUEST", description: "#{current_user.first_name} #{current_user.last_name} wants to be your fitness friend!", link_url: "/friends")
	else
	  @success_bool = false
	end
	respond_to do |format|
	  format.html
	  format.js
	end
  end
  
  def accept
    @friend1 = Friend.find(params[:id])
    @friend2 = Friend.where(user_id: @friend1.friend_id, friend_id: @friend1.user_id).first
	@friend1.update(status: 'accepted')
	@friend2.update(status: 'accepted')
	if @friend1.save && @friend2.save
	  @success_bool = true
	  Notification.create(user_id: @friend1.friend_id, notification_type: "FRIEND REQUEST", description: "#{current_user.first_name} #{current_user.last_name} has accepted your friend request.", link_url: "/profile?user=#{current_user.id}")
	else
	  @success_bool = false
	end
    respond_to do |format|
	  format.html
	  format.js
	end
  end
  
  def decline
    @friend1 = Friend.find(params[:id])
	@friend1.update(status: 'declined')
	@friend2 = Friend.where(user_id: @friend1.friend_id, friend_id: @friend1.user_id).first
	@friend2.update(status: 'rejected')
	if @friend1.save && @friend2.save
	  @success_bool = true
	else
	  @success_bool = false
	end
    respond_to do |format|
	  format.html
	  format.js
	end
  end
  
    def destroy
	if params[:profile] == "true"
	  @profile_bool = true
	else
	  @profile_bool = false
	end
    @friend1 = Friend.find(params[:id])
	@friend2 = Friend.where(user_id: @friend1.friend_id, friend_id: @friend1.user_id).first
	@user_id = @friend1.user_id
    @friend1.delete
	@friend2.delete
	if @friend1.save && @friend2.save
	  @success_bool = true
	else
	  @success_bool = false
	end
    respond_to do |format|
	  format.html
	  format.js
	end
  end
	
  
end
