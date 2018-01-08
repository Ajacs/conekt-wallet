require 'json'

class TransactionsService

  def initialize(params)
    @transaction = params[:new_transaction]
  end

  def process_fund_account
    response = nil
    new_transaction = create_transaction(@transaction[:transaction_type])
    if external_gateway_call[:status] == 202
      if generate_charge_and_deposit
        Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:success])
        response = {
            'originalAmount' =>  @transaction[:amount],
            'transactionCommission' => transaction_commission,
            'totalDeposited' => @transaction[:amount] - transaction_commission,
            'status' => :created
        }
      else
        Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:error])
        response = {
            'body'=> 'Server error, please retry',
            'status' => :internal_server_error
        }
      end
    end
    response
  end

  def process_transference
    response = nil
    new_transaction = create_transaction(@transaction[:transaction_type])
    external_transference = @transaction[:transaction_target_type] == 'external' && external_gateway_call[:status] == 202 && generate_charge_and_deposit
    internal_transference = @transaction[:transaction_target_type] == 'internal' && generate_charge_and_transfer

    if external_transference || internal_transference
      Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:success])
      response = {
          'originalAmount' =>  @transaction[:amount],
          'transactionCommission' => transaction_commission,
          'totalTransferred' => @transaction[:amount] - transaction_commission,
          'status' => :created
      }
    else
      Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:error])
      response = {
          'body'=> 'Server error, please retry',
          'status' => :internal_server_error
      }
    end
    response
  end

  def process_transaction
    @transaction[:transaction_type] == 'fund' ? process_fund_account : process_transference
  end


  private

  def generate_charge_and_deposit
    commission = transaction_commission
    total_to_deposit = @transaction[:amount] - commission
    transfer_to_target_account(total_to_deposit) && transfer_to_main_account(commission)
  end

  def generate_charge_and_transfer
    commission = transaction_commission
    if @transaction[:transaction_target_type] == 'internal'
      discount_from_source_account && transfer_to_main_account(commission) && transfer_to_target_account(@transaction[:amount])
    else
      discount_from_source_account && transfer_to_main_account(commission)
    end
  end


  def fund_account
    Transaction.transaction do
      begin
        transaction_type = Transaction.transaction_types[:fund]
        create_transaction(transaction_type)
      rescue ActiveRecord::StatementInvalid => exc
        puts 'fund_account error: log this error in some database or file', exc
      end

      end
  end


  def transfer_to_target_account(amount)
    target_account = Account.find(@transaction[:destination_account])
    target_account_balance = target_account[:balance].to_f
    target_account_balance += amount
    Account.transaction do
      begin
        Account.update(target_account[:id], balance: target_account_balance)
        make_income_transaction
      rescue ActiveRecord::StatementInvalid => exc
        puts 'transfer_to_target_account error: log this error in some database or file', exc
      end
    end
  end

  def transfer_to_main_account(amount)
    general_account = Account.find_by account_type: 'GENERAL'
    general_account_balance = general_account[:balance]
    Account.transaction do
      begin
        Account.update(general_account[:id], balance: general_account_balance + amount)
      rescue ActiveRecord::StatementInvalid => exc
        puts 'transfer_to_main_account error: log this error in some database or file', exc
      end
    end
  end

  def make_income_transaction
    target_account = Account.find(@transaction[:destination_account])
    target_account_owner = User.find_by id: target_account[:user_id]
    create_transaction(Transaction.transaction_types[:income], :success, target_account_owner[:id])
  end

  def discount_from_source_account
    total = total_amount
    source_account = Account.find(@transaction[:account_id])
    source_account_balance = source_account[:balance].to_f
    source_account_balance -= total
    Account.transaction do
      begin
        Account.update(source_account[:id], balance: source_account_balance)
      rescue ActiveRecord::StatementInvalid => exc
        puts 'discount_from_source_account error: log this error in some database or file', exc
      end
    end
  end

  def transaction_commission
    commission = 0.0
    transaction_amount = @transaction[:amount].to_f
    commission +=
      case transaction_amount
        when 1..1000 then (transaction_amount * 0.03) + 8.0
        when 1001..5000 then (transaction_amount * 0.025) + 6.00
        when 5001..10_000 then (transaction_amount * 0.02) + 4.00
        else (transaction_amount * 0.01) + 3.00
      end
  end

  def create_transaction(transaction_type, status = :pending, owner_id = nil)
    Transaction.transaction do
      begin
        Transaction.create!(
          user_id: @transaction[:user_id],
          account_id: @transaction[:account_id],
          amount: @transaction[:amount],
          destination_account: @transaction[:destination_account],
          commission: transaction_commission,
          transaction_target_type: @transaction[:transaction_target_type],
          transaction_status: Transaction.transaction_statuses[status],
          transaction_type: transaction_type
        ).tap(&:save!)
      rescue ActiveRecord::StatementInvalid => exc
        puts 'create_transaction error: log this error in some database or file', exc
      end
    end

  end

  def create_transaction_history(transaction, status)
    TransactionHistory.transaction do
      begin
        TransactionHistory.create(
          transaction_id: transaction['id'],
          transaction_status: status,
          status_message: ''
        ).tap(&:save!)
      rescue ActiveRecord::StatementInvalid => exc
        puts 'create_transaction_history error: log this error in some database or file', exc
      end
    end
  end

  def total_amount
    commission = transaction_commission
    @transaction[:amount].to_f + commission
  end

  def enough_balance?
    #We consider enough balance if the amount of the transaction plus the commission is less or equal than the balance
    account_balance = Account.find(@transaction[:account_id])[:balance].to_f
    total = @transaction[:amount].to_f + transaction_commission
    account_balance >= total
  end

  def external_gateway_call
    sleep(5)
    {
      status: 202,
        amount: @transaction[:amount]
    }
  end

end