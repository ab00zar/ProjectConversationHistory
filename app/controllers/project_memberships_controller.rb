class ProjectMembershipsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!
  before_action :set_project

  def new
    @project_membership = @project.project_memberships.new
    @available_users = User.where.not(id: @project.users.pluck(:id))
  end

  def create
    user_ids = params.dig(:user, :user_ids)

    if user_ids.present?
      result = ProjectMembershipService.add_members_to_project(@project, user_ids)

      if result[:success]
        redirect_to @project, notice: "#{pluralize(result[:added_count], 'member')} added to the project."
      else
        redirect_to @project, alert: result[:error] || "No new members were added."
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
