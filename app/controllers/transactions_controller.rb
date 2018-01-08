class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]
  before_action :sufficient_balance?, :accounts_exists?, :source_and_target_equals?, only: [:create]

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
        :transaction_target_type,
        :external_account
    )
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_service
    @transaction_service ||= TransactionsService.new(new_transaction: transaction_params)
  end

  def accounts_exists?
    @source_account = Account.find(transaction_params[:account_id])
    if transaction_params[:transaction_target_type] == Transaction.transaction_target_types[:internal]
      @target_account = Account.find(transaction_params[:destination_account])
    end
  end

  def sufficient_balance?
    if transaction_params[:transaction_type] != Transaction.transaction_types[:fund]
      enough_balance?(transaction_params) || raise(ExceptionHandler::InsufficientFunds, Message.insufficient_funds)
    end
  end

  def source_and_target_equals?
    if transaction_params[:transaction_type] != 'fund' && transaction_params[:account_id] == transaction_params[:destination_account]
      raise(ExceptionHandler::SameSourceTargetAccount, Message.same_source_target_account)
    end
  end

end
