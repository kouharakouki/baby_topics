class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new_guest]
  before_action :check_guest, only: %i(edit update destroy)

  # ゲストログイン機能に使用
  def new_guest
    user = User.guest
    sign_in user
    redirect_to posts_path, notice: 'ゲストユーザーとしてログインしました'
  end

  # マイページからブックマーした記事一覧へ
  # ログインユーザーが登録した記事のみ閲覧可能
  def bookmark
    bookmarks = Bookmark.where(user_id: current_user.id).order(created_at: "DESC").pluck(:post_id)
    @posts = Kaminari.paginate_array(Post.find(bookmarks)).page(params[:page]).per(10)
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to users_path(current_user.id), alert: '不正なアクセスです'
    end
  end

  # ransackを使用。ユーザー名で検索可能
  def index
    @qu = User.ransack(params[:q])
    @users = @qu.result.page(params[:page]).reverse_order.per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).reverse_order.per(10)
  end

  # フォローしている人の一覧画面を表示
  def followings
    @user = User.find(params[:user_id])
    @followings = @user.following_users
  end

  # フォローされている人の一覧画面を表示
  def followers
    @user = User.find(params[:user_id])
    @followers = @user.follower_users
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to users_path(current_user.id), alert: '不正なアクセスです'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user.id), notice: 'アカウント情報の編集が完了しました'
    else
      render :edit
    end
  end

  # 退会の確認画面を表示
  def unsubscribe
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user.id), alert: '不正なアクセスです'
    end
  end

  # 退会確認画面で退会するボタンを押されて物理的処理
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: '退会処理が完了しました またのご利用をお待ちしております'
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :phone_number,
                                 :email, :introduction, :profile_image)
  end

  # ゲストログインのユーザーがアカウントの編集ができないように
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの編集・削除できません'
    end
  end
end
