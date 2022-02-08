require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #login' do
    context 'with valid email and password' do
      it 'should return new token' do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        pass = Faker::Internet.password
        user = create(:user, password: pass)

        post :create, params: {user: {email: user.email, password: pass}}, format: :json

        res = JSON.parse(response.body)

        expect(res['data']['token']).to be_present
        expect(response.status).to eq 200
      end
    end

    context 'with incorrect params' do
      it 'should assign user as nil' do
        @request.env["devise.mapping"] = Devise.mappings[:user]

        post :create, params: {user: {email: "dummy@test.com", password: "testpass"}}, format: :json

        res = JSON.parse(response.body)

        expect(response.status).to eq 401
        expect(res['error']).to be_present
        expect(res['error']).to eq "Invalid Email or password."
      end
    end
  end
end
