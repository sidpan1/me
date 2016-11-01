class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :summary
  validates_presence_of :slug
  validates_uniqueness_of :slug

  scope :published, -> {
    where published: true
  }

  def should_generate_new_friendly_id?
    true
  end

end
