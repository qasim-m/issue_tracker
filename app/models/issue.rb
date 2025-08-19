class Issue < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  # Associations for creator and assignee (both are users)
  belongs_to :creator, class_name: "User", foreign_key: "created_by", optional: true
  belongs_to :assignee, class_name: "User", foreign_key: "assigned_to", optional: true

  # Enum for status (customize as needed)
  enum status: { open: 0, in_progress: 1, on_hold: 2, closed: 3 }

  validates :issue_number, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 1000 }
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :project_id, presence: true
end
