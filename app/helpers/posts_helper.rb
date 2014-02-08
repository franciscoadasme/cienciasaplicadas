module PostsHelper
  def post_permalink(post)
    return post if post.blank?
    date = post.created_at
    post_path id: post.slug, year: date.year, month: date.month, day: date.day
  end

  def posts_this_month_path
    today = DateTime.current
    posts_path year: today.year, month: today.month
  end

  def nav_header_data_for_post(post)
    {
      prev: {
        href: post_permalink(@post.previous),
        title: 'Ir a la noticia anterior'
      },
      next: {
        href: post_permalink(@post.next),
        title: 'Ir a la noticia siguiente'
      }
    }
  end
end
