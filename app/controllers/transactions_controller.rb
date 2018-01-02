class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]

  api :GET, '/transactions/:id'
  param :id, :number
  def index
    by_user_id = Transaction.find_by user_id: params[:user_id]
    @transactions = params[:user_id] ? by_user_id : Transaction.all
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
        :user_id,
        :account_id,
        :destination_account,
        :transaction_target_type
    )
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_service
    @transaction_service ||= TransactionsService.new(new_transaction: transaction_params)
  end
end
