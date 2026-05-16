class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy publish ]

  def index
    @posts = Post.recent
  end

  def show
    @comment = @post.comments.build
    @root_comments = @post.root_comments.includes(replies: { replies: :replies })
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

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
      params.require(:post).permit(:title, :body, :status)
    end
end
