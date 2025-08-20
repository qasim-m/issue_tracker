class IssuesController < ApplicationController
  before_action :set_issue, only: %i[show edit update destroy]
  before_action :set_project, only: %i[new create edit update destroy]

  # GET /issues
  def index
    @issues = if params[:project_id]
                Issue.where(project_id: params[:project_id])
              else
                Issue.all
              end
  end

  # GET /issues/1
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new(project: @project)
    @users = User.all
  end

  # GET /issues/1/edit
  def edit
    @users = User.all
  end

  # POST /issues
  def create
    @issue = Issue.new(issue_params)
    @issue.project = @project if @project
    @issue.created_by = current_user.id

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @project, notice: "Issue was successfully created." }
      else
        @users = User.all
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: "Issue was successfully updated.", status: :see_other }
      else
        @users = User.all
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  def destroy
    @project = @issue.project
    @issue.destroy!
    respond_to do |format|
      format.html { redirect_to @project, notice: "Issue was successfully destroyed.", status: :see_other }
    end
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  # Only allow a list of trusted parameters through.
  def issue_params
    params.require(:issue).permit(:project_id, :title, :issue_number, :description, :status, :assigned_to)
  end
end
