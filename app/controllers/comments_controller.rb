class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_issue, only: %i[new create]

  # GET /comments or /comments.json
  def index
    @comments = if params[:issue_id]
      Comment.where(issue_id: params[:issue_id])
    else
      Comment.all
    end
  end

  # GET /comments/1
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new(issue: @issue)
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.issue = @issue if @issue
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @issue, notice: "Comment was successfully created." }
      else
        @issue = @comment.issue
        format.html { render "issues/show", status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to comments_path, notice: "Comment was successfully destroyed.", status: :see_other }
    end
  end

  private

	def set_comment
		@comment = Comment.find(params[:id])
	end

	def set_issue
		@issue = Issue.find(params[:issue_id]) if params[:issue_id]
	end

	# Only allow a list of trusted parameters through.
	def comment_params
		params.require(:comment).permit(:text, :issue_id, :user_id)
	end
end