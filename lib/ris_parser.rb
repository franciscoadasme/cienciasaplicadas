require 'json'

class RisParser

  END_OF_REFERENCE_TAG = 'ER'
  SEPARATOR = '  - '
  KEYWORDS_FIELDS = {
    'ID' => 'identifier',
    'TY' => 'type',
    'T1' => 'title',
    'TI' => 'title',
    'T2' => 'journal',
    'JO' => 'journal',
    'JF' => 'journal',
    'VL' => 'volume',
    'IS' => 'issue',
    'SP' => 'start_page',
    'EP' => 'end_page',
    'PY' => 'year',
    'AU' => 'authors[]',
    'SN' => 'isbn',
    'DO' => 'doi',
    'UR' => 'url',
    'KW' => 'keywords[]',
    'CY' => 'affiliation',
    'PB' => 'publisher',
    'N2' => 'abstract',
    'AB' => 'abstract'
  }

  attr_reader :string, :records

  def initialize()
    @records = []
    @data = {}
  end

  def parse(string, only=KEYWORDS_FIELDS.values)
    return if string.nil?
    @string = string

    @string.split(%r{\n}).each do |line|
      if line.start_with?(END_OF_REFERENCE_TAG)
        consume
      else
        consume_line line, only unless line.strip().empty?
      end
    end

    @records
  end

  private

  def consume_line(line, only)
    keyword, value = line.split SEPARATOR
    fieldname = KEYWORDS_FIELDS[keyword]
    return unless only.include?(fieldname)

    value = value.strip

    unless fieldname.nil?
      case
      when fieldname.end_with?("[]")
        fieldname = fieldname.slice %r{[a-z]+}
        if not @data.has_key? fieldname
          @data[fieldname] = []
        end
        @data[fieldname] << value
      when fieldname == 'year'
        @data[fieldname] = value.slice %r{[0-9]+}
        @data['month'] = value.slice %r{(?<=\d{4}\/)\d{1,2}(?=\/\d?)}
      when fieldname == 'doi'
        @data[fieldname] = value.gsub 'http://dx.doi.org/', ''
      else
        @data[fieldname] = value unless value.empty?
      end
    end
  end

  def consume()
    @records << @data
    unless @data.include? 'identifier'
      @data['identifier'] = @data['authors'].first.split(/[,-]/).first.downcase \
                            + @data['year'].to_s \
                            + @data['title'].split.first.downcase \
                            + @data['title'].split.last.downcase
    end
    @data = {}
  end

end

if __FILE__ == $0
  parser = RisParser.new
  puts JSON.pretty_generate parser.parse(IO.read(ARGV[0]))
end