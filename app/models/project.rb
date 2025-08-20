class Project < ApplicationRecord
  belongs_to :user
  has_many :issues, dependent: :destroy

  validates :title,
    presence: true,
    uniqueness: { scope: :user_id, case_sensitive: false },
    length: { in: 3..50 },
    format: { with: /\A[\w\s'-]+\z/, message: "only allows letters, numbers, underscores, dashes, apostrophes and spaces" }

end