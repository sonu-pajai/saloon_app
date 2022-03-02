require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
render_views
  let!(:user) { create(:user) }
  let!(:time_slot1) { create(:time_slot, id: 1, from_time: "10:00", to_time: "10:15") }
  let!(:time_slot2) { create(:time_slot, id: 2, from_time: "10:15", to_time: "10:30") }
  let!(:time_slot3) { create(:time_slot, id: 3, from_time: "10:30", to_time: "10:45") }

  describe "appointments" do

    before { 
      sign_in(user) 
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      @request.headers.merge! headers
    }

    context "#index" do
      it "render users appointments list" do
        time_slot4 = create(:time_slot, id: 4, from_time: "10:45", to_time: "11:00")
        time_slot5 = create(:time_slot, id: 5, from_time: "11:00", to_time: "11:15")
        company = create(:company, start_time: time_slot1, end_time: time_slot3)
        service = create(:service, company: company)
        new_user = create(:user)
        create(:appointment, user: user, company: company, service: service, start_time: time_slot1, end_time: time_slot2)
        create(:appointment, user: user, company: company, service: service, start_time: time_slot3, end_time: time_slot4)
        create(:appointment, user: new_user, company: company, service: service, start_time: time_slot3, end_time: time_slot4)

        get :index, params: {}

        response_json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_json["data"].length).to equal(2)
      end
    end

    context "#create" do
      it "should create appointment" do
        company = create(:company, start_time: time_slot1, end_time: time_slot3)
        service = create(:service, company: company)
        new_user = create(:user)
        date = Date.today.strftime("%Y-%m-%d")

        get :create, params: {appointment: {company_id: company.id, service_id: service.id, start_time_id: time_slot1.id, date:date}}

        response_json = JSON.parse(response.body)
  
        expect(response).to be_successful
        expect(Appointment.count).to equal(1)
        expect(response_json["message"]).to eq("Appointment with 00#{Appointment.last.id} ID created successfully")
      end

    end
  end
end
