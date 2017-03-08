class UsersController < ApplicationController
def new
  @user = User.new
  @states = state_list
end

def edit
  @user = User.find(current_user)
  @states = state_list
  @emoji_array = [":grinning:", ":stuck_out_tongue:", ":sunglasses:", ":money_mouth_face:", ":heart_eyes:",
                  ":wink:", ":stuck_out_tongue_closed_eyes:", ":nerd_face:", ":upside_down_face:",
                  ":kissing_smiling_eyes:", ":smiling_imp:", ":sleeping:", ":stuck_out_tongue_winking_eye:", ":joy:", ":innocent:", ":no_mouth:", ":man::skin-tone-5:",
                  ":boy::skin-tone-6:", ":woman::skin-tone-4:", ":woman::skin-tone-6", ":santa::skin-tone-4:", ":robot_face:", ":alien:", ":snowman:"]
end

def update
    @user = User.find(current_user)
    if @user.update_attributes(user_update_params)
  	flash[:notice] = "Settings updated successfully!"
    else
      if @user.errors.any?
        errorString = @user.errors.full_messages[0]
        flash[:alert] = errorString + "."
    else
      flash[:alert] = "Could not save settings; please try again later."
    end

    end
    respond_to do |format|
      format.html
      format.js { render :js => "window.location = '/profile/settings'"}
    end
    
end

def create
  @user = User.new(user_params)
  if @user.save 
    session[:user_id] = @user.id
    Notification.create(user_id: @user.id, notification_type: "WELCOME", description: "Welcome to Asiki Fitness! We hope you enjoy our social workout system. Before you get started, we recommend you check out your profile settings.", link_url: "/profile/settings")

    @invitations = Invitation.where(email: @user.email)
    if @invitations != nil
	 @invitations.each do |invite|
	   @contest = Contest.find_by_id(invite.contest_id)
  	   @contestant = Contestant.create(contest_id: @contest.id, user_id: @user.id)
	   @inviter = User.find_by_id(@contest.user_id)
	   @inviter_name = @inviter.first_name+' '+ @inviter.last_name[0,1].upcase+'.'
        Notification.create(user_id: @user.id, notification_type: "INVITATION", description: "#{@inviter_name} has invited you to join a new contest!", link_url: "/contests/#{@contest.id}")
        Invitation.destroy(invite.id)
      end
    end
	
	@friend_invites = FriendInvitation.where(email: @user.email)
    if @friend_invites != nil
	 @friend_invites.each do |friend|
	   @inviter = User.find_by_id(friend.user_id)
	   @inviter_name = @inviter.first_name+' '+ @inviter.last_name[0,1].upcase+'.'
	   @friend1 = Friend.create(user_id: friend.user_id, friend_id: @user.id, status: 'requested')
	   @friend2 = Friend.create(user_id: @user.id, friend_id: friend.user_id, status: 'pending')
	   if @friend1.save && @friend2.save
	     Notification.create(user_id: @user.id, notification_type: "FRIEND REQUEST", description: "#{@inviter_name} wants to be your fitness friend!", link_url: "/friends")
	     FriendInvitation.destroy(friend.id)
	   end
      end
    end
	
    flash[:notice] = "Account created successfully. Welcome to Asiki, "+@user[:first_name]+"!"
    redirect_to '/workouts' 
  else
    if @user.errors.any?
      errorString = @user.errors.full_messages[0]
      flash[:alert] = errorString + "."
      redirect_to '/signup'
    else
      flash[:alert] = "Error creating new account. Please try again."
    end
  end 
end

def profile
  if params[:user] == nil
    @user = User.find(current_user.id)
	@total_workouts = @user.posts.count
  else
    @user = User.find_by_id(params[:user].to_i)
	@total_workouts = @user.posts.count
  end
  if @user
    @user_id = @user.id
    @minuteWeek = ActiveRecord::Base.connection.execute(minutes_week_sql)
    @minute30 = ActiveRecord::Base.connection.execute(minutes_30_sql)
    @minute60 = ActiveRecord::Base.connection.execute(minutes_60_sql)
    @pointWeek = ActiveRecord::Base.connection.execute(points_week_sql)
    @point30 = ActiveRecord::Base.connection.execute(points_30_sql)
    @point60 = ActiveRecord::Base.connection.execute(points_60_sql)
    @start_date = @user.created_at.to_date
    @days_since_start = Date.today - @start_date
    @use_months = false
    if @days_since_start.to_i > 62
      @pointAll = ActiveRecord::Base.connection.execute(points_all_months_sql)
      @minuteAll = ActiveRecord::Base.connection.execute(minutes_all_months_sql)
      @use_months = true
    else
      @pointAll = ActiveRecord::Base.connection.execute(points_all_days_sql)
      @minuteAll = ActiveRecord::Base.connection.execute(minutes_all_days_sql)
    end
	@friendHash = Hash[@user.friends.select([:id, :friend_id, :status]).map{|i|[i.friend_id, i]}]
    @minuteWeekSum = getSum(@minuteWeek)
    @minute30Sum = getSum(@minute30)
    @minute60Sum = getSum(@minute60)
    @minuteAllSum = getSum(@minuteAll)
    @pointWeekSum = getSum(@pointWeek)
    @point30Sum = getSum(@point30)
    @point60Sum = getSum(@point60)
    @pointAllSum = getSum(@pointAll)
    @friends = @user.friends.where(status: 'accepted').joins("JOIN users ON users.id = friends.friend_id LEFT JOIN posts ON posts.user_id = friends.friend_id").select([:id, :friend_id, :first_name, :last_name, :state, "COUNT(posts.id) AS workouts"]).group([:id, :friend_id, :first_name, :last_name, :state]).limit(9)
    @total_friends = @friends.length
  end
