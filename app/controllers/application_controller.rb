class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	#force_ssl

helper_method :current_user
helper_method :notifications
helper_method :unread_notifications
helper_method :contest_list

def current_user 
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end

def notifications
  @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc, read: :desc).limit(25)
end

def unread_notifications
  @unread_notifications = Notification.where(user_id: current_user.id, read: false).count
end

def contest_list
  @contest_list = ActiveRecord::Base.connection.execute(contest_list_sql)
end

def link_to_function(name, *args, &block)
   html_options = args.extract_options!.symbolize_keys
   function = block_given? ? update_page(&block) : args[0] || ''
   onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
   href = html_options[:href] || '#'
   content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
end

private

def contest_list_sql
"SELECT contests.contest_name, contests.id FROM contests JOIN contestants ON contestants.contest_id = contests.id WHERE contestants.user_id = #{current_user.id} AND contests.start_date <= '#{Date.today}' AND contests.end_date >= '#{Date.today}' ORDER BY contests.start_date LIMIT 10"
end


end
