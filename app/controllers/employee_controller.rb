class EmployeeController < ApplicationController

  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
  end

  def edit
    @employee = Employee.find(params[:id])
  end
  
  def show
    @employee = Employee.find(params[:id])
  end

  private

  def employee_params
  end
end
