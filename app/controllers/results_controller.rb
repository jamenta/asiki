class ResultsController < ApplicationController

	def index
      if params[:user] == nil
        @user = User.find(current_user.id)
      else
        @user = User.find_by_id(params[:user].to_i)
      end
      if @user
	    @items_per_page = 25
	    @start = params[:start].to_i
	    if @start == nil
	      @start = 0
	    end
        if params[:start_date] == nil
           @start_date = Date.today
        else
          @start_date = params[:start_date]
        end
        if params[:end_date] == nil
           @end_date = Date.today
        else
           @end_date = params[:end_date]
        end
	
        if params[:current] == "true"
			@workouts = Result.joins("JOIN posts ON results.post_id = posts.id JOIN workouts 
			ON results.workout_id = workouts.id JOIN exercises ON exercises.id = results.exercise_id").where("posts.current = true AND posts.user_id = #{@user.id} AND 
			Date(posts.created_at) <= '#{@end_date}' AND Date(posts.created_at) >= '#{@start_date}'").select("SUM(points * reps) as total_points, 
			posts.created_at AS create_date, short_description, workout_length, results.post_id as post_id, 
			results.user_id").group("create_date, short_description, workout_length, results.post_id, 
			results.user_id").order("posts.created_at DESC").limit(@items_per_page).offset(@start)
			
		    @count = Post.where("posts.current = true AND posts.user_id = #{@user.id} AND Date(posts.created_at) <= '#{@end_date}' AND Date(posts.created_at) >= '#{@start_date}'").count
			
		    @current_bool = "true"
        else
			@workouts = Result.joins("JOIN posts ON results.post_id = posts.id JOIN workouts 
			ON results.workout_id = workouts.id JOIN exercises ON exercises.id = results.exercise_id").where("posts.user_id = #{@user.id} AND 
			Date(posts.created_at) <= '#{@end_date}' AND Date(posts.created_at) >= '#{@start_date}'").select("SUM(points * reps) as total_points, 
			posts.created_at AS create_date, short_description, workout_length, results.post_id as post_id, 
			results.user_id").group("create_date, short_description, workout_length, results.post_id, 
			results.user_id").order("posts.created_at DESC").limit(@items_per_page).offset(@start)
		    @count = Post.where("posts.user_id = #{@user.id} AND Date(posts.created_at) <= '#{@end_date}' AND Date(posts.created_at) >= '#{@start_date}'").count
		    @current_bool = "false"
        end

	    @total_pages = (@count/@items_per_page.to_f).ceil
	    @active_page = (@start/@items_per_page.to_f).ceil
	    if @start - @items_per_page < 0
	      @prev_val = 0
	    else
	      @prev_val = @start - @items_per_page
	    end
	    if @start + @items_per_page > @count - 1
	      @next_val = @count - 1
	    else
	      @next_val = @start + @items_per_page
	    end
	    @back_to = "index"
	  end
	end

    def all
      if params[:user] == nil
        @user = User.find(current_user.id)
      else
        @user = User.find_by_id(params[:user].to_i)
      end
      if @user
	    @items_per_page = 25
	    @start = params[:start].to_i
	    if @start == nil
	      @start = 0
	    end
	    @workouts = Result.joins("JOIN posts ON results.post_id = posts.id JOIN workouts 
		ON results.workout_id = workouts.id JOIN exercises ON exercises.id = results.exercise_id").where(user_id: @user.id).select("SUM(points * reps) as total_points, 
		posts.created_at AS create_date, short_description, workout_length, results.post_id as post_id, results.user_id").group("create_date, short_description, workout_length, results.post_id, results.user_id").order("posts.created_at DESC").limit(@items_per_page).offset(@start)
		
  	    @count = Post.where(user_id: @user.id).count
	    @total_pages = (@count/@items_per_page.to_f).ceil
	    @active_page = (@start/@items_per_page.to_f).ceil
	    if @start - @items_per_page < 0
	      @prev_val = 0
	    else
	      @prev_val = @start - @items_per_page
	    end
	    if @start + @items_per_page > @count - 1
	      @next_val = @count - 1
	    else
	      @next_val = @start + @items_per_page
	    end
 	    @back_to = "all"
       end
    end

	def current
		@user = User.find_by_id(params[:user_id])
	    if @user
			@today = Date.today
			@workouts = Result.joins("JOIN exercises ON results.exercise_id = exercises.id JOIN workouts 
			ON results.workout_id = workouts.id").where("results.user_id = #{@user.id} AND workouts.start_date <= '#{@today}' AND workouts.end_date >= '#{@today}'").select("SUM(points * reps) as total_points, 
			Date(results.created_at) AS create_date, 
			short_description, workout_length, post_id, user_id").group(:short_description, :workout_length, 
			:post_id, :created_at, :user_id).order(created_at: :desc)
			@back_to = "current"
	    end
	end

	def show
	   if current_user
 	    @user = User.find(params[:user_id])
	    @post = Post.find(params[:post_id])
		@favorites = Post.joins("JOIN favorites ON favorites.post_id = posts.id JOIN users ON favorites.user_id = users.id").where(id: params[:post_id]).select("favorites.id as fav_id", :first_name, :last_name, "users.id as user_id")
	    @favHash = Hash[@favorites.map{|i|[i.user_id, i]}]
		@workout = Workout.find(@post.workout_id)
	    @back_to = params[:back_to]
	    if @back_to == "index"
           @start_date = params[:start_date]
           @end_date = params[:end_date]
         end
	    @results = Result.joins("JOIN exercises ON results.exercise_id = exercises.id").where(post_id: @post.id, user_id: @user.id).select(:exercise_description,
		:points, :reps, :id)
	    @comment = @post.comment
	    @pointTotal = 0
	    @results.each do |r|
	      @pointTotal += (r.points.to_i * r.reps.to_i)
	    end
	   end   
	end

  private
	  def result_params
	    params.require(:result).permit(:reps).merge(workout_id: @exercise.workout_id, user_id: current_user.id, post_id: @post_id, current: @current_boolean)
	  end

	  def show_current_sql
	    "SELECT SUM(points * reps) as total_points, strftime('%m-%d-%Y',results.created_at) as create_date, workouts.short_description, workouts.workout_length, results.post_id, results.user_id FROM results JOIN exercises on results.exercise_id = exercises.id JOIN workouts on results.workout_id = workouts.id WHERE workouts.start_date <= '#{@today}' AND workouts.end_date >= '#{@today}' AND results.user_id = #{params[:user_id]} GROUP BY workouts.short_description, workouts.workout_length, results.post_id ORDER BY results.created_at DESC"
	  end
	    
end
