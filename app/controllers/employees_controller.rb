class EmployeesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin, only: [:create_employee_id]

    # for create employee_id ( NEED ADMIN ROLE ) 
    # employee_id = SecureRandom.random_number(10_000..99_999)


    def new
        @employee = Employee.new
    end

    def create
        @employee = current_user.employees.build(employees_params)
        
        if @employee.save
            create_log(:employee_created, @product, details: { message: 'New employee on system!' })
        else
            render :new
        end

    end

    def show
        @employee = Employee.find(params[:id])
    end

    def edit
        @employee = Employee.find(params[:id])
    end

    def update
    end

    def create_employee_id
        @employee = Employee.new
        if @employee.save
            flash[:notice] = "ID Generated"
        else
            flash[:alert] = "Error with generate this Employee ID"
        end
        redirect_to root_path
    end
    
    private

    def authorize_admin
        unless current_user.role == 1
            flash[:error] = "You dont have permission!"
            redirect_to root_path
        end
    end
    
    def create_log(action, trackable, details: {} )
        Log.create!(user: current_user, action: action, trackable: trackable, details: details )
    end

    def employee_params
        params.require(:employee).permit(:employee_id, :user_id, :cpf, :phone_number)
    end
end