class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search_params
  before_action :set_host

  def after_sign_in_path_for(resource)
    posts_path
  end

  # ログインパスワードを忘れた時のリセットメール送信のため
  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_name, :phone_number])
  end

  # ヘッダーでransackを用いた検索窓を表示のため
  def set_search_params
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page]).reverse_order.per(12)
  end
end
