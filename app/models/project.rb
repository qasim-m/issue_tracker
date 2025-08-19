class Project < ApplicationRecord
  belongs_to :user
  has_many :issues, dependent: :destroy

  validates :title,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 50 },
    format: { with: /\A[a-zA-Z0-9\s-]+\z/, message: "only allows letters, numbers, dash and spaces" }
  validates :user_id, presence: true
end