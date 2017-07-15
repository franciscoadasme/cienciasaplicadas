class PublicationsController < SiteController
  decorates_assigned :publications

  def index
    @publications = Publication.preload({ authors: :user }, :journal)
                               .sorted
  end
end
