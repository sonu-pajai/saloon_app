
#generate time slots
# i=1
slots = []
for h in (0..23)
  for m in (0..3)
    from_hour = format('%02d', h)
    from_min = format('%02d', m*15) 
    if from_min.to_i == 45
      to_mins = "00"
      to_hour = from_hour == 23 ? "00" : format('%02d', h+1)
    else
      to_mins = from_min.to_i+15
      to_hour = from_hour == 23 ? "00" : from_hour
    end
    slots << {from_time: "#{from_hour}:#{from_min}", to_time: "#{to_hour}:#{to_mins}" }
  end
end
TimeSlot.create(slots)

#create company
company = Company.create(name: "Kaya", start_time: TimeSlot.first, 
end_time: TimeSlot.last, chairs: 5)

#create services
["hair_spa", "hair_color", "hair_cut", "cartin"].each do|service_name|
  Company.first.services.create(name: service_name, price: 200, time: 25)
end

#create customer
user = User.create(name: "raj", email: "sonupajai22@gmail.com", phone_number: '9090990099', password: "Sonal@2210")

Appointment.create(
  date: Date.today+1.day,
  company: Company.first,
  service: Service.first,
  user: User.first,
  start_time: TimeSlot.fifth, 
  status: 2
)


Appointment.create(
  date: Date.today,
  company: company,
  service: Service.first,
  user: User.first,
  start_time: TimeSlot.first
)

Appointment.create(
  date: Date.today+2.day,
  company: Company.first,
  service: Service.first,
  user: User.first,
  start_time: TimeSlot.first
)

Appointment.create(
  date: Date.today+1.day,
  company: Company.first,
  service: Service.first,
  user: User.first,
  start_time: TimeSlot.first
)