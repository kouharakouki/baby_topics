class RelationshipsController < ApplicationController

  # followはuser.rbに定義　newとsaveを合わせた挙動
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    redirect_back(fallback_location: users_path)
  end

  # unfollowはuser.rbに定義　１レコードを特定しdestroyメソッドで削除
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
    redirect_back(fallback_location: users_path)
  end
end
