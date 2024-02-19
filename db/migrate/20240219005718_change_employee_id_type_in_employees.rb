class ChangeEmployeeIdTypeInEmployees < ActiveRecord::Migration[7.1]
  def up
    add_column :employees, :employee_uuid, :uuid
    
    Employee.all.each do |employee|
      employee.update(employee_uuid: SecureRandom.uuid)
    end

    remove_column :employees, :employee_id

    rename_column :employees, :employee_uuid, :employee_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
