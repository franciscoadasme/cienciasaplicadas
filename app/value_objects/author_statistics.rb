class AuthorStatistics
  def initialize(user)
    @user = user
  end

  def impact_factor
    Journal.where(id: journal_ids.uniq).average(:impact_factor) || 0
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

  def publication_per_year
    publication_group_by(:year).sort
  end

  def avg_publication_per_year
    counts = publication_per_year.map(&:last)
    counts.inject{ |sum, el| sum + el }.to_f / counts.size
  end

  def publication_per_journal
    publication_group_by(:journal).sort_by(&:last).reverse
  end

  private
    def journal_ids
      @journal_ids ||= @user.publications.pluck(:journal_id)
    end

    def publication_group_by(*args)
      @user.publications.group(args).count
    end
end