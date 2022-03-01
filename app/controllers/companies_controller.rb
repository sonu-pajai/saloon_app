class CompaniesController < ApplicationController

  def index
    companies = Company.select("id, name, address").where('name LIKE ?', "%#{params[:query]}%").paginate(page: params[:page] || 1, per_page: 30)
    render json: {data: companies}
  end

  # def create
  #   company = Company.new(company_params)
  #   if company.save
  #     render json: {data: company}
  #   else
  #     render json: {errors: company.errors.full_messages}, status: :unprocessable_entity
  #   end
  # end

  # def company_params
  #   params.require(:company).permit(:gstin, :pan, :name, :address, :start_time_id, :end_time_id)
  # end

end
