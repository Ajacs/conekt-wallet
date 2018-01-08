require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do

  let(:user) {create(:user)}
  let(:headers) {valid_headers}

  describe 'GET index' do

    context ' called without authorization token ' do
      before { get :index }
      it 'responds with unauthorized ' do
        expect(response.body).to match(/{"message":"Missing token"}/)
      end

      it 'has a 422 status code' do
        expect(response.status).to eq(422)
      end
    end

    context 'called with authorization token ' do

      it 'response with status 200' do
        request.headers['Authorization'] = token_generator(user[:id])
        request.headers['Content-Type'] = 'application/json'
        expect(response.status).to eq(200)
        expect(response.body).to be_empty
      end
    end
  end


  describe 'POST create' do
    let(:source_account) {create(:account)}
    let(:target_account) {create(:account)}
    let!(:accounts) {create(:gaccount)} # This GENRATES THE 'GENERAL' ACCOUNT
    let(:transaction_service_instance) { double(TransactionsService) }
    let(:transaction_params) do
      {
          user_id: user[:id],
          account_id: source_account[:id],
          transaction_type: 'fund',
          amount: 2500,
          destination_account: source_account[:id],
          transaction_target_type: 'external'
      }
    end
    context ' called with correct parameters' do
      it 'responds with a 201 status code' do
        request.headers['Authorization'] = token_generator(user[:id])
        request.headers['Content-Type'] = 'application/json'
        post :create, params: transaction_params
        expect(response.status).to eq(201)
      end
    end
    context ' called with incorrect parameters' do
      let(:transaction_params) do
        {
            user_id: user[:id],
            account_id: source_account[:id],
            transaction_type: 'fund',
            amount: 2500,
            destination_account: '7383845949',
            transaction_target_type: 'external'
        }
      end
      it 'responds with a 400 status code' do
        request.headers['Authorization'] = token_generator(user[:id])
        request.headers['Content-Type'] = 'application/json'
        post :create, params: transaction_params
        expect(response.status).to eq(404)
        expect(response.body).to match(/{"message":"Couldn't find Account with 'id'=7383845949"}/)
      end
    end
  end
end
