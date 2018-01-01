require 'rails_helper'

RSpec.describe 'Transactions API', type: :request do

  let!(:transactions) { create_list(:transaction, 10) }
  let!(:accounts) { create_list(:account, 2)}
  let(:transaction_id) { transactions.first.id }
  let!(:accounts) { create(:gaccount)}



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

      let(:source_account_balance) { Account.find(1)[:balance] }
      let(:target_account_balance) { Account.find(2)[:balance] }
      let(:general_account_balance) { Account.find_by account_type: 'GENERAL'}

      # Amounts from transactions constants
      TRANSACTION_AMOUNT = 500.80
      TARGET_ACCOUNT_FINAL_BALANCE = 3001.30
      SOURCE_ACCOUNT_FINAL_BALANCE = 1976.676
      TRANSACTION_COMMISSION = 23.024

      before { post '/transactions', params: transaction_params}

      it 'creates a new transaction' do
        expect(json['amount']).to eq(TRANSACTION_AMOUNT)
      end

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'add the amount to the destination account' do
        expect(target_account_balance).to eq(TARGET_ACCOUNT_FINAL_BALANCE)
      end

      it 'subtract the total amount from the balance of the user' do
        expect(source_account_balance).to eq(SOURCE_ACCOUNT_FINAL_BALANCE)
      end

      it 'add the commission to the general account' do
        expect(general_account_balance[:balance]).to eq(TRANSACTION_COMMISSION)
      end

      it 'generates a transaction with the status PROCESSING'

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

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

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