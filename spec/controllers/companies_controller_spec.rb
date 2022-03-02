require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
render_views
  let!(:user) { create(:user) }

  describe "company" do

    before { 
      sign_in(user) 
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      @request.headers.merge! headers
    }

    context "#index" do
      it "render company list" do
        time_slot1 = create(:time_slot, from_time: "10:00", to_time: "10:15")
        time_slot2 = create(:time_slot, from_time: "10:15", to_time: "10:30")
        company = create_list(:company, 5, start_time: time_slot1, end_time: time_slot2)

        get :index, params: {}

        response_json = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_json["data"].length).to equal(5)
      end
    end
  end
end
