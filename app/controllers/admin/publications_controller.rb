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
    users = User.invitation_accepted.includes(:aliases)
                .joins(:settings)
                .where('users.id = ? or settings.autolink_on_import = ?',
                       current_user.id, true).to_a
    importer = PublicationImporter.new users
    @entries = importer.import params.delete(:ris_content), format: :ris

    current_user.update! last_import_at: DateTime.current
    DefaultMailer.send_journal_notification(importer.new_journals).deliver

    flash.now[:success] = I18n.t('controllers.admin.publications.import.success',
                                 count: importer.total_entries)
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
