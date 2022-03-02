class ServicesController < ApplicationController
  before_action :set_company

  def index
    query = ListCompanyServicesQuery.new(@company, params)
    render json: {data: {services: query.services, all_slots: query.all_slots, booked_slots: query.booked_slots}}
  end

  # def create
  #   service = @company.services.build(services_params)
  #   if service.save
  #     render json: {data: service}
  #   else
  #     render json: {errors: service.errors.full_messages}, status: :unprocessable_entity
  #   end

  # end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: {errors: "Company not found"}, status: 422 and return if @company.blank?
  end

  # def services_params
  #   params.require(:service).permit(:name, :price, :from_time)
  # end
end
