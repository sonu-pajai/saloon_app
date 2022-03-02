class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, :set_service, only: :create
  before_action :find_appointment, only: :cancel_appointment

  def index 
    appointment = current_user.appointments.paginate(page: params[:page] || 1, per_page: 30)
    render json: {data: appointment}
  end

  def create
    appointment = current_user.appointments.build(appointment_params)
    if appointment.save
      render json: {data: "Appointment with 00#{appointment.id} ID created successfully"}
    else
      render json: {error: appointment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def cancel_appointment
    if @appointment.update(status:  Appointment.statuses[:cancelled])
      render json: {data: "Appointment #{@appointment.status} successfully"}
    else
      render json: {error: @appointment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:company_id, :service_id, :start_time_id, :date)
  end

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: {errors: "Company not found"}, status: 422 and return if @company.blank?
  end

  def set_service
    service = @company.services.find_by(id: params[:service_id])
    render json: {errors: "Service not found"}, status: 422 and return if service.blank?
  end

  def find_appointment
    @appointment = User.first.appointments.find_by(id: params[:id])
    render json: {errors: "Appointment not found"}, status: 422 and return if @appointment.blank?
  end

end
