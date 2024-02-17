class AddEmployeeIdToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :employee_id, :integer
  end
end
