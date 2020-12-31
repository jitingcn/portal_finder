# frozen_string_literal: true

class ApplicationController < ActionController::Base
  if @stimulus_reflex
    render layout: false
  end

  include Pagy::Backend

  check_authorization unless: :devise_controller?

  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    fname = %w[404 403 422 500].include?(status) ? status : "unknown"

    respond_to do |format|
      format.html { render template: "/errors/#{fname}", handler: [:erb], status: status, layout: "application" }
      format.all { render body: nil, status: status }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  protected

    def configure_permitted_parameters
      added_attrs = %i[login]
      devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
      devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
      # devise_parameter_sanitizer.permit(:account_update) do |u|
      #   if current_user.email_locked?
      #     u.permit(*User::ACCESSABLE_ATTRS)
      #   else
      #     u.permit(:email, *User::ACCESSABLE_ATTRS)
      #   end
      # end
    end
end
