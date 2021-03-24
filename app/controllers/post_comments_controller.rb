class PostCommentsController < ApplicationController
  # 投稿に対するコメントを保存
  # 保存後に非同期通信でビュー画面表示
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.save
  end

  # コメントの削除機能
  # 削除後、非同期通信でビュー画面表示
  def destroy
    @post = Post.find(params[:post_id])
    post_comment = @post.post_comments.find(params[:id])
    post_comment.destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
