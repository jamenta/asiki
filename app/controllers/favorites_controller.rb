class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.create(user_id: current_user.id, post_id: params[:post_id])
	@total = params[:total].to_i
	if @favorite.save
	  @post = Post.joins("JOIN users ON users.id = posts.user_id").select(:user_id, :first_name, :last_name).find(params[:post_id])
	  @total += 1
	  if @post.user_id != current_user.id
	    @notification_bool = Notification.where(user_id: @post.user_id, link_url: "/results/post/#{params[:post_id]}/user/#{@post.user_id}?back_to=all").first
		if @notification_bool == nil
	      Notification.create(user_id: @post.user_id, notification_type: "FAVORITE", description: "#{current_user.first_name} #{@current_user.last_name} liked your workout result.", link_url: "/results/post/#{params[:post_id]}/user/#{@post.user_id}?back_to=all")
	    end
	  end
	end
	respond_to do |format|
	  format.html 
	  format.js 
	end
  end
  
  def destroy
    @favorite = Favorite.find(params[:id])
	@post_id = @favorite.post_id
	@total = params[:total].to_i
	@total -= 1
	@favorite.delete
	respond_to do |format|
	  format.html 
	  format.js 
	end
  end
end
