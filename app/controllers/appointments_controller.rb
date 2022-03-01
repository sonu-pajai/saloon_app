class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, :set_service

  def index 
    appointment = current_user.appointments.paginate(page: params[:page] || 1, per_page: 30)
    render json: {data: appointment}
  end

  def create
    appointment = current_user.appointments.build(appointment_params)
    if appointment.save
      render json: {data: "Appointed with 00#{appointment.id} ID created successfully"}
    else
      render json: {error: appointment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update_status
    appointment.update_status(status: params[:status])
  end

  def appointment_params
    params.require(:appointment).permit(:company_id, :service_id, :start_time_id, :date)
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: {errors: "Company not found"},status: 422 and return if @company.blank?
  end


  def set_service
    service = Service.find_by(id: params[:service_id])
    render json: {errors: "Service not found"},status: 422 and return if service.blank?
  end


  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])
    render json: {errors: "Appointment not found"},status: 422 and return if @appointment.blank?
  end
end
