class PublicationsController < SiteController
  decorates_assigned :publications

  def index
    @publications = Publication.preload({ authors: :user }, :journal)
                               .members_only
                               .displayable
                               .sorted
  end
end
