require 'rails_helper'

RSpec.describe 'Transactions API', type: :request do

  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 10) }
  let!(:accounts) { create_list(:account, 10)}
  let(:transaction_id) { transactions.first.id }
  let!(:accounts) { create(:gaccount)}
  let(:headers) { valid_headers }
  let(:account_id) { accounts.first.id }


  describe 'GET /transactions' do

    before { get '/transactions', headers: headers }

    it 'returns the transaction list' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 2000' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /accounts/:id' do
    before { get "/transactions/#{transaction_id}", headers: headers }

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
    # Tests accounts
    let(:source_account) { create(:account) }
    let(:target_account) { create(:account) }

    context 'When the user makes the request to fund the account ' do
      let(:transaction_params) do
        {
          amount: 1000,
          user_id: user[:id],
          account_id: source_account[:id],
          transaction_type: "fund",
          destination_account: source_account[:id],
          transaction_target_type: "external"
        }.to_json
      end

      before { post '/transactions', params: transaction_params, headers: headers}

      it 'should receive the amount in the response' do
        puts "JSON => ", json
        expect(json['originalAmount']).to eq(1000)
      end
    end



=begin
    context 'when the request is correct an the transaction type is internal transference' do
      let(:transaction_params) do
        {
          amount: 1000,
          user_id: user[:id],
          account_id: source_account[:id],
          transaction_type: Transaction.transaction_types[:transference],
          destination_account: target_account[:id],
          transaction_target_type: Transaction.transaction_target_types[:internal]
        }.to_json
      end


      let(:general_account) { Account.find_by account_type: 'GENERAL'}
      let(:current_transaction) { Transaction.find_by account_id: source_account[:id] }

      # Amounts from transactions constants
      TRANSACTION_AMOUNT = 500.80
      TARGET_ACCOUNT_FINAL_BALANCE = 3001.30
      SOURCE_ACCOUNT_FINAL_BALANCE = 1976.676
      TRANSACTION_COMMISSION = 23.024

      before { post '/transactions', params: transaction_params, headers: headers}

      it 'creates a new transaction' do
        puts "JSON => ", json
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
        expect(general_account[:balance]).to eq(TRANSACTION_COMMISSION)
      end

      it 'generates a transaction for the account ' do
        expect(current_transaction[:amount]).to eq(350.0)
      end

    end
=end

    context 'when the amount is higher than the account balance' do

      let(:transaction_params) do
        {
          amount: 5000.0,
          user_id: user[:id],
          account_id: source_account[:id],
          transaction_type: "transference",
          destination_account: target_account[:id],
          transaction_target_type: "internal"
        }.to_json

      end

      before { post '/transactions', params: transaction_params, headers: headers }


      it 'should get an error message' do
        expect(response.body).to match(/Sorry, there are not enough funds to complete your operation, please change the amount/)
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