class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @comment = @project.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to @project, notice: 'Comment added.'
    else
      flash.now[:alert] = 'There was an error adding your comment.'
      render 'projects/show', status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
