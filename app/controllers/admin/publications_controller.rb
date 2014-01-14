class Admin::PublicationsController < AdminController
  before_action :authorize_user!, only: [ :edit, :update ]
  before_action :set_publication, only: [ :edit, :update, :link, :unlink ]

  def index
    @publications = current_user.publications
    @publication_others = Publication.where('id NOT IN (?)', @publications.map(&:id))
  end

  def edit
  end

  def update
    if @publication.update(publication_params)
      redirect_to admin_publications_path, success: tf('.success')
    else
      render action: :edit
    end
  end

  def import
    # needed to auto-matching existing users to new authors
    @users = User.invitation_accepted
    @result = {
      existing_no_linked: [],
      existing_linked: [],
      new_linked: [],
      ignored: [],
      invalid: []
    }
    @publications = parse_ris_content.map { |pubdata|create_or_update_publication pubdata }
    @import_total = @result.map { |k, v| v.count }.reduce &:+

    flash.now[:success] = tf '.success', count: @import_total
  end

  def link
    author = Author.find(params[:author_id])
    author.user = current_user
    author.save!
    redirect_to admin_publications_path, success: tf('.success', author: author.name)
  end

  def unlink
    author = Author.where(publication: @publication, user: current_user).first
    author.user = nil
    author.save!
    redirect_to admin_publications_path, success: tf('.success')
  end

  private
    def authorize_user!
      redirect_to admin_publications_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def create_or_update_publication pubdata
      journal = pubdata.delete(:journal)
      pub = Publication.where('title = ? OR (doi = ? AND doi IS NOT NULL) OR (url = ? AND url IS NOT NULL) OR identifier = ?', pubdata[:title], pubdata[:doi], pubdata[:url], pubdata[:identifier])
              .first_or_initialize pubdata.select { |k, v| Publication::ALLOWED_FIELDS.include? k }

      if pub.invalid?
        @result[:invalid] << pub
      elsif pub.new_record?
        pub.authors = pubdata[:authors].map do |name|
          existing_author = Author.includes(:user).where(name: name).first
          Author.new(name: name).tap do |a|
            if existing_author.nil?
              @users.each do |user|
                a.user ||= user if (user.settings.autolink_on_import || user == current_user) && user.alias?(a.name)
              end
            elsif !existing_author.user.nil? && (existing_author.user.settings.autolink_on_import || existing_author.user == current_user)
              a.user = existing_author.user
            end
          end
        end

        if pub.has_users?
          pub.journal = Journal.where.any_of(name: journal, abbr: journal).first_or_create! name: journal
          pub.save!
          @result[:new_linked] << [ pub, pub.authors.linked ]
        else
          @result[:ignored] << pub
        end
      else
        linked_authors = []
        pub.authors.each do |author|
          if author.user.nil? && current_user.alias?(author.name)
            author.user = current_user
            linked_authors << author
            author.save!
          end
        end
        pub.save!

        if linked_authors.any?
          @result[:existing_linked] << [ pub, linked_authors ]
        else
          @result[:existing_no_linked] << pub
        end
      end
      pub
    end

    def parse_ris_content
      parser = RisParser.new
      parser.parse(params[:ris_content]).map { |e| HashWithIndifferentAccess.new(e).symbolize_keys }
    end

    def publication_params
      params.require(:publication).permit(
        :doi,
        :url,
        :journal,
        :volume,
        :issue,
        :start_page,
        :end_page,
        :month,
        :year,
        :title
      )
    end

    def set_publication
      @publication = Publication.find params[:id]
    end
end
