class MessagesController < ApplicationController
  def index
    if current_user
	  @messages= Message.joins("JOIN users ON users.id = messages.sender_id").where(user_id: current_user.id).select(:id, :first_name, :last_name, :sender_id, :message, :created_at).order(created_at: :desc).limit(50)
	end
  end
  
  def new
    @user = User.find(params[:user_id])
	respond_to do |format|
	  format.html
	  format.js
	end
  end
  
  def create
    @message = Message.create(message:params[:message][:message], user_id: params[:user_id], sender_id: current_user.id)
	@success_bool = false
	if @message.save
	  @success_bool = true
	  Notification.create(user_id: params[:user_id], notification_type: "NEW MESSAGE", description: "#{current_user.first_name} #{@current_user.last_name} sent you a message.", link_url: "/messages")
	end
	respond_to do |format|
	  format.html
	  format.js
	end
  end
  
  def destroy
	@success_bool = false
	if Message.delete(params[:id])
	  @success_bool = true
	end
    respond_to do |format|
	  format.html
	  format.js
	end
  end	
end
