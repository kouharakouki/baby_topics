class UsersController < ApplicationController

  def index
    @users = User.all.order(id: "DESC")
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(id: "DESC")
  end

  def followings
    @user = User.find(params[:user_id])
    @followings = @user.following_users
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.follower_users
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to users_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(current_user.id)
  end

  def unsubscribe
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user.id)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :phone_number, :email, :introduction, :profile_image)
  end

end
