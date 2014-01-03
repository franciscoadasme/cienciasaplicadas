class Admin::JournalsController < AdminController
  before_action :authorize_user!
  before_action :set_journal, only: [ :edit, :update ]

  def index
    @journals = Journal.sorted
  end

  def edit
  end

  def update
    if @journal.update(journal_params)
      redirect_to admin_journals_path, success: 'Journal was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def set_journal
      @journal = Journal.find(params[:id])
    end

    def journal_params
      params.require(:journal).permit(
        :name,
        :abbr,
        :website_url,
        :impact_factor)
    end
end
