class ContestCommentsController < ApplicationController

  def create
    @contest_comment = ContestComment.create(comment_params)
    respond_to do |format|
      format.html { redirect_to "/contests/#{params[:id]}" }
      format.js
    end
  end

  def destroy
    @comment_id = params[:comment_id]
    @contest_comment = ContestComment.delete(params[:comment_id])
    respond_to do |format|
      format.html { redirect_to "/contests/#{params[:id]}" }
      format.js
    end
  end

  private

  def comment_params
    params.require(:contest_comment).permit(:comment).merge(user_id: current_user.id, contest_id: params[:id])
  end
end
