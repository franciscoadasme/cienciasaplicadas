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

  def merge
    journal_ids = params[:journal_ids]
    if journal_ids.present? && journal_ids.many?
      journals = Journal.find journal_ids

      leftover = journals.shift
      journal_ids.shift

      journals.each do |journal|
        journal.publications.find_each { |pub| pub.update! journal_id: leftover.id }
      end
      Journal.destroy journal_ids
    end
    redirect_to admin_journals_path, success: 'Journals successfully merged.'
  end

  private
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
