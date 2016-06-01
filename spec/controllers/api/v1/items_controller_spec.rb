require "rails_helper"

RSpec.describe Api::V1::ItemsController do
  before(:each) do
    merchant = Merchant.create(name: "a merchant has no name")
    @item = Item.create(
      name: "GoPro",
      description: "Cool camera.",
      unit_price: 3600,
      merchant_id: merchant.id
    )

    Item.create(
      name: "Driving Gloves",
      description: "Gloves for driving.",
      unit_price: 9600,
      merchant_id: merchant.id
    )

  end

  describe "index" do
    it "responds with an index of items" do

      get :index, format: :json
      items_hash = JSON.parse(response.body, symbolize_names: true)
      first_item = items_hash.first
      second_item = items_hash.last

      expect(response).to have_http_status(:success)
      expect(first_item[:name]).to eq "GoPro"
      expect(first_item[:description]).to eq "Cool camera."

      expect(second_item[:name]).to eq "Driving Gloves"
      expect(second_item[:description]).to eq "Gloves for driving."
    end
  end

  describe "show" do
    it "responds with the requested item" do
      id = @item.id
      get :show, format: :json, id: id

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash[:name]).to eq "GoPro"
      expect(item_hash[:description]).to eq "Cool camera."
    end
  end

  describe "random" do
    it "responds with a random item" do
      get :random, format: :json

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash).to_not eq nil
      expect(item_hash[:name]).to_not eq nil
      expect(item_hash[:description]).to_not eq nil
    end
  end

  describe "find" do
    it "responds with an item matching passed id" do
      id = @item.id
      get :find, format: :json, id: id

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash[:name]).to eq "GoPro"
      expect(item_hash[:description]).to eq "Cool camera."
    end

    it "responds with an item matching passed name (case insensitive)" do
      name = @item.name.downcase
      get :find, format: :json, name: name

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash[:name]).to eq "GoPro"
      expect(item_hash[:description]).to eq "Cool camera."
    end
  end

  describe "find_all" do
    it "responds with all items matching passed id" do
      Item.create(name: @item.name, description: "another of the same")
      id = @item.id
      get :find_all, format: :json, id: id

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash.count).to eq 1
      expect(item_hash.first[:name]).to eq "GoPro"
      expect(item_hash.first[:description]).to eq "Cool camera."
    end

    it "responds with all items matching passed name (case insensitive)" do
      Item.create(name: @item.name, description: "another of the same")
      name = @item.name.downcase
      get :find_all, format: :json, name: name

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(item_hash.count).to eq 2
      expect(item_hash.first[:name]).to eq "GoPro"
      expect(item_hash.first[:description]).to eq "Cool camera."
    end
  end
end
