module ApplicationHelper
  def like_path_for(likeable)
    like_path(likeable_type: likeable.model_name.name, likeable_id: likeable.id)
  end

  def unlike_path_for(likeable)
    unlike_path(likeable_type: likeable.model_name.name, likeable_id: likeable.id)
  end

  def user_avatar(user, size: 40)
    if user&.avatar&.attached?
      image_tag user.avatar.variant(resize_to_fill: [ size, size ]),
                class: "avatar",
                alt: user.name
    else
      tag.span(user&.name&.first&.upcase || "?", class: "avatar avatar--placeholder")
    end
  end

  def unread_notifications_count
    return 0 unless current_user

    current_user.notifications.unread.count
  end
end
