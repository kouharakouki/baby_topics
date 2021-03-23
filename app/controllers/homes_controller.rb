class HomesController < ApplicationController
  def top
    # いいねランキングのトップ５を変数に入れる
    @posts = Post.find(Favorite.group(:post_id).order(Arel.sql('count(post_id) desc')).limit(5).pluck(:post_id))
    # いいねランキングのトップ１を変数に入れる
    @post = Post.find(Favorite.group(:post_id).order(Arel.sql('count(post_id) desc')).limit(1).pluck(:post_id))
  end

  def about
  end
end
