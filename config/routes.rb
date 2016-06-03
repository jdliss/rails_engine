Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :items, only: [:show, :index] do
        collection do
          get '/random', to: 'items#random'
          get '/find', to: 'items#show'
          get '/find_all', to: 'items#find_all'
          get '/most_items', to: "items#most_items"
          get '/most_revenue', to: "items#most_revenue"
        end
        member do
          get '/invoice_items', to: 'items#invoice_items'
          get '/merchant', to: 'items#merchant'
        end
      end

      resources :customers, only: [:show, :index] do
        collection do
          get '/random', to: 'customers#random'
          get '/find', to: 'customers#show'
          get '/find_all', to: 'customers#find_all'
        end
        member do
          get '/invoices', to: 'customers#invoices'
          get '/transactions', to: 'customers#transactions'
        end
      end

      resources :merchants, only: [:show, :index] do
        collection do
          get '/random', to: 'merchants#random'
          get '/find', to: 'merchants#show'
          get '/find_all', to: 'merchants#find_all'
          get '/most_revenue', to: 'merchants#most_revenue'
          get '/most_items', to: 'merchants#most_items'
        end
        member do
          get '/items', to: 'merchants#items'
          get '/invoices', to: 'merchants#invoices'
          get '/revenue', to: 'merchants#revenue'
        end
      end

      resources :invoices, only: [:show, :index] do
        collection do
          get '/random', to: 'invoices#random'
          get '/find', to: 'invoices#show'
          get '/find_all', to: 'invoices#find_all'
        end
        member do
          get '/transactions', to: 'invoices#transactions'
          get '/invoice_items', to: 'invoices#invoice_items'
          get '/items', to: 'invoices#items'
          get '/customer', to: 'invoices#customer'
          get '/merchant', to: 'invoices#merchant'
        end
      end

      resources :invoice_items, only: [:show, :index] do
        collection do
          get '/random', to: 'invoice_items#random'
          get '/find', to: 'invoice_items#show'
          get '/find_all', to: 'invoice_items#find_all'
        end
        member do
          get '/invoice', to: 'invoice_items#invoice'
          get '/item', to: 'invoice_items#item'
        end
      end

      resources :transactions, only: [:show, :index] do
        collection do
          get '/random', to: 'transactions#random'
          get '/find', to: 'transactions#show'
          get '/find_all', to: 'transactions#find_all'
        end
        member do
          get 'invoice', to: 'transactions#invoice'
        end
      end
    end
  end
end
