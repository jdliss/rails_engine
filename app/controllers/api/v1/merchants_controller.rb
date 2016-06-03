module Api
  module V1
    class MerchantsController < SuperController
      def revenue
        respond_with @object.revenue(params[:date])
      end

      def most_revenue
        respond_with Merchant.most_revenue(params[:quantity])
      end

      def most_items
        respond_with Merchant.most_items(params[:quantity])
      end
    end
  end
end
