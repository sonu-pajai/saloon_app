class AppointmentsController < ApplicationController
  before_action :set_company

  def create
    appointment = @company.appointments.build(appointment_params)
    if appointment.save
      render json: {data: "Appointed with 00#{appointment.id} ID created successfully"}
    else
      render json: {error: appointment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def appointment_params
    params.require(:appointment).permit(:service_id, :user_id, :start_time_id, :date)
  end

  private

  def set_company
    @company = Company.find_by(id: params[:id])
    render json: {errors: "Company not found"},status: 422 and return if @company.blank?
  end

end
