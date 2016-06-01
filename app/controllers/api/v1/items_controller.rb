module Api
  module V1
    class ItemsController < ApiController
      respond_to :json

      def index
        respond_with Item.all
      end

      def show
        respond_with Item.find(params[:id])
      end

      def random
        respond_with Item.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with Item.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with Item.custom_where(key, params[key])
      end
    end
  end
end
