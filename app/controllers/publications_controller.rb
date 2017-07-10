class PublicationsController < SiteController
  decorates_assigned :publications

  def index
    @publications = Publication.includes({ authors: :user }, :journal)
                               .sorted
  end
end
