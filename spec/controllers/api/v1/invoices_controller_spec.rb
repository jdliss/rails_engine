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

  describe "find" do
    it "responds with an invoice matching passed id" do
      id = @invoice.id
      get :find, format: :json, id: id

      invoice_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_hash[:status]).to eq "shipped"
      expect(invoice_hash[:customer_id]).to eq @customer.id
      expect(invoice_hash[:merchant_id]).to eq @merchant.id
    end

    it "responds with an invoice matching passed status (case insensitive)" do
      status = @invoice.status.upcase
      get :find, format: :json, status: status

      invoices_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoices_hash[:status]).to eq "shipped"
      expect(invoices_hash[:customer_id]).to eq @customer.id
      expect(invoices_hash[:merchant_id]).to eq @merchant.id
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
end
