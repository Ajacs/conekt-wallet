class TransactionsService

  def initialize(params)
    @transaction = params[:transaction]
  end

  def create_income

  end


  def create_expense

  end

  def process_transaction
    transaction_type = @transaction.transaction_type
    case 0
  end

  def enough_balance?
    #We consider enough balance if the amount of the transaction and
    # the commission is less or equal than the balance
    account_balance = Account.find(@transaction.account_id)
    total = @transaction.amount + transaction_commission
    account_balance > total
  end

  private

  def transaction_commission
    commission = 0.0
    transaction_amount = @transaction.amount

    commission += 
      case transaction_amount
        when  1..1000
          (transaction_amount * 0.03) + 8.0
        when 1000..5000
          (transaction_amount * 0.025) + 6.00
        when 5000..10_000
          (transaction_amount * 0.02) + 4.00
        else
          (transaction_amount * 0.01) + 3.00
      end

    commission
  end

end