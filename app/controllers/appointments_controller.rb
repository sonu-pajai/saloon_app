class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, :set_service, only: :create
  before_action :validate_appointment, only: :cancel_appointment

  def index 
    appointment = current_user.appointments.paginate(page: params[:page] || 1, per_page: 30)
    render json: {data: appointment}
  end

  def create
    appointment = current_user.appointments.build(appointment_params)
    if appointment.save
      render json: {message: "Appointment with 00#{appointment.id} ID created successfully"}
    else
      render json: {errors: appointment.errors.full_messages.join(",")}, status: :unprocessable_entity
    end
  end

  def cancel_appointment
    if @appointment.update(status: Appointment.statuses[:cancelled])
        render json: {message: "Appointment #{@appointment.status} successfully"}
      else
        render json: {errors: @appointment.errors.full_messages.join(",")}, status: :unprocessable_entity
      end
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:company_id, :service_id, :start_time_id, :date)
  end

  def set_company
    @company = Company.find_by(id: appointment_params[:company_id])
    render json: {errors: "Company not found"}, status: 422 and return if @company.blank?
  end

  def set_service
    service = @company.services.find_by(id: appointment_params[:service_id])
    render json: {errors: "Service not found"}, status: 422 and return if service.blank?
  end

  def validate_appointment
    @appointment = User.first.appointments.find_by(id: params[:id])
    if @appointment.blank?
      render json: {errors: "Appointment not found"}, status: 422 and return
    elsif @appointment.cancelled?
      render json: {errors: "Appointment already cancelled"}, status: 422 and return
    elsif @appointment.completed?
      render json: {errors: "Appointment can not be cancelled"}, status: 422 and return
    else
  end

end
