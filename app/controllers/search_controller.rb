class SearchController < ApplicationController
  allow_unauthenticated_access only: :index
  def index
    @query = params[:q].to_s.strip
    @posts = if @query.present?
      Post.published.search_by_content(@query).includes(:user).with_attached_cover_image
    else
      Post.none
    end
  end
end
