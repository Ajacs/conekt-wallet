require 'json'

class TransactionsService

  def initialize(params)
    @transaction = params[:transaction]
  end

  def create_income

  end


  def create_expense

  end

  def process_transaction
    amount = @transaction[:amount].to_f
    response = nil
    if enough_balance?
      #start the transaction with PROCESSING STATUS
      new_transaction = Transaction.create(
          {
          user_id: @transaction[:user_id],
          account_id: @transaction[:account_id],
          amount: @transaction[:amount],
          destination_account: @transaction[:destination_account]
          }).save
      if transfer_to_target_account && discount_from_source_account && transfer_to_main_account
        #Update the transaction status to SUCCESS
        response = {
        'amount' => amount,
        'body' => 'SUCCESS',
            'status' => :created
        }
      else
        #Update the transaction status to ERROR
      end
    else
      response = {
          'body' => 'The amount of your transactions exceeds the balance, please modify your cantity',
          'status' => :bad_request
      }
    end
    response
    #transaction_type = @transaction.transaction_type === TransactionTypes::INCOME
  end



  private

  def transfer_to_target_account
    target_account = Account.find(@transaction[:destination_account])
    target_account_balance = target_account[:balance].to_f
    target_account_balance += @transaction[:amount].to_f
    Account.update(@transaction[:destination_account], balance: target_account_balance)
  end

  def discount_from_source_account
    total = total_amount
    source_account = Account.find(@transaction[:account_id])
    source_account_balance = source_account[:balance].to_f
    source_account_balance -= total
    Account.update(@transaction[:account_id], balance: source_account_balance)
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

  def total_amount
    commission = transaction_commission
    @transaction[:amount].to_f + commission
  end

  def transfer_to_main_account
    general_account = Account.find_by account_type: 'GENERAL'
    general_account_balance = general_account[:balance]
    Account.update(general_account[:id], balance: general_account_balance + transaction_commission)
  end

  def enough_balance?
    #We consider enough balance if the amount of the transaction plus the commission is less or equal than the balance
    account_balance = Account.find(@transaction[:account_id])[:balance].to_f
    total = @transaction[:amount].to_f + transaction_commission
    account_balance >= total
  end

  def external_gateway_call
    sleep(5)
    puts "SE HA PROCESADO TU SOPLICITUD"
  end

end