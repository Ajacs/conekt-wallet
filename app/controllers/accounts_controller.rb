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
    #This is just an example, by lack of time
    # The account_number should be get in another form, this is just for the lab test
    account_number = SecureRandom.uuid.gsub("-", "").hex
    key = 'thesystemsecretkeytocypher';
    cypher_account = AESCrypt.encrypt(key, account_number.to_s)
    @account = current_user.accounts.create!({
        user_id: account_params[:user_id],
        account_type: 'USER',
        balance: 0.0,
        available: true,
        account_number: account_number,
        obfuscated_account:cypher_account
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
