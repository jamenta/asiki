class ContestsController < ApplicationController
def new
 @contest = Contest.new
 @emoji_array = emojis
end

def edit
 @contest = Contest.find_by_id(params[:id])
 @emoji_array = emojis
end

def update
 @contest = Contest.find(params[:id])
 if params[:contest][:contest_name].length > 30
   flash[:alert] = "Contest name cannot exceed 30 characters. Please try again."
   redirect_to "/contests/#{@contest.id}/settings"
 elsif params[:contest][:contest_name].length < 1
   flash[:alert] = "Contest name cannot be blank. Please try again."
    redirect_to "/contests/#{@contest.id}/settings"
 elsif params[:contest][:start_date] == nil || params[:contest][:start_date] == ""
   flash[:alert] = "Contest dates must be populated. Please try again."
   redirect_to "/contests/#{@contest.id}/settings"
 elsif params[:contest][:end_date] == nil || params[:contest][:end_date] == ""
   flash[:alert] = "Contest dates must be populated. Please try again."
   redirect_to "/contests/#{@contest.id}/settings"
 elsif params[:contest][:end_date].to_date < params[:contest][:start_date].to_date
   flash[:alert] = "Contest end date cannot be before the start date. Please try again."
   redirect_to "/contests/#{@contest.id}/settings"
 elsif params[:contest][:end_date].to_date < @contest.created_at
   flash[:alert] = "Contest end date cannot be a date before the contest was created. Please try again."
   redirect_to "/contests/#{@contest.id}/settings"
 else
   if @contest.update_attributes(contest_update_params)
    flash[:notice] = "Settings updated successfully!"
    redirect_to "/contests/#{@contest.id}"
   else
    flash[:alert] = @contest.errors.full_messages[0]
    redirect_to "/contests/#{@contest.id}/settings"
   end
 end
 respond_to do |format|
   format.html
   format.js
 end
end

def show
 @contest = Contest.find_by_id(params[:id])
  if @contest != nil
   @contestants = Contestant.joins("JOIN contests ON contests.id = contestants.contest_id JOIN users on contestants.user_id = users.id").where(accepted: true,
			      contest_id: @contest.id).select(:first_name, :last_name, :user_id, :accepted)
   @contestantHash = Hash[Contestant.joins("JOIN contests ON contests.id = contestants.contest_id 
					JOIN users on contestants.user_id = users.id").where(contest_id: @contest.id).select(:first_name, 
					:last_name, :user_id, :accepted, :id).map{|i|[i.user_id, i]}]
   @thisContestant = @contestantHash[current_user.id]
   @comments = ContestComment.joins("JOIN contests ON contests.id = contest_comments.id JOIN users ON contest_comments.user_id = users.id").where(
     contest_id: @contest.id).select(:comment, :first_name, :last_name, :created_at, :user_id, :contest_id).order(created_at: :desc)
   @outstanding_users = Contestant.joins("JOIN contests ON contests.id = contestants.contest_id JOIN users on contestants.user_id = users.id").where(accepted: nil,
     contest_id: @contest.id).select(:first_name, :last_name, :user_id)
   @leaderboards = ActiveRecord::Base.connection.execute(contest_leaderboard_sql)
   @outstanding_invites = @contest.invitations
   @workouts_array = [1,3,5,10]
   @top_performers = {}
   @workouts_array.each do |w|
     @iterator = w
     @query_result = ActiveRecord::Base.connection.execute(top_performer_sql)
	 if @query_result.ntuples.to_i > 0
	   @top_performers[w] = @query_result[0]
	 end
   end
  end
end

def create
 if params[:contest][:contest_name].length > 30
   flash[:alert] = "Contest name cannot exceed 30 characters. Please try again."
   redirect_to '/contests/new'
 elsif params[:contest][:contest_name].length < 1
   flash[:alert] = "Contest name cannot be blank. Please try again."
    redirect_to '/contests/new'
 elsif params[:contest][:start_date] == nil || params[:contest][:start_date] == ""
   flash[:alert] = "Contest dates must be populated. Please try again."
   redirect_to '/contests/new'
 elsif params[:contest][:end_date] == nil || params[:contest][:end_date] == ""
   flash[:alert] = "Contest dates must be populated. Please try again."
   redirect_to '/contests/new'
 elsif params[:contest][:end_date].to_date < params[:contest][:start_date].to_date
   flash[:alert] = "Contest end date cannot be before the start date. Please try again."
   redirect_to '/contests/new'
 elsif params[:contest][:end_date].to_date < Date.today
   flash[:alert] = "Contest end date cannot be in the past. Please try again."
   redirect_to '/contests/new'
 else
   @contest = Contest.create(contest_params)
   if @contest.save
     flash[:notice] = "New contest was created!"
     redirect_to "/contests/#{@contest.id}"
   else
     flash[:alert] = "Contest could not be created. Please try again later."
     redirect_to '/contests/new'
   end
 end
 respond_to do |format|
   format.html
   format.js
 end
