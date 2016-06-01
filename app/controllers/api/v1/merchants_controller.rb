module Api
  module V1
    class MerchantsController < ApiController
      respond_to :json

      def index
        respond_with Merchant.all
      end

      def show
        respond_with Merchant.find(params[:id])
      end

      def random
        respond_with Merchant.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with Merchant.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with Merchant.custom_where(key, params[key])
      end
    end
  end
end
