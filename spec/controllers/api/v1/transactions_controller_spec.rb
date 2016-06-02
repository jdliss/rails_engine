require "rails_helper"

RSpec.describe Api::V1::TransactionsController do
  before(:each) do
    merchant1 = Merchant.create(
      name: "Bob's House of Boats"
    )

    customer1 = Customer.create(
      first_name: "Dave",
      last_name: "Chappelle"
    )

    @invoice = Invoice.create(
      customer_id: customer1.id,
      merchant_id: merchant1.id,
      status: "shipped"
    )

    @transaction = Transaction.create(
      invoice_id: @invoice.id,
      credit_card_number: "4654405418249632",
      result: "success"
    )

    merchant2 = Merchant.create(
      name: "Jim's Canoe Rentals"
    )

    customer2 = Customer.create(
      first_name: "James",
      last_name: "Jones"
    )

    invoice = Invoice.create(
      merchant_id: merchant2.id,
      customer_id: customer2.id,
      status: "pending"
    )

    Transaction.create(
      invoice_id: invoice.id,
      credit_card_number: "4017503416578382",
      result: "failed"
    )
  end

  describe "index" do
    it "responds with an index of transactions" do

      get :index, format: :json
      transactions_hash = JSON.parse(response.body, symbolize_names: true)
      first_transaction = transactions_hash.first
      second_transaction = transactions_hash.last

      expect(response).to have_http_status(:success)
      expect(first_transaction[:invoice_id]).to eq @invoice.id
      expect(first_transaction[:credit_card_number]).to eq @transaction.credit_card_number
      expect(first_transaction[:result]).to eq "success"

      expect(second_transaction[:invoice_id]).to eq Transaction.last.invoice_id
      expect(second_transaction[:credit_card_number]).to eq Transaction.last.credit_card_number
      expect(second_transaction[:result]).to eq "failed"
    end
  end

  describe "show" do
    it "responds with the requested transaction" do
      id = @transaction.id
      get :show, format: :json, id: id

      transaction_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transaction_hash[:invoice_id]).to eq @invoice.id
      expect(transaction_hash[:credit_card_number]).to eq @transaction.credit_card_number
      expect(transaction_hash[:result]).to eq "success"
    end

    it "responds with a transaction matching passed id" do
      id = @transaction.id
      get :show, format: :json, id: id

      transaction_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transaction_hash[:invoice_id]).to eq @invoice.id
      expect(transaction_hash[:credit_card_number]).to eq @transaction.credit_card_number
      expect(transaction_hash[:result]).to eq "success"
    end

    it "responds with a transaction matching passed result (case insensitive)" do
      result = @transaction.result.upcase
      get :show, format: :json, result: result

      transaction_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transaction_hash[:invoice_id]).to eq @invoice.id
      expect(transaction_hash[:credit_card_number]).to eq @transaction.credit_card_number
      expect(transaction_hash[:result]).to eq "success"
    end
  end

  describe "random" do
    it "responds with a random transaction" do
      get :random, format: :json

      transaction_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transaction_hash).to_not eq nil
      expect(transaction_hash[:invoice_id]).to_not eq nil
      expect(transaction_hash[:credit_card_number]).to_not eq nil
      expect(transaction_hash[:result]).to_not eq nil
    end
  end

  describe "find_all" do
    it "responds with all transactions matching passed id" do
      Transaction.create(
        result: @transaction.result,
        credit_card_number: @transaction.credit_card_number,
        invoice_id: @invoice.id
      )

      id = @transaction.id
      get :find_all, format: :json, id: id

      transactions_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transactions_hash.count).to eq 1
      expect(transactions_hash.first[:id]).to eq @transaction.id
      expect(transactions_hash.first[:invoice_id]).to eq @transaction.invoice_id
      expect(transactions_hash.first[:credit_card_number]).to eq @transaction.credit_card_number
      expect(transactions_hash.first[:result]).to eq "success"
    end

    it "responds with all transactions matching passed result (case insensitive)" do
      Transaction.create(
        result: @transaction.result,
        credit_card_number: @transaction.credit_card_number,
        invoice_id: @invoice.id
      )

      result = @transaction.result.upcase
      get :find_all, format: :json, result: result

      transactions_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(transactions_hash.count).to eq 2
      expect(transactions_hash.first[:id]).to eq @transaction.id
      expect(transactions_hash.first[:invoice_id]).to eq @transaction.invoice_id
      expect(transactions_hash.first[:credit_card_number]).to eq @transaction.credit_card_number
      expect(transactions_hash.first[:result]).to eq "success"
    end
  end

  describe "invoice" do
    it "responds with the transaction's invoice" do
      get :invoice, format: :json, id: @transaction.id

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice[:status]).to eq "shipped"
    end
  end
end
