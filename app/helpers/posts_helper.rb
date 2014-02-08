module PostsHelper
  def post_permalink(post)
    return post if post.blank?
    date = post.created_at
    post_path id: post.slug, year: date.year, month: date.month, day: date.day
  end
end
