module Api
  module V1
    class ItemsController < SuperController
      create_methods :invoice_items, :merchant

      def most_items
        respond_with Item.most_items(params[:quantity])
      end

      def most_revenue
        respond_with Item.most_revenue(params[:quantity])
      end
    end
  end
end
