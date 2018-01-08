module TransactionHelper

  def enough_balance?(transaction_params)
    #We consider enough balance if the amount of the transaction plus the commission is less or equal than the balance
    account_balance = Account.find(transaction_params[:account_id])[:balance].to_f
    total = transaction_params[:amount].to_f + transaction_commission(transaction_params)
    account_balance >= total
  end

  def transaction_commission(transaction_params)
    commission = 0.0
    transaction_amount = transaction_params[:amount].to_f
    commission +=
      case transaction_amount
        when 1..1000 then (transaction_amount * 0.03) + 8.0
        when 1001..5000 then (transaction_amount * 0.025) + 6.00
        when 5001..10_000 then (transaction_amount * 0.02) + 4.00
        else (transaction_amount * 0.01) + 3.00
      end
  end
end