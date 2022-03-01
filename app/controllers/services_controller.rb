class ServicesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_company

  # def create
  #   service = @company.services.build(services_params)
  #   if service.save
  #     render json: {data: service}
  #   else
  #     render json: {errors: service.errors.full_messages}, status: :unprocessable_entity
  #   end

  # end

  def index
    sort_by = (params[:sort_by] || "price").to_sym
    sort_order = params[:sort_order] || "asc"
    services = @company.services.select(:id, :name, :price, :time, :company_id).where('name LIKE ?', "%#{params[:query]}%").order(sort_by => sort_order).paginate(page: params[:page] || 1, per_page: 30)
    time_slots = TimeSlot.select(:id, :from_time).where(id: @company.start_time_id..@company.end_time_id)
    render json: {data: {services: services, slots: time_slots}}
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: {errors: "Company not found"},status: 422 and return if @company.blank?
  end

  # def services_params
  #   params.require(:service).permit(:name, :price, :from_time)
  # end
end
