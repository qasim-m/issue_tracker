class Issue < ApplicationRecord
  before_create :set_issue_number

  belongs_to :project
  has_many :comments, dependent: :destroy

  # Associations for creator and assignee (both are users)
  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  # optional: true for assignee because issue can be assigned after creation
  belongs_to :assignee, class_name: "User", foreign_key: "assigned_to", optional: true

  enum :status, { open: 0, in_progress: 1, on_hold: 2, closed: 3 }

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }

  private

  def set_issue_number
    last_number = project.issues.maximum(:issue_number) || 0
    self.issue_number = last_number + 1
  end

end
