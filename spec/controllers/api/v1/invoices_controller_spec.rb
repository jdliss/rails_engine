require "rails_helper"

RSpec.describe Api::V1::InvoicesController do
  before(:each) do
    @merchant = Merchant.create(
      name: "Bob's House of Boats"
    )

    @customer = Customer.create(
      first_name: "Dave",
      last_name: "Chappelle"
    )

    @invoice = Invoice.create(
      customer_id: @customer.id,
      merchant_id: @merchant.id,
      status: "shipped"
    )

    merchant2 = Merchant.create(
      name: "Jim's Canoe Rentals"
    )

    customer2 = Customer.create(
      first_name: "James",
      last_name: "Jones"
    )

    Invoice.create(
      merchant_id: merchant2.id,
      customer_id: customer2.id,
      status: "pending"
    )
  end

  describe "index" do
    it "responds with an index of invoices" do

      get :index, format: :json
      invoices_hash = JSON.parse(response.body, symbolize_names: true)
      first_invoice = invoices_hash.first
      second_invoice = invoices_hash.last

      expect(response).to have_http_status(:success)
      expect(first_invoice[:status]).to eq "shipped"
      expect(first_invoice[:customer_id]).to eq @customer.id
      expect(first_invoice[:merchant_id]).to eq @merchant.id

      expect(second_invoice[:status]).to eq "pending"
      expect(second_invoice[:customer_id]).to eq Customer.last.id
      expect(second_invoice[:merchant_id]).to eq Merchant.last.id
    end
  end

  describe "show" do
    it "responds with the requested invoice" do
      id = @invoice.id
      get :show, format: :json, id: id

      invoice_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_hash[:status]).to eq "shipped"
      expect(invoice_hash[:customer_id]).to eq @customer.id
      expect(invoice_hash[:merchant_id]).to eq @merchant.id
    end

    it "responds with an invoice matching passed id" do
      id = @invoice.id
      get :show, format: :json, id: id

      invoice_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_hash[:status]).to eq "shipped"
      expect(invoice_hash[:customer_id]).to eq @customer.id
      expect(invoice_hash[:merchant_id]).to eq @merchant.id
    end

    it "responds with an invoice matching passed status (case insensitive)" do
      status = @invoice.status.upcase
      get :show, format: :json, status: status

      invoices_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoices_hash[:status]).to eq "shipped"
      expect(invoices_hash[:customer_id]).to eq @customer.id
      expect(invoices_hash[:merchant_id]).to eq @merchant.id
    end
  end

  describe "random" do
    it "responds with a random invoice" do
      get :random, format: :json

      invoice_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_hash).to_not eq nil
      expect(invoice_hash[:status]).to_not eq nil
    end
  end

  describe "find_all" do
    it "responds with all invoices matching passed id" do
      Invoice.create(status: @invoice.status)
      id = @invoice.id
      get :find_all, format: :json, id: id

      invoices_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoices_hash.count).to eq 1
      expect(invoices_hash.first[:status]).to eq "shipped"
      expect(invoices_hash.first[:customer_id]).to eq @customer.id
      expect(invoices_hash.first[:merchant_id]).to eq @merchant.id
    end

    it "responds with all invoices matching passed name (case insensitive)" do
      Invoice.create(status: @invoice.status)
      status = @invoice.status.downcase
      get :find_all, format: :json, status: status

      invoices_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoices_hash.count).to eq 2
      expect(invoices_hash.first[:status]).to eq "shipped"
      expect(invoices_hash.first[:customer_id]).to eq @customer.id
      expect(invoices_hash.first[:merchant_id]).to eq @merchant.id
    end
  end

  describe "transactions" do
    it "responds with all the current invoice's transactions" do
      Transaction.create(
        credit_card_number: '4580251236515201',
        invoice_id: @invoice.id,
        result: "success"
      )
      Transaction.create(
        credit_card_number: '4580251236515201',
        invoice_id: @invoice.id,
        result: "failed"
      )

      get :transactions, format: :json, id: @invoice.id

      invoice_transactions = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_transactions.count).to eq 2
      expect(invoice_transactions.first[:result]).to eq "success"
      expect(invoice_transactions.last[:result]).to eq "failed"
      expect(invoice_transactions.first[:credit_card_number]).to eq '4580251236515201'
      expect(invoice_transactions.first[:invoice_id]).to eq @invoice.id
    end
  end

  describe "invoice_items" do
    it "responds with all the current invoice's invoice items" do
      InvoiceItem.create(invoice_id: @invoice.id, quantity: 123)
      InvoiceItem.create(invoice_id: @invoice.id, quantity: 321)

      get :invoice_items, format: :json, id: @invoice.id

      invoice_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items.count).to eq 2
      expect(invoice_items.first[:quantity]).to eq 123
      expect(invoice_items.last[:quantity]).to eq 321
      expect(invoice_items.first[:invoice_id]).to eq @invoice.id
    end
  end

  describe "items" do
    it "responds with all the current invoice's items" do
     item = Item.create(name: "thing", description: "a thing.")
      InvoiceItem.create(
        item_id: item.id,
        invoice_id: @invoice.id,
        quantity: 123
      )

      get :items, format: :json, id: @invoice.id

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(items.count).to eq 1
      expect(items.first[:name]).to eq "thing"
      expect(items.last[:description]).to eq "a thing."
    end
  end

  describe "customer" do
    it "responds with all the current invoice's customer" do
      get :customer, format: :json, id: @invoice.id

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer[:first_name]).to eq "Dave"
      expect(customer[:last_name]).to eq "Chappelle"
    end
  end

  describe "customer" do
    it "responds with all the current invoice's customer" do
      get :merchant, format: :json, id: @invoice.id

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer[:name]).to eq "Bob's House of Boats"
    end
  end
end
