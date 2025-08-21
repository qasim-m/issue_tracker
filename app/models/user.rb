class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy

  
  has_many :created_issues, class_name: "Issue", foreign_key: "created_by", dependent: :destroy
  # dependent: :nullify to remove user_id from issue if the user gets deleted to avoid orphand records
  has_many :assigned_issues, class_name: "Issue", foreign_key: "assigned_to", dependent: :nullify

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 30 },
    format: { with: /\A[a-zA-Z0-9\s-]+\z/, message: "only allows letters, numbers, dash and spaces" }
end