class PostsController < ApplicationController
  def index
    @posts = Post.all.order(id: "DESC")
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.order(id: "DESC")
    @post_comment = PostComment.new
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:product_name, :image, :genre, :price, :reason_for_selection, :good_point, :bad_point, :free_text)
  end
end
