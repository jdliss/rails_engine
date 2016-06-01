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

  describe "find" do
    it "responds with a merchant matching passed id" do
      id = @merchant.id
      get :find, format: :json, id: id

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash[:name]).to eq "Bob's House of Boats"
    end

    it "responds with a merchant matching passed name (case insensitive)" do
      name = @merchant.name.downcase
      get :find, format: :json, name: name

      merchant_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(merchant_hash[:name]).to eq "Bob's House of Boats"
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
end
