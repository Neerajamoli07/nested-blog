class LikesController < ApplicationController
  before_action :set_likeable

  def create
    @like = @likeable.likes.find_or_create_by!(user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  rescue ActiveRecord::RecordNotUnique
    head :ok
  end

  def destroy
    @likeable.likes.find_by(user: current_user)&.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

    def set_likeable
      klass = params[:likeable_type].classify.constantize
      @likeable = klass.find(params[:likeable_id])
    end
end
