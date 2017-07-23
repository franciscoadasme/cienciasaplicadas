module SiteHelper
  def minimal_layout?
    params.key? :from_ext
  end
end
