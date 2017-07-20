# Methods to deal with user-created content (e.g., posts, pages)
module ContentHelper
  def excerpt(content, truncate_at: 140, separator: /(?<=[a-z])\s+/, omission: '...')
    strip_tags(content)
      .gsub(/([\.,])([a-z])/i, '\1 \2')
      .truncate truncate_at, separator: separator, omission: omission
  end
end
