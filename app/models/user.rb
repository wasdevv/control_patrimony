class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         belongs_to :employee, optional: true # Optimal because necessary IF are Employee.

         enum role: { user: 0, admin: 1, employee: 2}

         has_many :logs, as: :trackable, class_name: 'Log'
         has_one :employee

         def employee?
          role == 'employee'
         end

         def admin?
          role == 'admin'
         end

         def assign_employee(employee_id)
          begin
            employee = Employee.find_by(employee_id: employee_id, used: false )
            if employee.present?
              employee.update!(used: true )
              self.update!(employee: employee)
              return true
            else
              return false
            end
          rescue => e
            Rails.logger.error("Error employee: #{e.message}" )
            return false
          end
        end
end
