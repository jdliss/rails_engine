Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :items, only: [:show, :index] do
        collection do
          get 'items/random', to: 'items#random'
          get 'items/find', to: 'items#show'
          get 'items/find_all', to: 'items#find_all'
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
        collection do
          get '/invoices', to: 'customers#invoices'
          get '/transactions', to: 'customers#transactions'
        end
      end

      resources :merchants, only: [:show, :index] do
        collection do
          get '/random', to: 'merchants#random'
          get '/find', to: 'merchants#show'
          get '/find_all', to: 'merchants#find_all'
        end
        member do
          get '/items', to: 'merchants#items'
          get '/invoices', to: 'merchants#invoices'
        end
      end

      resources :invoices, only: [:show, :index] do
        collection do
          get 'invoices/random', to: 'invoices#random'
          get 'invoices/find', to: 'invoices#show'
          get 'invoices/find_all', to: 'invoices#find_all'
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
          get 'invoice_items/random', to: 'invoice_items#random'
          get 'invoice_items/find', to: 'invoice_items#show'
          get 'invoice_items/find_all', to: 'invoice_items#find_all'
        end
        member do
          get '/invoice', to: 'invoice_items#invoice'
          get '/item', to: 'invoice_items#item'
        end
      end

      resources :transactions, only: [:show, :index] do
        collection do
          get 'transactions/random', to: 'transactions#random'
          get 'transactions/find', to: 'transactions#show'
          get 'transactions/find_all', to: 'transactions#find_all'
        end
        member do
          get 'invoice', to: 'transactions#invoice'
        end
      end
    end
  end
end
