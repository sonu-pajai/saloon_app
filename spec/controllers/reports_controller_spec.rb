require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
render_views
  let!(:user) { create(:user, role: User.roles[:admin]) }
  let!(:customer) { create(:user, role: User.roles[:customer]) }

  describe "service" do

    before { 
          }

    context "#index" do
      it "render report" do
        sign_in(user) 
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
        @request.headers.merge! headers

        time_slot1 = create(:time_slot, id: 1, from_time: "10:00", to_time: "10:15")
        time_slot2 = create(:time_slot, id: 2, from_time: "10:15", to_time: "10:30")
        time_slot3 = create(:time_slot, id: 3, from_time: "10:30", to_time: "10:45")
        time_slot4 = create(:time_slot, id: 4, from_time: "10:45", to_time: "11:00")
        company = create(:company, start_time: time_slot1, end_time: time_slot4, chairs: 5)
        service1 = create(:service, company: company, time: 20, price: 200)
        service2 = create(:service, company: company, time: 15, price: 100)
        create(:appointment, user: user, company: company, service: service1, start_time: time_slot1, end_time: time_slot2, date: Date.today+1.day, status: Appointment.statuses[:completed])
        create(:appointment, user: user, company: company, service: service1, start_time: time_slot1, end_time: time_slot2, date: Date.today+2.day, status: Appointment.statuses[:completed])
        create(:appointment, user: user, company: company, service: service2, start_time: time_slot1, end_time: time_slot1, date: Date.today+3.day, status: Appointment.statuses[:completed])
        create(:appointment, user: user, company: company, service: service1, start_time: time_slot2, end_time: time_slot3, date: Date.today+4.day, status: Appointment.statuses[:completed])
        create(:appointment, user: user, company: company, service: service2, start_time: time_slot1, end_time: time_slot1, date: Date.today+5.day, status: Appointment.statuses[:completed])

        create(:appointment, user: user, company: company, service: service2, start_time: time_slot1, end_time: time_slot1, date: Date.today+5.day, status: Appointment.statuses[:cancelled])
        cancelled = create(:appointment, user: user, company: company, service: service2, start_time: time_slot4, end_time: time_slot4, date: Date.today+5.day, status: Appointment.statuses[:cancelled])

        get :monthly_reports, params: { company_id: company.id, start_date: Date.today, end_date: Date.today+5.days}

        response_json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_json["data"]["completed_appointments"].length).to equal(5)
        expect(response_json["data"]["cancelled_appointments"].length).to equal(1)
        expect(response_json["data"]["total_revenue_earned"]).to equal(800.0)
        expect(response_json["data"]["total_revenue_lost"]).to equal(100.0)
      end

      it "return unauthorised error" do
        sign_in(customer) 
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
        @request.headers.merge! headers

        time_slot = create(:time_slot, id: 1, from_time: "10:00", to_time: "10:15")
        company = create(:company, start_time: time_slot, end_time: time_slot, chairs: 5)

        get :monthly_reports, params: { company_id: company.id, start_date: Date.today, end_date: Date.today+5.days}

        response_json = JSON.parse(response.body)

        expect(response.status).to eq(403)
        expect(response_json["errors"]).to eq("Access Denied")
      end
    end

  end
end
