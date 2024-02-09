class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cpf
      t.decimal :phone_number

      t.timestamps
    end
  end
end
