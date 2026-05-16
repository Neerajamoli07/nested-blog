class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_post, only: %i[ show edit update destroy publish ]
  before_action :authorize_post!, only: %i[ edit update destroy publish ]

  def index
    @posts = Post.visible_to(current_user).published.includes(:user).with_attached_cover_image
    @query = params[:q].to_s.strip
    @posts = @posts.search_by_content(@query) if @query.present?
  end

  def show
    authorize_view!
    @comment = @post.comments.build
    @root_comments = @post.root_comments.includes(:user, replies: { replies: { replies: :user } })
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other
  end

  def publish
    @post.publish!
    redirect_to @post, notice: "Post published."
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :status, :cover_image)
    end

    def authorize_post!
      return if current_user&.admin? || @post.user == current_user

      redirect_to @post, alert: "You are not authorized to modify this post."
    end

    def authorize_view!
      return if @post.published? || current_user&.admin? || @post.user == current_user

      redirect_to posts_path, alert: "This post is not available."
    end
end
