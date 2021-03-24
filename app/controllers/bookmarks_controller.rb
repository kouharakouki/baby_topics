class BookmarksController < ApplicationController
  before_action :authenticate_user!

  # 投稿に対するコメントを保存
  # 非同期通信でビューを表示
  def create
    @post = Post.find(params[:post_id])
    bookmark = @post.bookmarks.new(user_id: current_user.id)
    bookmark.save
  end

  # コメントの削除機能
  # 非同期通信でビューを表示
  def destroy
    @post = Post.find(params[:post_id])
    bookmark = @post.bookmarks.find_by(user_id: current_user.id)
    bookmark.destroy
  end
end
