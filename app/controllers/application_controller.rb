class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :exclude_guest_user, if: :devise_controller?, only: :edit

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:name, :icon, :remove_icon, :introduction]
    )
  end

  def exclude_guest_user
    if current_user.email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーの情報は変更できません"
    end
  end
end
