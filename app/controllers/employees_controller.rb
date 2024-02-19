class EmployeesController < ApplicationController
    before_action :authenticate_user!

    # for create employee_id ( NEED ADMIN ROLE ) 
    # employee_id = SecureRandom.random_number(10_000..99_999)


    def new
        @employee = Employee.new
    end

    def create
        @employee = Employee.new(employee_params)
        @employee.used = false

        if @employee.save
            flash[:notice] = 'Employee created success'
            redirect_to root_path
        else
            flash.now[:error] = 'Error with create'
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
        params.require(:employee).permit(:employee_id, :cpf, :phone_number, :user_id)
    end
end