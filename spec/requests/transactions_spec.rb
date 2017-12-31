require 'rails_helper'

RSpec.describe 'Transactions API', type: :request do

  let!(:transactions) { create_list(:transaction, 10) }
  let!(:accounts) { create_list(:account, 1)}
  let(:transaction_id) { transactions.first.id }

  describe 'GET /transactions' do

    before { get '/transactions' }

    it 'returns the transaction list' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 2000' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /accounts/:id' do
    before { get "/transactions/#{transaction_id}" }

    context 'when the transaction exists' do
      it 'return the account' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(transaction_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the transaction does not exist' do
      let(:transaction_id) { 100 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'return a not found message' do
        expect(response.body).to match(/Couldn't find Transaction with 'id'=#{transaction_id}/)
      end
    end
  end

  describe 'POST /transactions' do
    context 'when the request is correct' do

      let(:transaction_params) {
        {
            amount: 500.80,
            user_id: 1,
            account_id: 1,
            transaction_type: 0,
            transaction_status: 0,
            destination_account: 2

        }
      }

      before { post '/transactions', params: transaction_params}

      it 'creates a new transaction' do
        expect(json['amount']).to eq(500.80)
      end
    end

    context 'when the amount is higher than the account balance' do

      let(:transaction_params) {
        {
            amount: 5000.0,
            user_id: 1,
            account_id: 1,
            transaction_type: 0,
            transaction_status: 0,
            destination_account: 2
        }
      }

      before { post '/transactions', params: transaction_params }

      it 'should get an error message' do
        expect(response.body).to match(/The amount of your transactions exceeds the balance, please modify your cantity/)
      end
    end

    context 'when the amount the sum of the amount plus commissions exceeds the balance' do

    end

    context 'when the account is of debit, and the transaction is success' do

    end

    context 'when the account is of debit, and the transaction is failed' do

    end

    context 'when the type of transaction is INCOME' do

    end

    context 'when the type of transaction is EXPENSE' do

    end

    context 'when the type of transaction is TRANSFERENCE' do

    end

    context 'when the transaction is EXPENSE or TRANSFERENCE and is success' do

    end

    context 'when the transaction is EXPENSE or TRANSFERENCE and is failed' do

    end

  end
end