end

private

def getSum(inputHash)
  total = 0
  inputHash.each do |x|
    total += x["total"].to_i
  end
  total
end 

def user_params
	params.require(:user).permit(:first_name, :last_name, :email, :state, :password).merge(results_settings: "Public", gravatar_bool: false, emoji_title: ":grinning:")
end

def user_update_params
	params.require(:user).permit(:first_name, :last_name, :state, :results_settings, :gravatar_bool, :emoji_title, :gravatar)
end

def state_list
["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida",
"Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
"Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
"New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
"South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
end

def minutes_week_sql
"WITH minutes_table AS (SELECT SUM(workout_length) AS total, Date(posts.created_at) AS create_date 
FROM posts 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE posts.user_id = #{@user.id} 
GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 6}', '#{Date.today}', '1 day'::interval))::date AS calc_date) 
SELECT to_char(calc_date,'Day') AS given_date, total 
FROM dates_table 
LEFT JOIN minutes_table ON minutes_table.create_date = dates_table.calc_date"
end

def minutes_30_sql
"WITH minutes_table AS (SELECT SUM(workout_length) AS total, Date(posts.created_at) AS create_date 
FROM posts 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE posts.user_id = #{@user.id} 
GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 29}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table 
LEFT JOIN minutes_table ON minutes_table.create_date = dates_table.given_date"
end

def minutes_60_sql
"WITH minutes_table AS (SELECT SUM(workout_length) AS total, Date(posts.created_at) AS create_date 
FROM posts 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE posts.user_id = #{@user.id} 
GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 59}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table 
LEFT JOIN minutes_table ON minutes_table.create_date = dates_table.given_date"
end

def minutes_all_days_sql
"WITH minutes_table AS (SELECT SUM(workout_length) AS total, Date(posts.created_at) AS create_date 
FROM posts 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE posts.user_id = #{@user.id} 
GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{@start_date}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table 
LEFT JOIN minutes_table ON minutes_table.create_date = dates_table.given_date"
end

def minutes_all_months_sql
"WITH minutes_table AS (SELECT SUM(workout_length) AS total, to_char(posts.created_at,'Mon-YYYY') AS create_date 
FROM posts 
JOIN workouts ON posts.workout_id = workouts.id 
WHERE posts.user_id = #{@user.id} 
GROUP BY create_date), 
dates_table AS (SELECT to_char((GENERATE_SERIES('#{@start_date.strftime('%Y-%m')+'-01'}', '#{Date.today.strftime('%Y-%m')+'-01'}', '1 month'::interval))::date, 'Mon-YYYY') AS given_date) 
SELECT given_date, total 
FROM dates_table 
LEFT JOIN minutes_table ON minutes_table.create_date = dates_table.given_date"
end

def points_week_sql
"WITH points_table AS 
(SELECT SUM(points * reps) AS total, Date(results.created_at) AS create_date 
FROM results JOIN exercises on results.exercise_id = exercises.id 
WHERE results.user_id = #{@user.id} GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 6}', '#{Date.today}', '1 day'::interval))::date AS calc_date) 
SELECT to_char(calc_date,'day') AS given_date, total 
FROM dates_table 
LEFT JOIN points_table ON points_table.create_date = dates_table.calc_date"
end

def points_30_sql
"WITH points_table AS 
(SELECT SUM(points * reps) AS total, Date(results.created_at) AS create_date 
FROM results JOIN exercises on results.exercise_id = exercises.id 
WHERE results.user_id = #{@user.id} GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 29}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table
LEFT JOIN points_table ON points_table.create_date = dates_table.given_date"
end

def points_60_sql
"WITH points_table AS 
(SELECT SUM(points * reps) AS total, Date(results.created_at) AS create_date 
FROM results JOIN exercises on results.exercise_id = exercises.id 
WHERE results.user_id = #{@user.id} GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{Date.today - 59}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table
LEFT JOIN points_table ON points_table.create_date = dates_table.given_date"
end

def points_all_days_sql
"WITH points_table AS 
(SELECT SUM(points * reps) AS total, Date(results.created_at) AS create_date 
FROM results JOIN exercises on results.exercise_id = exercises.id 
WHERE results.user_id = #{@user.id} GROUP BY create_date), 
dates_table AS (SELECT (GENERATE_SERIES('#{@start_date}', '#{Date.today}', '1 day'::interval))::date AS given_date) 
SELECT given_date, total 
FROM dates_table
LEFT JOIN points_table ON points_table.create_date = dates_table.given_date"
end

def points_all_months_sql
"WITH points_table AS 
(SELECT SUM(points * reps) AS total, to_char(results.created_at,'Mon-YYYY') AS create_date 
FROM results JOIN exercises on results.exercise_id = exercises.id 
WHERE results.user_id = #{@user.id} GROUP BY create_date),
dates_table AS (SELECT to_char((GENERATE_SERIES('#{@start_date.strftime('%Y-%m')+'-01'}', '#{Date.today.strftime('%Y-%m')+'-01'}', '1 month'::interval))::date, 'Mon-YYYY') AS given_date) 
SELECT given_date, total 
FROM dates_table 
LEFT JOIN points_table ON points_table.create_date = dates_table.given_date"
end

end
