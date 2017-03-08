class NotificationsController < ApplicationController

def read
  @notification = Notification.find(params[:id])
  @notification.update(read: true)
  redirect_to "#{@notification.link_url}"
end

end
