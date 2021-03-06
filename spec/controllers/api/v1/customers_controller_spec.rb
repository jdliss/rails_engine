require "rails_helper"

RSpec.describe Api::V1::CustomersController do
  before(:each) do
    @customer = Customer.create(
      first_name: "Dave",
      last_name: "Chappelle",
    )

    Customer.create(
      first_name: "James",
      last_name: "Jones",
    )

  end

  describe "index" do
    it "responds with an index of customers" do

      get :index, format: :json
      customers_hash = JSON.parse(response.body, symbolize_names: true)
      first_customer = customers_hash.first
      second_customer = customers_hash.last

      expect(response).to have_http_status(:success)
      expect(first_customer[:first_name]).to eq "Dave"
      expect(first_customer[:last_name]).to eq "Chappelle"

      expect(second_customer[:first_name]).to eq "James"
      expect(second_customer[:last_name]).to eq "Jones"
    end
  end

  describe "show" do
    it "responds with the requested customer" do
      id = @customer.id
      get :show, format: :json, id: id

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash[:first_name]).to eq "Dave"
      expect(customer_hash[:last_name]).to eq "Chappelle"
    end

    it "responds with an customer matching passed id" do
      id = @customer.id
      get :show, format: :json, id: id

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash[:first_name]).to eq "Dave"
      expect(customer_hash[:last_name]).to eq "Chappelle"
    end

    it "responds with an customer matching passed name (case insensitive)" do
      name = @customer.first_name.downcase
      get :show, format: :json, first_name: name

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash[:first_name]).to eq "Dave"
      expect(customer_hash[:last_name]).to eq "Chappelle"
    end
  end

  describe "random" do
    it "responds with a random customer" do
      get :random, format: :json

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash).to_not eq nil
      expect(customer_hash[:first_name]).to_not eq nil
      expect(customer_hash[:last_name]).to_not eq nil
    end
  end

  describe "find_all" do
    it "responds with all customers matching passed id" do
      Customer.create(first_name: @customer.first_name, last_name: "another of the same")
      id = @customer.id
      get :find_all, format: :json, id: id

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash.count).to eq 1
      expect(customer_hash.first[:first_name]).to eq "Dave"
      expect(customer_hash.first[:last_name]).to eq "Chappelle"
    end

    it "responds with all customers matching passed name (case insensitive)" do
      Customer.create(first_name: @customer.first_name, last_name: "another of the same")
      name = @customer.first_name.downcase
      get :find_all, format: :json, first_name: name

      customer_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(customer_hash.count).to eq 2
      expect(customer_hash.first[:first_name]).to eq "Dave"
      expect(customer_hash.first[:last_name]).to eq "Chappelle"
    end
  end

  describe "invoices" do
    it "responds with the customer's invoices" do
      Invoice.create(customer_id: @customer.id, status: "shipped")
      Invoice.create(customer_id: @customer.id, status: "returned")
      get :invoices, format: :json, id: @customer.id

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoices.count).to eq 2
      expect(invoices.first[:status]).to eq "shipped"
      expect(invoices.last[:status]).to eq "returned"
    end
  end

  describe "transactions" do
    it "responds with the customer's transactions" do
      invoice = Invoice.create(customer_id: @customer.id, status: "returned")
      Transaction.create(invoice_id: invoice.id, result: "success")
      Transaction.create(invoice_id: invoice.id, result: "failed")
      get :transactions, format: :json, id: @customer.id

      transactions = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transactions.count).to eq 2
      expect(transactions.first[:result]).to eq "success"
      expect(transactions.last[:result]).to eq "failed"
    end
  end
end
