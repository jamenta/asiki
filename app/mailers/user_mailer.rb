class UserMailer < ApplicationMailer
  default from: 'notifications@asikifitness.com'
 
  def welcome_email(user_input)
    @mailer_user = user_input
    @url  = 'https://glacial-caverns-12925.herokuapp.com'
    mail(to: @mailer_user.email, subject: 'Welcome to Asiki Fitness!')
  end
  
  def friend_request_email(email_string)
    @email_address = email_string
	@url_value  = 'https://glacial-caverns-12925.herokuapp.com'
  end
end
