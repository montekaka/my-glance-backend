class Profile < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, :use => :slugged
  validates :slug, uniqueness: true
  validates :slug, presence: true
  validate :slug_validates

  belongs_to :user

  def slug_candidates
    slug = SecureRandom.uuid[0..4]
    reserved = ['edit','new','session']
    while (Profile.where(slug: slug).exists? || reserved.include?(slug))
      slug = SecureRandom.uuid[0..4]
    end

    return slug
  end
  
  private
  def slug_validates
    # do not allow
    reserved = ['edit','new','session']
    if slug.match /\/|\\|\,|\.|\@|\?|\#|\&|\%|\*|\!|\`/
      errors.add(:slug, "cannot use special characters")
    elsif reserved.include?(slug)
      errors.add(:slug, "cannot use following words: edit, new, session")
    elsif slug.length < 4
      errors.add(:slug, "cannot be less than 5 characters")
    end
  end
end