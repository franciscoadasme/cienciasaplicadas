class PublicationImporter
  attr_reader :new_journals, :total_entries
  def initialize(users)
    @users = users.to_a
    @result = {
      existing_no_linked: [],
      existing_linked: [],
      new_linked: [],
      ignored: [],
      invalid: []
    }
    @new_journals = []
  end

  def from_ris(content)
    parser = RisParser.new
    entries = parser.parse(content)
    entries.each{ |data| create_or_update_publication_with data }
    @total_entries = entries.count
  end

  def import(data, format: :ris)
    case format
    when :ris then from_ris(data)
    else raise "unknown format: #{format}"
    end
  end

  private
    def create_or_update_publication_with(data)
      pub = fetch_or_setup_publication_with data
      if pub.new_record? && pub.invalid?
        @result[:invalid] << pub
      else
        link_pub_to_existing_users pub
        if pub.has_users?  # save publication only if it is/was linked
          pub.journal.save! validate: false if pub.journal.new_record?
          pub.save! validate: false
        end
      end
    end

    def fetch_or_setup_journal_with(name)
      raise 'journal cannot be blank' if name.blank?
      Journal.where.any_of(name: name, abbr: name)
             .first_or_initialize name: name
    end

    def fetch_or_setup_publication_with(data)
      data = data.symbolize_keys
      permitted_data = data.slice(*Publication::ALLOWED_FIELDS).except(:journal)
      q = Publication.includes(:authors).includes(:journal)
                     .where('title = ? ' +
                            'OR (doi = ? AND doi IS NOT NULL) ' +
                            'OR identifier = ?',
                            *data.values_at(:title, :doi, :identifier))
      q.first_or_initialize(permitted_data) do |pub|
        pub.authors = data[:authors].map{ |n| Author.new name: n.strip }
        pub.journal = fetch_or_setup_journal_with data[:journal]
      end
    end

    def link_pub_to_existing_users(pub)
      pub.authors.select do |author|
        author.user_id ||= @users.detect{ |u| u.alias?(author.name) }.try :id
        author.has_user?
      end
    end
end
