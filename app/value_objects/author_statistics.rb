class AuthorStatistics
  def initialize(user)
    @user = user
  end

  def avg_impact_factor
    Journal.where(id: journal_ids.uniq).average(:impact_factor)
  end

  def journal_total
    journal_ids.uniq.count
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
    @pubs_per_journal ||= Journal.joins(:publications)
                                 .where('publications.id' => publication_ids)
                                 .group(:name).count.to_a
                                 .sort_by { |a| [-a[1], a[0]] }
  end

  def publication_per_year(include_empty_years: false)
    @publications_per_year ||= publication_group_by(:year).sort
    if include_empty_years
      pubs_per_year = Array.new(@publications_per_year)
      years = pubs_per_year.map { |year, _| year }
      years[0].upto(Date.today.year) do |year|
        pubs_per_year << [year, 0] unless years.include?(year)
      end
      return pubs_per_year.sort
    end
    @publications_per_year
  end

  def avg_publication_per_year
    publication_per_year.map(&:last).mean
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
