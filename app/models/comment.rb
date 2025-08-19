class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :text,
    presence: true,
    length: { minimum: 2, maximum: 500 }
  validates :issue_id, presence: true
  validates :user_id, presence: true
end
