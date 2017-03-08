class SessionsController < ApplicationController

def create
  @user = User.find_by_email(params[:session][:email].downcase)
  if @user && @user.authenticate(params[:session][:password])
    session[:user_id] = @user.id
    flash[:notice] = "Welcome to Asiki, "+@user[:first_name]+"!"
    redirect_to '/workouts'
  else
    flash[:alert] = "Invalid username or password. Please try again."
    redirect_to '/login'
  end 
end

def destroy 
  session[:user_id] = nil
  flash[:notice] = "Logged out successfully."
  redirect_to '/' 
end
end
