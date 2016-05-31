namespace :tasks do
  require 'csv'

  desc "load customers from csv"
  task :load_customers => :environment do |t, arg|
    ['db/data/customers.csv'].each do |customer|
      CSV.foreach(customer,:headers => true) do |row|
        id = row.to_hash['id']
        first_name = row.to_hash['first_name']
        last_name = row.to_hash['last_name']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Customer.create(
          id: id,
          last_name: last_name,
          first_name: first_name,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end

  desc "load items from csv"
  task :load_items => :environment do |t, arg|
    ['db/data/items.csv'].each do |item|
      CSV.foreach(item,:headers => true) do |row|
        id = row.to_hash['id']
        name = row.to_hash['name']
        description = row.to_hash['description']
        unit_price = row.to_hash['unit_price']
        merchant_id = row.to_hash['merchant_id']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Item.create(
          id: id,
          name: name,
          description: description,
          unit_price: unit_price,
          merchant_id: merchant_id,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end

  desc "load merchants from csv"
  task :load_merchants => :environment do |t, arg|
    ['db/data/merchants.csv'].each do |merchant|
      CSV.foreach(merchant,:headers => true) do |row|
        id = row.to_hash['id']
        name = row.to_hash['name']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Merchant.create(
          id: id,
          name: name,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end

  desc "load invoices from csv"
  task :load_invoices => :environment do |t, arg|
    ['db/data/invoices.csv'].each do |invoice|
      CSV.foreach(invoice,:headers => true) do |row|
        id = row.to_hash['id']
        customer_id = row.to_hash['customer_id']
        merchant_id = row.to_hash['merchant_id']
        status = row.to_hash['status']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Transaction.create(
          id: id,
          name: name,
          credit_card_number: credit_card_number,
          credit_card_expiration_date: credit_card_expiration_date,
          result: result,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end

  desc "load transactions from csv"
  task :load_transactions => :environment do |t, arg|
    ['db/data/transactions.csv'].each do |transaction|
      CSV.foreach(transaction,:headers => true) do |row|
        id = row.to_hash['id']
        invoice_id = row.to_hash['invoice_id']
        credit_card_number = row.to_hash['credit_card_number']
        credit_card_expiration_date = row.to_hash['credit_card_expiration_date']
        result = row.to_hash['result']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Transaction.create(
          id: id,
          name: name,
          credit_card_number: credit_card_number,
          credit_card_expiration_date: credit_card_expiration_date,
          result: result,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end

  desc "load invoice items from csv"
  task :load_invoice_items => :environment do |t, arg|
    ['db/data/invoice_items.csv'].each do |invoice_item|
      CSV.foreach(invoice_item,:headers => true) do |row|
        id = row.to_hash['id']
        item_id = row.to_hash['item_id']
        invoice_id = row.to_hash['invoice_id']
        quantity = row.to_hash['quantity']
        unit_price = row.to_hash['unit_price']
        created_at = row.to_hash['created_at']
        updated_at = row.to_hash['updated_at']
        Invoice.create(
          id: id,
          item_id: item_id,
          invoice_id: invoice_id,
          quantity: quantity,
          unit_price: unit_price,
          created_at: created_at,
          updated_at: updated_at
        )
      end
    end
  end
end
