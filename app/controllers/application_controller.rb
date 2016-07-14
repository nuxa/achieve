class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_actionでdeviseのストロングパラメーターにnameカラムを追加するメソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # deviseで使用するストロングパラメーターに項目を追加するメソッドです。
  def configure_permitted_parameters
    # サインアップ時にnameカラムを許容するようにします。
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント更新時にnameカラムを許容するようにします。
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end
end
