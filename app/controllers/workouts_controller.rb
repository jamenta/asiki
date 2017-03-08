class WorkoutsController < ApplicationController
	def home
	  @today = Date.today
	  @workout_array = [1,3,5,10]
	  @workouts = {}
	  @workout_array.each do |w|
         @workouts[w] = Workout.where('start_date <= ? AND end_date >= ? AND workout_length = ?', @today, @today, w).first
	    if @workouts[w] == nil
	       @workouts[w] = {}
	       @workouts[w][:short_description] = "N/A"
	       @workouts[w][:image_url] = ""
	       @workouts[w][:gif_url] = ""
	    end
	  end
      respond_to do |format|
        format.html
        format.js
      end
	end

	def index
	  @items_per_page = 20
	  @start = params[:start].to_i
	  if @start == nil
	    @start = 0
	  end
	  @workouts = Workout.all.order("start_date DESC").limit(@items_per_page).offset(@start)
  	  @count = Workout.all.count
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
	end

	def new
	  @workout = Workout.new
	  3.times { @workout.exercises.build }
	end

	def create
	  @workout = Workout.new(workout_params)
	  if @workout.save
	    if @workout.rounds == true
	      @total_points = 0
	      @workout.exercises.each do |x|
	        @total_points += (x.points * x.reps_per_round)
	      end
	      @exercise = Exercise.create(workout_id: @workout.id, exercise_description: "Total rounds", points: @total_points, reps_per_round: nil)
	      if @exercise
	        flash[:notice] = "Workout created successfully!"
	        redirect_to @workout
	      else
	        @workout.delete
	        flash[:alert] = "Workout could not be saved."
	        redirect_to "workouts/new"
	      end
	    else
	      flash[:notice] = "Workout created successfully!"
	      redirect_to @workout
	    end
	  else
	    flash[:alert] = "Workout could not be saved."
	    redirect_to "workouts/new"	
	  end
	end

	def show
		@workout = Workout.find_by_id(params[:id])
	end

	def current
	    @today = Date.today
	    @workout = Workout.where('start_date <= ? AND end_date >= ? AND workout_length = ?', @today, @today, params[:workout_length]).first
	end

private

def workout_params
	params.require(:workout).permit(:workout_length, :short_description, :long_description, :image_url, :video_url, :gif_url, :start_date, :end_date, :rounds, exercises_attributes: [:exercise_description, :points, :reps_per_round])
end


end