end

def index
 @today = Date.today
 @contests = ActiveRecord::Base.connection.execute(contest_query_sql)
end

def destroy
 @contest = Contest.destroy(params[:id])
 if @contest.save
  flash[:notice] = "Contest successfully deleted."
  redirect_to "/contests"
 end
end

private

def contest_update_params
  params.require(:contest).permit(:contest_name, :start_date, :end_date, :emoji_title)
end

def contest_params
  params.require(:contest).permit(:contest_name, :start_date, :end_date, :emoji_title).merge(user_id: current_user.id, contestants_attributes: [user_id: current_user.id, accepted: true])
end

def contest_query_sql
  "SELECT contests.contest_name, contests.id, contests.start_date, contests.emoji_title, contests.end_date, CASE WHEN contests.end_date < '#{@today}' THEN 3 ELSE CASE WHEN contests.start_date > '#{@today}' THEN 2 ELSE 1 END END AS status FROM contests JOIN contestants ON contests.id = contestants.contest_id WHERE contestants.user_id = #{current_user.id} ORDER BY status, contests.start_date"
end

def contest_leaderboard_sql
"WITH minutes_table AS 
(SELECT SUM(workout_length) AS total_minutes, posts.user_id AS minutes_user 
FROM workouts JOIN posts ON posts.workout_id = workouts.id 
JOIN contestants ON contestants.user_id = posts.user_id 
JOIN contests ON contests.id = contestants.contest_id 
WHERE contests.id = #{@contest.id} AND contestants.accepted = true 
AND Date(posts.created_at) >= '#{@contest.start_date}' AND Date(posts.created_at) <= '#{@contest.end_date}' 
AND posts.current = true GROUP BY minutes_user), 
points_table AS 
(SELECT SUM(reps * points) AS total_points, contestants.user_id AS points_user 
FROM contests 
JOIN contestants ON contestants.contest_id = contests.id 
JOIN results ON contestants.user_id = results.user_id 
JOIN exercises ON exercises.id = results.exercise_id 
JOIN posts ON posts.id = results.post_id 
WHERE contests.id = #{@contest.id} AND contestants.accepted = true AND Date(posts.created_at) >= '#{@contest.start_date}' 
AND Date(posts.created_at) <= '#{@contest.end_date}' AND posts.current = true 
GROUP BY points_user) 
SELECT minutes_table.total_minutes, points_table.total_points, points_table.points_user, users.first_name, users.last_name, users.state, 
(SELECT (COUNT (*) + 1) FROM points_table AS subrank 
WHERE subrank.total_points > points_table.total_points) AS rank 
FROM points_table 
JOIN minutes_table ON minutes_table.minutes_user = points_table.points_user 
JOIN users ON users.id = points_table.points_user 
ORDER BY total_points DESC"
end

def top_performer_sql
"SELECT posts.user_id, users.first_name, users.last_name, posts.id as post_id, 
SUM(results.reps * exercises.points) AS total_points, posts.created_at 
FROM results JOIN posts on posts.id = results.post_id 
JOIN workouts ON workouts.id = posts.workout_id 
JOIN exercises ON results.exercise_id = exercises.id 
JOIN users ON users.id = posts.user_id 
JOIN contestants ON contestants.user_id = posts.user_id 
JOIN contests ON contests.id = contestants.contest_id 
WHERE users.results_settings = 'Public' AND workouts.workout_length = #{@iterator} 
AND contests.id = #{@contest.id} AND contestants.accepted = true 
AND Date(posts.created_at) >= '#{@contest.start_date}' 
AND Date(posts.created_at) <= '#{@contest.end_date}' 
AND posts.current = true 
GROUP BY posts.user_id, posts.id, users.first_name, users.last_name
ORDER BY total_points DESC, posts.created_at DESC LIMIT 1"
end

def emojis
[":earth_americas:", ":flag-us:", ":fire:", ":skull:", ":100:",
  ":see_no_evil:", ":penguin:", ":sun_with_face:", ":full_moon_with_face:",
  ":jack_o_lantern:", ":taco:", ":dart:", ":moneybag:", ":beer:"]
end

end
