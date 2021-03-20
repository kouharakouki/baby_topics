class FavoritesController < ApplicationController
  before_action :authenticate_user!

  # いいねボタンが押されたら保存する
  # 非同期通信でビューに返す
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user_id: current_user.id)
    favorite.save
  end

  # いいね解除の時にいいねを削除する
  # 非同期通信でビューに返す
  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.destroy
  end
end
