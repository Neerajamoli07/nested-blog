class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  before_action :redirect_if_logged_in, only: %i[ new create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.strip&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to after_login_path, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end

  private

    def after_login_path
      session.delete(:return_to) || root_path
    end
end
