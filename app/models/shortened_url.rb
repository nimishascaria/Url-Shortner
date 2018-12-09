class ShortenedUrl < ApplicationRecord

  UNIQUE_ID_LENGTH = 6
  validates :original_url, presence: true, on: :create
  # validates_format_of :original_url, with
  before_create :generate_short_url
  before_create :sanitize

  def generate_short_url
    url = ([*('a'..'z'),*('0'..'9')]).sample(6).join
    existing_url = ShortenedUrl.where(:short_url => url).last
    if existing_url.present?
      self.generate_short_url
    else
      self.short_url = url
    end
  end

  def sanitize
    self.original_url.strip!
    self.sanitize_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/,"")
    self.sanitize_url = "http://#{self.sanitize_url}"
  end

  def new_url?
    ShortenedUrl.find_by_sanitize_url(self.sanitize_url)
  end

  def find_duplicate
    ShortenedUrl.find_by_sanitize_url(self.sanitize_url)
  end

end
