class ReportsQuery

  def initialize(company, params)
    @company = company
    @params = params
    @data = {}
  end

  def report
    @data[:completed_appointments] = completed_appointments
    @data[:cancelled_appointments] = cancelled_appointments
    @data[:total_revenue_earned] = total_revenue_earned
    @data[:total_revenue_lost] = total_revenue_lost
    @data
  end

  private

  def completed_appointments
    Appointment.status_wise_appointments(company: @company, start_date: @params["start_date"], end_date: @params["end_date"], statuses: [Appointment.statuses[:completed]]).as_json
  end

  def cancelled_appointments
    cancelled = Appointment.status_wise_appointments(company: @company, start_date: @params["start_date"], end_date: @params["end_date"], statuses: [Appointment.statuses[:confirmed], Appointment.statuses[:cancelled]]).as_json
    cancelled.reject! { |app|
      @data[:completed_appointments].find{ |a|
        range = (a["start_time_id"]..a["end_time_id"])
        a["date"] == app["date"] && (range.include?(app["start_time_id"]) || range.include?(app["start_time_id"]))
      }
    } if @data[:completed_appointments]
    cancelled
  end

  def total_revenue_earned
    @data[:completed_appointments]&.inject(0) {|sum, hash| sum + hash["price"].to_f}
  end

  def total_revenue_lost
    @data[:cancelled_appointments]&.inject(0) {|sum, hash| sum + hash["price"].to_f}
  end
end