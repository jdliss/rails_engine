class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :invoices, through: :invoice_items
  has_many :invoice_items

  def self.most_items(num)
    limit(num)
      .joins(:invoices)
      .group(:id)
      .order('sum(invoice_items.quantity) DESC')
  end


  def self.most_revenue(num)
    limit(num)
      .joins(:invoice_items)
      .group(:id)
      .order('sum(invoice_items.unit_price * invoice_items.quantity) DESC')
  end

end
