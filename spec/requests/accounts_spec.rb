require 'rails_helper'

RSpec.describe 'Accounts API', type: :request do
  let(:user) { create(:user) }
  let!(:accounts) {create_list(:account, 10, user_id: user.id)}
  let(:account_id) {accounts.first.id}
  let(:headers) { valid_headers }

  describe 'GET /accounts' do

    before { get '/accounts', headers: headers }

    it 'returns accounts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 2000' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /accounts/:id' do

    before { get "/accounts/#{account_id}", headers: headers }

    context 'when the account exists' do
      it 'return the account' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(account_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the account does not exist' do
      let(:account_id) { 100 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Account with 'id'=#{account_id}/)
      end
    end

  end


  describe 'POST /accounts' do
    let(:account_params) do
      {
        balance: 0.0,
        user_id: 1,
        account_type: 0,
        available: TRUE
      }.to_json
    end

    context 'when the request is valid' do
      before { post '/accounts', params: account_params, headers: headers}

      it 'creates a new account' do
        expect(json['balance']).to eq(0.0)
      end

      it 'is available account' do
        expect(json['available']).to eq(true)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

end