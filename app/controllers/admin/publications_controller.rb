class Admin::PublicationsController < AdminController
  before_action :authorize_user!, only: [ :edit, :update ]
  before_action :set_publication, only: [ :edit, :update, :link, :unlink,
    :toggle_flag, :author_list ]

  def index
    @publications = current_user.publications.sorted
    @publication_others = Publication.where('id NOT IN (?)', @publications.map(&:id))
  end

  def edit
  end

  def update
    if @publication.update(publication_params)
      redirect_to_index success: true
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
    @created_journals = []
    @publications = parse_ris_content.map { |pubdata|create_or_update_publication pubdata }
    @import_total = @result.map { |k, v| v.count }.reduce &:+

    current_user.update! last_import_at: DateTime.current
    DefaultMailer.send_journal_notification(@created_journals).deliver

    flash.now[:success] = I18n.t 'controllers.admin.publications.import.success', count: @import_total
  end

  def link
    author = Author.find(params[:author_id])
    author.user = current_user
    author.save!
    redirect_to_index success: { author: author.name }
  end

  def unlink
    author = Author.find_by publication: @publication, user: current_user
    author.user = nil
    author.save!
    redirect_to_index success: true
  end

  def toggle_flag
    author = Author.find_by publication: @publication, user: current_user
    author.toggle_flag!
    redirect_to_index success: (author.flagged? ? :flagged : :unflagged)
  end

  def author_list
    @authors = @publication.authors.sorted
    respond_to do |format|
      format.html { redirect_to_index }
      format.js
    end
  end

  private
    def authorize_user!
      redirect_to_index alert: t('devise.failure.unauthorized') unless current_user.super_user?
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
          pub.journal = Journal.where.any_of(name: journal, abbr: journal).first

          unless pub.journal.present?
            pub.journal = Journal.create! name: journal
            @created_journals << pub.journal
          end

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
