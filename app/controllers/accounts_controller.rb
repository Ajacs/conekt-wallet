require 'securerandom'
require 'bcrypt'

class AccountsController < ApplicationController
  before_action :set_account, only: [:show]

  #GET accounts
  def index
    user_id = params[:user_id]
    user_id_accounts = Account.find_by user_id: user_id
    @accounts = user_id ? user_id_accounts : Account.all
    json_response(@accounts)
  end

  #GET /accounts/:id
  def show
    json_response(@account)
  end

  #POST /accounts
  def create
    account_params['account_type'] = 'USER'
    @account = current_user.accounts.create!({
        user_id: account_params[:user_id],
        account_type: 'USER',
        balance: 0.0,
        available: true
                                             })
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
