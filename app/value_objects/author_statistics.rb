class AuthorStatistics
  def initialize(user)
    @user = user
  end

  def avg_impact_factor
    Journal.where(id: journal_ids.uniq).average(:impact_factor)
  end

  def journals
    @journals ||= Journal.find journal_ids.uniq
  end

  def publication_total
    @count ||= @user.publications.count
  end

  def publication_total_this_year
    @user.publications.where('year >= ?', DateTime.current.year).count
  end

  def publication_per_journal
    Journal.joins(:publications).where('publications.id' => publication_ids).group(:name).count
  end

  def publication_per_year
    publication_group_by(:year).sort
  end

  def avg_publication_per_year
    counts = publication_per_year.map(&:last)
    counts.inject{ |sum, el| sum + el }.to_f / counts.size
  end

  private
    def journal_ids
      @journal_ids ||= @user.publications.pluck(:journal_id)
    end

    def publication_group_by(*args)
      @user.publications.group(args).count
    end

    def publication_ids
      @publication_ids ||= @user.publications.pluck(:id)
    end
end