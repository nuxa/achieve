class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_actionでdeviseのストロングパラメーターにnameカラムを追加するメソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_notifications

  PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache)

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def current_notifications
    @notifications = Notification.where(recipient_id: current_user).order(created_at: :desc).includes({comment: [:blog]})
    @notifications_count = Notification.where(recipient_id: current_user).order(created_at: :desc).unread.count
  end

  private

  # deviseで使用するストロングパラメーターに項目を追加するメソッドです。
  def configure_permitted_parameters
    # サインアップ時にnameカラムを許容するようにします。
    devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
    # アカウント更新時にnameカラムを許容するようにします。
    devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
  end

end
