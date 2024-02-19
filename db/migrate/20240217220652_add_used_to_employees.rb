class AddUsedToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :used, :boolean
  end
end
