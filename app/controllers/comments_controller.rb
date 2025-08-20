class CommentsController < ApplicationController
  before_action :set_issue, only: %i[new create]

  # GET /comments/new
  def new
    @comment = Comment.new(issue: @issue)
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