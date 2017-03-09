class ArticlesController < ApplicationController
def contests
UserMailer.welcome_email(current_user).deliver_now
end
end
