Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do

      namespace :storefront do
        resources :wholesalers, only: [:show, :index]
        resource :wholesale_cart, controller: :wholesale_cart, only: %i[show create] do
          post   :add_item
          patch  :empty
          delete 'remove_line_item/:line_item_id', to: 'wholesaler_cart#remove_line_item', as: :wholesale_cart_remove_line_item
          patch  :set_quantity
        end

      end
    end
  end
end
