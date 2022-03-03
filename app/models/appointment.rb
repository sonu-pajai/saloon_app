class Appointment < ApplicationRecord
  enum status: [:confirmed, :completed, :cancelled ]

  belongs_to :company
  belongs_to :service
  belongs_to :user
  belongs_to :start_time, class_name: :TimeSlot
  belongs_to :end_time, class_name: :TimeSlot

  validates :date, presence: true

  before_validation :set_end_time
  validate :validate_timeslots, :validate_overlapping


  def set_end_time
    time_in_minutes = service.time #time required for service
    slots = time_in_minutes/15
    slots = time_in_minutes % 15 == 0 ? slots-1 : slots
    self.end_time = TimeSlot.find_by(id: start_time.id+slots)
  end

  def validate_timeslots
    ids = TimeSlot.where(id: company.start_time_id..company.end_time_id).ids
    errors.add(:appointment, "start time invalid") unless ids.include?(company.start_time_id)
    errors.add(:appointment, "end time invalid") unless ids.include?(company.end_time_id)
  end

  def validate_overlapping
    errors.add(:appointment, "slots overlapping") if datetime_wise_appointments&.find {|ap| ap["total_bookings"] >= company.chairs }
  end

  def datetime_wise_appointments
    status = Appointment.statuses[:cancelled]
    query = "SELECT Agg.id as slot_id, Agg.from_time as start_time, Agg.date, COUNT(*) as total_bookings
      FROM(SELECT ts.from_time, ts.to_time, ts.id, ap.date FROM appointments as ap
      CROSS JOIN time_slots as ts
      WHERE ts.id >= ap.start_time_id AND
      ts.id <= ap.end_time_id AND
      ap.date between '#{date}' AND '#{date}' AND
      ts.id between #{start_time_id} AND #{end_time_id} AND
      ap.status != #{status}) as Agg
      GROUP BY Agg.id, Agg.date"
    ActiveRecord::Base.connection.exec_query(query)
  end

  def self.slot_wise_appointments(company:, start_date: Date.today, end_date: Date.today+7.days, statuses: nil)
    status_condition = statuses.present? ? "AND ap.status in (#{statuses.join(",")})" : ""
    chairs = company.chairs || 0
    query = "select Agg.id as slot_id, Agg.from_time as start_time, Agg.date, COUNT(*) as total_bookings, #{chairs}-COUNT(*) as available_bookings
      FROM(select ts.from_time, ts.to_time, ts.id, ap.date FROM appointments as ap CROSS JOIN time_slots as ts
      WHERE ap.company_id= #{company.id} AND ts.id >= ap.start_time_id AND ts.id <= ap.end_time_id AND ap.date between '#{start_date}' AND '#{end_date}' #{status_condition} ) as Agg
      GROUP BY Agg.id, Agg.date"
    ActiveRecord::Base.connection.exec_query(query)
  end

  def self.status_wise_appointments(company:, start_date:, end_date:, statuses:)
    Appointment.joins(:service)
    .joins("INNER JOIN time_slots t1 ON t1.id = appointments.start_time_id")
    .joins("INNER JOIN time_slots t2 ON t2.id = appointments.end_time_id")
    .select("appointments.id, services.price, appointments.date, appointments.start_time_id, appointments.end_time_id, t1.from_time as s_time, t2.to_time as e_time")
    .where("appointments.company_id": company.id, "appointments.status": statuses, "appointments.date": start_date..end_date)
  end

end
