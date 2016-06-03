module Api
  module V1
    class SuperController < ApiController
      respond_to :json
      before_action :find_object, except: [
        :index, :show, :random, :find_all, :most_revenue, :most_items
      ]

      def index
        respond_with model.all
      end

      def show
        key, val = clean_params(params)
        respond_with model.find_by(key => val)
      end

      def random
        respond_with model.limit(1).order("RANDOM()").first
      end

      def find_all
        key, val = clean_params(params)
        respond_with model.where(key => val)
      end

      private

      def model
        controller_name.classify.constantize
      end

      def clean_params(params)
        ["format", "controller", "action"].each do |key|
          params.delete(key)
        end
        key = params.keys.first
        val = parse_value(key, params[key])
        [key, val]
      end

      def parse_value(key, val)
        key == "unit_price" ? (val.to_f*100).round(2) : val
      end

      def find_object
        @object = model.find(params[:id])
      end

      def action_missing(name)
        begin
          self.send(name)
        rescue
          if @object.respond_to?(name)
            respond_with @object.send(name)
          else
            raise
          end
        end
      end
    end
  end
end
