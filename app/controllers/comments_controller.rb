class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: :destroy

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "comment_form_errors",
            partial: "comments/errors",
            locals: { comment: @comment }
          )
        end
        format.html { redirect_to @post, alert: @comment.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    unless current_user.admin? || @comment.user == current_user
      return redirect_to @post, alert: "Not authorized."
    end

    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "Comment removed.", status: :see_other }
    end
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body, :parent_id)
    end
end
