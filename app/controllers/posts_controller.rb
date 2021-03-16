class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page]).reverse_order.per(12)
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
      redirect_to posts_path, alert: '不正なアクセスです'
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if@post.save
      redirect_to post_path(@post), notice: '投稿が完了しました'
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path, notice: '投稿内容の編集が完了しました'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: '投稿内容を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:product_name, :image, :genre, :price, :reason_for_selection, :good_point, :bad_point, :free_text)
  end
end
