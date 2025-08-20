class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :text,
    presence: true,
    length: { minimum: 2, maximum: 500 }
end
