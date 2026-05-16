module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc)
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User role updated."
      else
        redirect_to admin_users_path, alert: "Could not update user."
      end
    end

    def user_params
      params.require(:user).permit(:role)
    end

    def destroy
      user = User.find(params[:id])
      if user == current_user
        redirect_to admin_users_path, alert: "You cannot delete yourself."
      else
        user.destroy!
        redirect_to admin_users_path, notice: "User deleted."
      end
    end
  end
end
