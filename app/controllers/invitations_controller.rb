class InvitationsController < ApplicationController

 def destroy
  @invitations = ActiveRecord::Base.connection.execute(delete_invitations_sql)
 end

 private

 def delete_invitations_sql
   "DELETE FROM invitations WHERE expiration < date('now')"
 end

end
