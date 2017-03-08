class LeaderboardsController < ApplicationController

	def all
	  @today = Date.today
	  @top_results = ActiveRecord::Base.connection.execute(top_results_sql)
	  @workouts_array = [1,3,5,10]
	  @top_performers = {}
	  @workouts_array.each do |w|
	    @iterator = w
		@query_result = ActiveRecord::Base.connection.execute(top_performer_sql)
	    if @query_result.ntuples.to_i > 0
	     @top_performers[w] = @query_result[0]
	    end
	  end
       if current_user
	    if current_user.results_settings == 'Public'
	      @user_id = current_user.id
	      @user_rank = ActiveRecord::Base.connection.execute(user_rank_sql)
	      if @user_rank.ntuples.to_i > 0
		   @user_rank = @user_rank[0]["user_rank"]
	      else
		   @user_rank = "N/A"
	      end
         end
       end
	end

private

def top_results_sql
"WITH minute_table AS (SELECT SUM(workout_length) as total_mins, posts.user_id AS user_id 
FROM posts 
JOIN users ON posts.user_id = users.id 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE users.results_settings = 'Public' AND workouts.start_date <= '#{@today}' AND workouts.end_date >= '#{@today}' 
GROUP BY posts.user_id), 
points_table AS (SELECT SUM(points * reps) as total_points, user_id, first_name, last_name, state 
FROM results JOIN exercises on results.exercise_id = exercises.id 
JOIN workouts on results.workout_id = workouts.id 
JOIN users ON results.user_id = users.id 
WHERE workouts.start_date <= '#{@today}' 
AND workouts.end_date >= '#{@today}' 
AND users.results_settings = 'Public' 
GROUP BY user_id, first_name, last_name, state) 
SELECT points_table.first_name, points_table.last_name, points_table.state, points_table.total_points, points_table.user_id, minute_table.total_mins, 
(SELECT (COUNT (*) + 1) FROM points_table AS subrank 
WHERE subrank.total_points > points_table.total_points) AS rank 
FROM minute_table JOIN points_table ON minute_table.user_id = points_table.user_id 
ORDER BY total_points DESC LIMIT 25"
end

def user_rank_sql
"WITH rank_table AS (SELECT SUM(points * reps) as total_points, user_id 
FROM results JOIN exercises on results.exercise_id = exercises.id JOIN workouts on results.workout_id = workouts.id 
JOIN users on results.user_id = users.id WHERE workouts.start_date <= '#{@today}' 
AND workouts.end_date >= '#{@today}' AND users.results_settings = 'Public' GROUP BY user_id) 
SELECT (SELECT(COUNT(*)+1) FROM rank_table AS subrank WHERE subrank.total_points > rank_table.total_points) as user_rank 
FROM rank_table WHERE rank_table.user_id = #{@user_id}"
end

def top_performer_sql
"SELECT posts.user_id, users.first_name, users.last_name, posts.id as post_id, 
SUM(results.reps * exercises.points) AS total_points, posts.created_at 
FROM results JOIN posts on posts.id = results.post_id 
JOIN workouts ON workouts.id = posts.workout_id JOIN exercises ON results.exercise_id = exercises.id 
JOIN users ON users.id = posts.user_id WHERE users.results_settings = 'Public' 
AND workouts.workout_length = #{@iterator} AND workouts.start_date <= '#{@today}' 
AND workouts.end_date >= '#{@today}' 
GROUP BY posts.user_id, posts.id, users.first_name, users.last_name 
ORDER BY total_points DESC, posts.created_at DESC LIMIT 1"
end

end
