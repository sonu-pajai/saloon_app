require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
render_views
  let!(:user) { create(:user) }

  describe "service" do

    before { 
      sign_in(user) 
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      @request.headers.merge! headers
    }

    context "#index" do
      it "render service list" do
        time_slot1 = create(:time_slot, from_time: "10:00", to_time: "10:15")
        time_slot2 = create(:time_slot, from_time: "10:15", to_time: "10:30")
        company = create(:company, start_time: time_slot1, end_time: time_slot2)
        create_list(:service, 5, company: company)

        get :index, params: { company_id: company.id}

        response_json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_json["data"]["services"].length).to equal(5)
      end

      it "render all time_slots && booked slots" do
        time_slot1 = create(:time_slot, id: 1, from_time: "10:00", to_time: "10:15")
        time_slot2 = create(:time_slot, id: 2, from_time: "10:15", to_time: "10:30")
        time_slot3 = create(:time_slot, id: 3, from_time: "10:30", to_time: "10:45")
        time_slot4 = create(:time_slot, id: 4, from_time: "10:45", to_time: "11:00")
        time_slot5 = create(:time_slot, id: 5, from_time: "11:00", to_time: "11:15")
        company = create(:company, start_time: time_slot1, end_time: time_slot3)
        service = create(:service, company: company)
        create(:appointment, user: user, company: company, service: service, start_time: time_slot1, end_time: time_slot2)
        create(:appointment, user: user, company: company, service: service, start_time: time_slot3, end_time: time_slot4)
        date = Date.today.strftime("%Y-%m-%d")
        get :index, params: { company_id: company.id}

        response_json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_json["data"]["slots"].length).to equal(3)
        expect(response_json["data"]["booked_slots"].length).to equal(4)

        expect(response_json["data"]["booked_slots"]).to eq([{"slot_id"=>1, "start_time"=>"10:00", "date"=>"2022-03-03", "total_bookings"=>1, "available_bookings"=>4},
         {"slot_id"=>2, "start_time"=>"10:15", "date"=>"2022-03-03", "total_bookings"=>1, "available_bookings"=>4},
         {"slot_id"=>3, "start_time"=>"10:30", "date"=>"2022-03-03", "total_bookings"=>1, "available_bookings"=>4},
         {"slot_id"=>4, "start_time"=>"10:45", "date"=>"2022-03-03", "total_bookings"=>1, "available_bookings"=>4}])
      end
    end

  end
end
