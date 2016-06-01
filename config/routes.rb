Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'items/random', to: 'items#random'
      get 'items/find', to: 'items#find'
      get 'items/find_all', to: 'items#find_all'
      resources :items, except: [:new, :edit]

      get 'customers/random', to: 'customers#random'
      get 'customers/find', to: 'customers#find'
      get 'customers/find_all', to: 'customers#find_all'
      resources :customers, except: [:new, :edit]

      get 'merchants/random', to: 'merchants#random'
      get 'merchants/find', to: 'merchants#find'
      get 'merchants/find_all', to: 'merchants#find_all'
      resources :merchants, except: [:new, :edit]

      get 'invoices/random', to: 'invoices#random'
      get 'invoices/find', to: 'invoices#find'
      get 'invoices/find_all', to: 'invoices#find_all'
      resources :invoices, except: [:new, :edit]

      get 'invoice_items/random', to: 'invoice_items#random'
      get 'invoice_items/find', to: 'invoice_items#find'
      get 'invoice_items/find_all', to: 'invoice_items#find_all'
      resources :invoice_items, except: [:new, :edit]

      get 'transactions/random', to: 'transactions#random'
      get 'transactions/find', to: 'transactions#find'
      get 'transactions/find_all', to: 'transactions#find_all'
      resources :transactions, except: [:new, :edit]
    end
  end
end
