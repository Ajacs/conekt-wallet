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
    response = transaction_service.process_transaction
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

  def transaction_service
    @transaction_service ||= TransactionsService.new(transaction: transaction_params)
  end
end
