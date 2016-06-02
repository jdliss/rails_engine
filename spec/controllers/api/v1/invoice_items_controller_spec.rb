require "rails_helper"

RSpec.describe Api::V1::InvoiceItemsController do
  before(:each) do
    merchant = Merchant.create(
      name: "Bob's House of Boats"
    )

    customer = Customer.create(
      first_name: "Dave",
      last_name: "Chappelle"
    )

    @invoice = Invoice.create(
      customer_id: customer.id,
      merchant_id: merchant.id,
      status: "shipped"
    )

    @item = Item.create(
      name: "Chair",
      description: "It's a chair.",
      unit_price: 10,
      merchant_id: merchant.id
    )

    @invoice_item = InvoiceItem.create(
      item_id: @item.id,
      invoice_id: @invoice.id,
      quantity: 10,
      unit_price: 100
    )

    merchant2 = Merchant.create(
      name: "Jim's Canoe Rentals"
    )

    customer2 = Customer.create(
      first_name: "James",
      last_name: "Jones"
    )

    item = Item.create(
      name: "Computer",
      description: "Stop all the downloading",
      unit_price: 99,
      merchant_id: merchant2.id
    )

    invoice = Invoice.create(
      merchant_id: merchant2.id,
      customer_id: customer2.id,
      status: "pending"
    )

    InvoiceItem.create(
      item_id: item.id,
      invoice_id: invoice.id,
      quantity: 99,
      unit_price: 99
    )
  end

  describe "index" do
    it "responds with an index of invoice items" do

      get :index, format: :json
      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)
      first_invoice_item = invoice_items_hash.first
      second_invoice_item = invoice_items_hash.last

      expect(response).to have_http_status(:success)
      expect(first_invoice_item[:quantity]).to eq 10
      expect(first_invoice_item[:unit_price]).to eq '1.0'
      expect(first_invoice_item[:item_id]).to eq @item.id
      expect(first_invoice_item[:invoice_id]).to eq @invoice.id

      expect(second_invoice_item[:quantity]).to eq 99
      expect(second_invoice_item[:unit_price]).to eq '0.99'
      expect(second_invoice_item[:item_id]).to eq Item.last.id
      expect(second_invoice_item[:invoice_id]).to eq Invoice.last.id
    end
  end

  describe "show" do
    it "responds with the requested invoice item" do
      id = @invoice_item.id
      get :show, format: :json, id: id

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash[:quantity]).to eq 10
      expect(invoice_items_hash[:unit_price]).to eq '1.0'
      expect(invoice_items_hash[:item_id]).to eq @item.id
      expect(invoice_items_hash[:invoice_id]).to eq @invoice.id
    end

    it "responds with an invoice item matching passed id" do
      id = @invoice_item.id
      get :show, format: :json, id: id

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash[:quantity]).to eq 10
      expect(invoice_items_hash[:unit_price]).to eq '1.0'
      expect(invoice_items_hash[:item_id]).to eq @item.id
      expect(invoice_items_hash[:invoice_id]).to eq @invoice.id
    end

    it "responds with an invoice item matching passed quantity" do
      quantity = @invoice_item.quantity
      get :show, format: :json, quantity: quantity

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash[:quantity]).to eq 10
      expect(invoice_items_hash[:unit_price]).to eq '1.0'
      expect(invoice_items_hash[:item_id]).to eq @item.id
      expect(invoice_items_hash[:invoice_id]).to eq @invoice.id
    end

    it "responds with an invoice item matching passed unit price" do
      unit_price = @invoice_item.unit_price
      get :show, format: :json, unit_price: unit_price

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash[:quantity]).to eq 10
      expect(invoice_items_hash[:unit_price]).to eq '1.0'
      expect(invoice_items_hash[:item_id]).to eq @item.id
      expect(invoice_items_hash[:invoice_id]).to eq @invoice.id
    end
  end

  describe "random" do
    it "responds with a random invoice item" do
      get :random, format: :json

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash[:quantity]).to_not eq nil
      expect(invoice_items_hash[:unit_price]).to_not eq nil
    end
  end

  describe "find_all" do
    it "responds with all invoice items matching passed id" do
      InvoiceItem.create(
        quantity: @invoice_item.quantity,
        unit_price: @invoice_item.unit_price,
        item_id: @item.id,
        invoice_id: @invoice.id
      )

      id = @invoice_item.id
      get :find_all, format: :json, id: id

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash.count).to eq 1
      expect(invoice_items_hash.first[:quantity]).to eq 10
      expect(invoice_items_hash.first[:unit_price]).to eq '1.0'
      expect(invoice_items_hash.first[:item_id]).to eq @item.id
      expect(invoice_items_hash.first[:invoice_id]).to eq @invoice.id
    end

    it "responds with all invoice items matching passed quantity" do
      InvoiceItem.create(
        quantity: @invoice_item.quantity,
        unit_price: @invoice_item.unit_price,
        item_id: @item.id,
        invoice_id: @invoice.id
      )

      quantity = @invoice_item.quantity
      get :find_all, format: :json, quantity: quantity

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash.count).to eq 2
      expect(invoice_items_hash.first[:quantity]).to eq 10
      expect(invoice_items_hash.first[:unit_price]).to eq '1.0'
      expect(invoice_items_hash.first[:item_id]).to eq @item.id
      expect(invoice_items_hash.first[:invoice_id]).to eq @invoice.id
    end

    it "responds with all invoice items matching passed unit price" do
      InvoiceItem.create(
        quantity: @invoice_item.quantity,
        unit_price: @invoice_item.unit_price,
        item_id: @item.id,
        invoice_id: @invoice.id
      )

      unit_price = @invoice_item.unit_price
      get :find_all, format: :json, unit_price: unit_price

      invoice_items_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice_items_hash.count).to eq 2
      expect(invoice_items_hash.first[:quantity]).to eq 10
      expect(invoice_items_hash.first[:unit_price]).to eq '1.0'
      expect(invoice_items_hash.first[:item_id]).to eq @item.id
      expect(invoice_items_hash.first[:invoice_id]).to eq @invoice.id
    end
  end

  describe "invoice" do
    it "responds with the invoice item's invoice" do
      get :invoice, format: :json, id: @invoice_item.id

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice[:status]).to eq "shipped"
    end
  end

  describe "item" do
    it "responds with the invoice item's item" do
      get :item, format: :json, id: @invoice_item.id

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(invoice[:name]).to eq "Chair"
    end
  end
end
