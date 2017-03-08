class PostsController < ApplicationController
	
  def create
    @workout = Workout.find(params[:workout_id])
    @rep_vals = params[:post][:results_attributes].values
    @has_blanks = false
    @all_zero = true
    @rep_vals.each do |rep|
      if rep == nil or rep == ""
        @has_blanks = true
      elsif rep.to_i != 0
        @all_zero = false
      end
    end
    if @has_blanks
      flash[:alert] = "Results fields cannot be left blank; please resubmit your results."
    elsif @all_zero
      flash[:alert] = "Post was not saved; you cannot post results if no exercise reps have been completed."
    else
	 if @workout.start_date <= Date.today && @workout.end_date >= Date.today
	   @current_boolean = true
	 else
	   @current_boolean = false
	 end
      @post = Post.create(workout_id: params[:workout_id], user_id: current_user.id, comment: params[:post][:comment], current: @current_boolean)
      if @post.save
        @results_error = false
        @workout.exercises.each do |exercise|
            @reps = params[:post][:results_attributes][exercise.id.to_s]
            @result = Result.create(workout_id: @workout.id, exercise_id: exercise.id, post_id: @post.id, reps: @reps, user_id: current_user.id)
            if @result.save == false
              @results_error = true
            end
        end
        if @results_error
          Post.delete(@post.id)
          flash[:alert] = "Your results could not be saved. Please try again later."
        else
          flash[:notice] = "/results/post/#{@post.id}/user/#{current_user.id}?back_to=all"
        end
      else
        flash[:alert] = "Your results could not be saved. Please try again later."
      end
    end

    if params[:redirect_url] == "current"
      redirect_to "/current/#{@workout.workout_length}"
    else
      redirect_to "/workouts/#{@workout.id}"
    end

  end

  def edit
    @results = Result.joins("JOIN exercises ON results.exercise_id = exercises.id").where(post_id: params[:post_id], user_id: current_user.id).select(:exercise_description,
	:points, :reps, :id)
    @post = Post.find(params[:post_id])
    @workout = Workout.find(@post.workout_id)
      respond_to do |format|
        format.html
        format.js
	 end
  end
	
  def update
    @rep_vals = params[:post][:results_attributes].values
    @has_blanks = false
    @all_zero = true
    @rep_vals.each do |rep|
      if rep == nil or rep == ""
        @has_blanks = true
      elsif rep.to_i != 0
        @all_zero = false
      end
    end
    if @has_blanks
      flash[:alert] = "Results fields cannot be left blank; edits were not saved."
    elsif @all_zero
      flash[:alert] = "You cannot post results if no exercise reps have been completed; edits were not saved."
    elsif params[:post][:comment].length > 140
      flash[:alert] = "Comments cannot exceed 140 characters; edits were not saved."
    else
      @post_bool = Post.find(params[:post_id]).update(comment: params[:post][:comment])
      if @post_bool
        @post = Post.find(params[:post_id])
        @results_error = false
        @post.results.each do |result|
            @result_bool = Result.find(result.id).update(reps: params[:post][:results_attributes][result.id.to_s].to_i)
            if @result_bool == false
              @results_error = true
            end
        end
        if @results_error == true
          flash[:alert] = "Your changes could not be saved. Please try again later."
        else
          flash[:notice] = "Changes saved!"
        end

      else
        flash[:alert] = "Your changes could not be saved. Please try again later."
      end
    end

    redirect_to "/results/post/#{params[:post_id]}/user/#{current_user.id}?back_to=all"
  end

  def destroy
    @post = Post.find_by_id(params[:post_id]).destroy
    if @post.save
      flash[:notice] = "Results successfully deleted."
      redirect_to "/results/all"
    else
      flash[:alert] = "Results could not be deleted; please try again later."
      redirect_to "results/post/#{params[:post_id]}/user/#{current_user.id}"
    end
  end

end
