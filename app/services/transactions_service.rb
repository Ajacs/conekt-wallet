require 'json'

class TransactionsService

  def initialize(params)
    @transaction = params[:new_transaction]
  end

  def create_income

  end


  def create_expense

  end

  def process_transaction
    transaction_type_fund = @transaction[:transaction_type] == "fund"
    response = nil
    amount = @transaction[:amount].to_f
    if transaction_type_fund && external_gateway_call[:status] == 202 && fund_account && transfer_to_target_account
      response = {
          'amount' => amount,
          'body' => 'SUCCESS',
          'status' => :created
      }
    else
      if enough_balance?
        transaction_type = Transaction.transaction_types[:expense]
        new_transaction = create_transaction(transaction_type)
        new_transaction_history = create_transaction_history(new_transaction, Transaction.transaction_statuses[:pending])

        if transfer_to_target_account && discount_from_source_account && transfer_to_main_account
          Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:success])
          TransactionHistory.update(new_transaction_history[:id], transaction_status: Transaction.transaction_statuses[:success])
          response = {
              'amount' => amount,
              'body' => 'SUCCESS',
              'status' => :created
          }
        else
          Transaction.update(new_transaction[:id], transaction_status: Transaction.transaction_statuses[:error])
          TransactionHistory.update(new_transaction_history[:id], Transaction.transaction_statuses[:error])
          response = {
              'body'=> 'Server error, please retry',
              'status' => :internal_server_error
          }
        end
      else
        response = {
            'body' => 'The amount of your transactions exceeds the balance, please modify your cantity',
            'status' => :bad_request
        }
      end
      response
    end
  end


  private

  def fund_account
    Transaction.transaction do
      begin
        transaction_type = Transaction.transaction_types[:fund]
        create_transaction(transaction_type)
      rescue Exception => exc
        puts "fund_account error: log this error in some database or file", exc
      end

      end
  end


  def transfer_to_target_account
    puts "TRANSFER TO TARGET ACCCOUNT"
    target_account = Account.find(@transaction[:destination_account])
    target_account_balance = target_account[:balance].to_f
    target_account_balance += @transaction[:amount].to_f
    Account.transaction do
      begin
        Account.update(@transaction[:destination_account], balance: target_account_balance)
        make_income_transaction
      rescue Exception => exc
        puts "transfer_to_target_account error: log this error in some database or file", exc
      end
    end
  end

  def make_income_transaction
    target_account = Account.find_by id: @transaction[:destination_account]
    target_account_owner = User.find_by id: target_account[:id]
    begin
      Transaction.create!(
          user_id: target_account_owner[:id],
          account_id: @transaction[:destination_account],
          amount: @transaction[:amount],
          destination_account: @transaction[:destination_account],
          transaction_status: Transaction.transaction_statuses[:success],
          commission: 0,
          transaction_target_type: @transaction[:transaction_target_type],
          transaction_type: Transaction.transaction_types[:income] #ESTE CAMPO SE REFIERE A : TIPO "FUND", "INCOME", "EXPENSE"
      ).save!
    rescue Exception => exc
      puts "make_income_transaction error: log this error in some database or file", exc
    end
  end

  def discount_from_source_account
    total = total_amount
    source_account = Account.find(@transaction[:account_id])
    source_account_balance = source_account[:balance].to_f
    source_account_balance -= total
    Account.transaction do
      begin
        Account.update(@transaction[:account_id], balance: source_account_balance)
      rescue Exception => exc
        puts "discount_from_source_account error: log this error in some database or file", exc
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

  def create_transaction(transaction_type)
    Transaction.transaction do
      begin
        Transaction.create!(
          user_id: @transaction[:user_id],
          account_id: @transaction[:account_id],
          amount: @transaction[:amount],
          destination_account: @transaction[:destination_account],
          commission: transaction_commission,
          transaction_target_type: @transaction[:transaction_target_type],
          transaction_status: Transaction.transaction_statuses[:pending],
          transaction_type: transaction_type
        ).tap(&:save)
      rescue Exception => exc
        puts "create_transaction error: log this error in some database or file", exc
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
        ).tap(&:save)
      rescue Exception => exc
        puts "create_transaction_history error: log this error in some database or file", exc
      end
    end
  end

  def total_amount
    commission = transaction_commission
    @transaction[:amount].to_f + commission
  end

  def transfer_to_main_account
    general_account = Account.find_by account_type: 'GENERAL'
    general_account_balance = general_account[:balance]
    Account.transaction do
      begin
        Account.update(general_account[:id], balance: general_account_balance + transaction_commission)
      rescue Exception => exc
        puts "transfer_to_main_account error: log this error in some database or file", exc
      end
    end
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