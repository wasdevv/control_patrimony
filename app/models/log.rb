class Log < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  enum action: { employee_created: 0, employee_updated: 1, employee_deleted: 2, employee_edited: 3 }
end
