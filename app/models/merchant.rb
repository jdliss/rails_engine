class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def revenue(date)
    if date.nil?
      revenue = (transactions.where(result: 'success')
        .joins(:invoice_items)
        .sum('invoice_items.unit_price * invoice_items.quantity')/100.00).to_s
    else
      revenue = (invoices.joins(:transactions).where(transactions: { result: "success"} )
        .where(created_at: date)
        .joins(:invoice_items)
        .sum('invoice_items.unit_price * invoice_items.quantity')/100.0).to_s
    end

    { revenue: revenue }
  end

  def self.most_revenue(num)
    limit(num)
      .joins(:invoice_items)
      .group(:id)
      .order('sum(invoice_items.unit_price * invoice_items.quantity) DESC')
  end

  def self.most_items(num)
    limit(num)
      .joins(invoices: [:transactions, :invoice_items])
      .where(transactions: { result: 'success' })
      .group(:id)
      .order('sum(invoice_items.quantity) DESC')
  end
end
