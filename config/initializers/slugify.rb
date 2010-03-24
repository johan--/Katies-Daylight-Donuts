class String
  def slugify
    self.gsub(/[^A-Za-z0-9\-]/, '')
  end
end