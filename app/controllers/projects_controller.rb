class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def new
    @project = current_user.owned_projects.new
  end

  def create
    @project = current_user.owned_projects.new(project_params)
    if @project.save
      @project.project_memberships.create(user: current_user)
      redirect_to @project, notice: 'Project was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @new_comment = @project.comments.build
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed!'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end
end
