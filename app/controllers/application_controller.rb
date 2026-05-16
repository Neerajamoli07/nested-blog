class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  private

    def redirect_if_logged_in
      redirect_to root_path, notice: "You are already signed in." if logged_in?
    end
end
