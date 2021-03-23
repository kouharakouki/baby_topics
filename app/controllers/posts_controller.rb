class PostsController < ApplicationController
  before_action :authenticate_user!

  # ransackを用いた検索機能で投稿一覧を商品検索、ジャンル検索できる
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page]).reverse_order.per(10)
  end

  # 投稿詳細画面にコメント投稿機能、コメント一覧表示がある
  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.order(id: "DESC")
    @post_comment = PostComment.new
  end

  # 空のインスタンス変数を渡して情報を新しく入力
  def new
    @post = Post.new
  end

  # 投稿編集画面。ログインユーザーでなければ、投稿一覧に戻す
  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path, alert: '不正なアクセスです'
    end
  end

  # 投稿内容を保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: '投稿が完了しました'
    else
      render :new
    end
  end

  # 投稿内容の編集情報をアップデートする
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path, notice: '投稿内容の編集が完了しました'
    else
      render :edit
    end
  end

  # 投稿した内容を削除する
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: '投稿内容を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:product_name, :image, :genre, :price,
                                 :reason_for_selection,
                                 :good_point, :bad_point, :free_text)
  end
end
