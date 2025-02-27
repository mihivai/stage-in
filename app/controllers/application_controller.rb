class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?


  def set_locale
    I18n.locale = :fr
  end

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
        :sign_up,
        keys: [
          :role,
          :first_name,
          :last_name,
          :address,
          :level,
          :phone,
          :company,
          :email,
          :password,
          :college_id,
          :birthday,
          :city,
          :zipcode,
          :num,
          :college_acceptation,
          :college_name,
          :visible,
          :description,
          :skill_id
        ]
      )
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(
        :role,
        :first_name,
        :last_name,
        :address,
        :level,
        :password,
        :password_confirmation,
        :current_password,
        :phone,
        :company,
        :email,
        :password,
        :college_id,
        :birthday,
        :city,
        :zipcode,
        :num,
        :college_acceptation,
        :college_name,
        :visible,
        :description,
        :skill_id
      )}
  end

  def after_sign_up_path_for(resource)
    skill_path(Skill.first)
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def student_access
    redirect_to root_path unless current_user.role == "student"
  end

  def company_access
    redirect_to root_path unless current_user.role == "company"
  end
  # def after_sign_in_path_for(resource)
  #   hirings_path
  # end

end
