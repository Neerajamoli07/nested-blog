module CommentsHelper
  MAX_NESTING_DEPTH = 4

  def comment_dom_id(comment)
    dom_id(comment)
  end

  def can_reply?(comment)
    comment.depth < MAX_NESTING_DEPTH
  end
end
