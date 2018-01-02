class AccountsController < ApplicationController
  before_action :set_account, only: [:show]

  #GET accounts
  def index
    @accounts = current_user.accounts.all
    json_response(@accounts)
  end

  #GET /accounts/:id
  def show
    json_response(@account)
  end

  #POST /accounts
  def create
    @account = current_user.accounts.create!(account_params)
    json_response(@account, :created)
  end

  private

  def account_params
    params.permit(:user_id, :balance, :account_type)
  end

  def set_account
    @account = Account.find(params[:id])
  end

end
