class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :set_company, only: :monthly_reports

  def monthly_reports
    report_query = ReportsQuery.new(@company, report_params)
    render json: {data: report_query.report}
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
    render json: {errors: "Company not found"}, status: 422 and return if @company.blank?
  end


  def report_params
    params.permit(:company_id, :start_date, :end_date)
  end

end
