module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_login
    helper_method :current_user, :logged_in?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_login, **options
    end
  end

  private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
      current_user.present?
    end

    def require_login
      return if logged_in?

      session[:return_to] = request.fullpath
      redirect_to login_path, alert: "Please sign in to continue."
    end

    def require_admin
      redirect_to root_path, alert: "Not authorized." unless current_user&.admin?
    end
end
