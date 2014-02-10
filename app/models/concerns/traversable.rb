module Traversable
  def previous
    self.class.limit(1).order(id: :desc).find_by('id < ?', id)
  end

  def next
    self.class.limit(1).order(id: :asc).find_by('id > ?', id)
  end
end