class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    @transactions = Transaction.all
    json_response(@transactions)
  end

  def show
    json_response(@transaction)
  end

  def create
    transaction_service = TransactionsService.new(transaction: transaction_params)
    response = transaction_service.process_transaction
    @transaction = Transaction.create!(transaction_params)
    json_response(response, response['status'])
  end

  private

  def transaction_params
    params.permit(
      :amount,
        :transaction_type,
        :transaction_status,
        :user_id,
        :account_id,
        :destination_account
    )
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
