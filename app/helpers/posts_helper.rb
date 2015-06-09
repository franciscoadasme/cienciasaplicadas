module PostsHelper
  def post_permalink(post, full_path: false)
    return post if post.blank?
    date = post.created_at
    helper = full_path ? method(:post_url) : method(:post_path)
    helper.call(id: post.slug, year: date.year, month: date.month,
                day: date.day)
  end

  def posts_this_month_path
    posts_path date_params_for_this_month
  end

  def nav_header_data_for_post(post)
    data = {}
    data[:prev] = {
      href: post_permalink(@post.previous),
      title: 'Ir a la noticia anterior'
    } if @post.previous.present?
    data[:next]= {
      href: post_permalink(@post.next),
      title: 'Ir a la noticia siguiente'
    } if @post.next.present?
    data
  end
end
