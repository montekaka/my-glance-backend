class Widget < ApplicationRecord
  belongs_to :profile

  validates :title, presence: true
  validates :icon_name, presence: true
end
