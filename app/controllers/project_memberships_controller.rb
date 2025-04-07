class ProjectMembershipsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!
  before_action :set_project

  def new
    @project_membership = @project.project_memberships.new
    @available_users = User.where.not(id: @project.users.pluck(:id)) # Get users not already in the project
  end

  def create
    user_ids = params[:user][:user_ids]

    if user_ids.present?
      added_count = 0
      user_ids.each do |user_id|
        user = User.find_by(id: user_id)
        if user && !@project.users.include?(user)
          @project.project_memberships.create(user: user)
          added_count += 1
        end
      end

      if added_count > 0
        redirect_to @project, notice: "#{pluralize(added_count, 'member')} added to the project."
      else
        redirect_to @project, alert: "No new members were added."
      end
    else
      redirect_to @project, alert: "Please select at least one user to add."
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
