# frozen_string_literal: true

class HomeController < ApplicationController
  skip_authorization_check
  def index
    # redirect_to new_user_session_path unless user_signed_in?

    if user_signed_in?
      @user_name = current_user.login
    end
  end
end
