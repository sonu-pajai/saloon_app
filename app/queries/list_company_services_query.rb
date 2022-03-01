class ListCompanyServicesQuery

  def initialize(company, params)
    @company = company
    @params = params
  end

  def services
    @company.services.select(:id, :name, :price, :time, :company_id).
      where('name LIKE ?', "%#{@params[:query]}%").
      order((@params[:sort_by] || "price").to_sym => @params[:sort_order] || "asc").
      paginate(page: @params[:page] || 1, per_page: 30)
  end

  def all_slots
    TimeSlot.select("id, from_time as slot_time").where(id: @company.start_time_id..@company.end_time_id)
  end

  def booked_slots
    statuses = [Appointment.statuses[:confirm], Appointment.statuses[:completed]]
    Appointment.filter_appointments(company: @company, statuses: statuses)
  end
end