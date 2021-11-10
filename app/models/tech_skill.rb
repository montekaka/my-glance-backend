class TechSkill < ApplicationRecord
  belongs_to :profile

  validates :name, presence: true
  validates :icon_name, presence: true  
end
