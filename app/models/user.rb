class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         belongs_to :employee, optional: true # Optimal because necessary IF are Employee.

         enum role: { user: 0, admin: 1}

         has_many :logs, as: :trackable, class_name: 'Log'
         has_one :employee
         
         def admin?
          role == 'admin'
         end

         def associate_employee_id(employee_id)
          employee = Employee.find_by(employee_id: employee_id, used: false )
          if employee.present? && self.employee.blank?
            employee.update(used: true) # if 
            self.update(employee: employee)
            return true
          else
            return false
          end
        end
end
