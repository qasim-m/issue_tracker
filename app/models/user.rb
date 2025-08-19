class User < ApplicationRecord
  has_many :projects
  has_many :comments
  has_many :created_issues, class_name: "Issue", foreign_key: "created_by"
  has_many :assigned_issues, class_name: "Issue", foreign_key: "assigned_to"

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 30 },
    format: { with: /\A[a-zA-Z0-9\s-]+\z/, message: "only allows letters, numbers, dash and spaces" }
end