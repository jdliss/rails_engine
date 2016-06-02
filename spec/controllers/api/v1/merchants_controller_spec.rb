require "rails_helper"

RSpec.describe Api::V1::MerchantsController do
  before(:each) do
    @merchant = Merchant.create(
      name: "Bob's House of Boats",
    )

    Merchant.create(
      name: "Jim's Canoe Rentals",
    )

  end

  describe "index" do
    it "responds with an index of merchants" do

      get :index, format: :json
      merchants_hash = JSON.parse(response.body, symbolize_names: true)
      first_merchant = merchants_hash.first
      second_merchant = merchants_hash.last

      expect(response).to have_http_status(:success)
      expect(first_merchant[:name]).to eq "Bob's House of Boats"

      expect(second_merchant[:name]).to eq "Jim's Canoe Rentals"
    end
  end

  describe "show" do
    it "responds with the requested merchant" do
      id = @merchant.id
      get :show, format: :json, id: id

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash[:name]).to eq "Bob's House of Boats"
    end

    it "responds with a merchant matching passed id" do
      id = @merchant.id
      get :show, format: :json, id: id

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash[:name]).to eq "Bob's House of Boats"
    end

    it "responds with a merchant matching passed name (case insensitive)" do
      name = @merchant.name.downcase
      get :show, format: :json, name: name

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash[:name]).to eq "Bob's House of Boats"
    end
  end

  describe "random" do
    it "responds with a random merchant" do
      get :random, format: :json

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash).to_not eq nil
      expect(merchant_hash[:name]).to_not eq nil
    end
  end

  describe "find_all" do
    it "responds with all merchants matching passed id" do
      Merchant.create(name: @merchant.name)
      id = @merchant.id
      get :find_all, format: :json, id: id

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash.count).to eq 1
      expect(merchant_hash.first[:name]).to eq "Bob's House of Boats"
    end

    it "responds with all merchants matching passed name (case insensitive)" do
      Merchant.create(name: @merchant.name)
      name = @merchant.name.downcase
      get :find_all, format: :json, name: name

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash.count).to eq 2
      expect(merchant_hash.first[:name]).to eq "Bob's House of Boats"
    end
  end

  describe "items" do
    it "responds with all of a merchants items" do
      Item.create(
        name: "thing",
        description: "a thing.",
        merchant_id: @merchant.id
      )

      get :items, format: :json, id: @merchant.id

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_items.count).to eq 1
      expect(merchant_items.first[:name]).to eq "thing"
    end
  end

  describe "invoices" do
    it "responds with all of a merchants invoices" do
      Invoice.create(
        status: "shipped",
        merchant_id: @merchant.id
      )

      get :invoices, format: :json, id: @merchant.id

      merchant_invoices = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_invoices.count).to eq 1
      expect(merchant_invoices.first[:status]).to eq "shipped"
    end
  end

  describe "Merchant.most_revenue" do
    it "responds with top x merchants by revenue" do
      top_merchant = Merchant.create(
        name: "top merchant"
      )
      top_invoice = Invoice.create(merchant_id: top_merchant.id)
      InvoiceItem.create(
        invoice_id: top_invoice.id,
        unit_price: 100,
        quantity: 10
      )

      second_merchant = Merchant.create(
        name: "second merchant"
      )
      second_invoice = Invoice.create(merchant_id: second_merchant.id)
      InvoiceItem.create(
        invoice_id: second_invoice.id,
        unit_price: 100,
        quantity: 5
      )

      third_merchant = Merchant.create(
        name: "third merchant"
      )
      third_invoice = Invoice.create(merchant_id: third_merchant.id)
      InvoiceItem.create(
        invoice_id: third_invoice.id,
        unit_price: 100,
        quantity: 1
      )

      get :most_revenue, format: :json, quantity: 2

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchants.count).to eq 2
      expect(merchants.first[:name]).to eq "top merchant"
      expect(merchants.second[:name]).to eq "second merchant"
    end
  end

  describe "revenue" do
    it "responds with the revenue of the given merchant" do
      merchant = Merchant.create(
        name: "top merchant"
      )

      invoice = Invoice.create(merchant_id: merchant.id)
      transaction = Transaction.create(
        invoice_id: invoice.id,
        result: 'success'
      )

      InvoiceItem.create(
        invoice_id: invoice.id,
        unit_price: 100,
        quantity: 10
      )

      get :revenue, format: :json, id: merchant.id

      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(revenue).to eq ({ :revenue => '10.0' })
    end
  end

  describe "revenue(date)" do
    it "responds with the revenue of the given merchant for a given date" do
      merchant = Merchant.create(
        name: "top merchant"
      )

      invoice = Invoice.create(
        merchant_id: merchant.id,
        created_at: "2012-03-16 11:55:05"
      )

      transaction = Transaction.create(
        invoice_id: invoice.id,
        result: 'success'
      )

      InvoiceItem.create(
        invoice_id: invoice.id,
        unit_price: 100,
        quantity: 10
      )

      get :revenue, format: :json, id: merchant.id, date: "2012-03-16 11:55:05"

      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(revenue).to eq ({ :revenue => '10.0' })
    end
  end

  describe "Merchant.most_items" do
    it "responds with the revenue of the given merchant for a given date" do
      merchant = Merchant.create(
        name: "top merchant"
      )

      Item.create(merchant_id: merchant.id)
      Item.create(merchant_id: merchant.id)
      Item.create(merchant_id: merchant.id)

      merchant2 = Merchant.create(
        name: "second merchant"
      )

      Item.create(merchant_id: merchant2.id)
      Item.create(merchant_id: merchant2.id)

      merchant3 = Merchant.create(
        name: "third merchant"
      )

      Item.create(merchant_id: merchant3.id)

      get :most_items, format: :json, quantity: 2

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchants.count).to eq 2
      expect(merchants.first[:name]).to eq "top merchant"
      expect(merchants.second[:name]).to eq "second merchant"
    end
  end
end
