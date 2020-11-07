module Spree
  module Api
    module V2
      module Storefront
        class WholesaleCartController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers
          include Spree::Api::V2::Storefront::OrderConcern
          before_action :ensure_ws_order, except: :create
          before_action :require_spree_current_user

          def show
            pp "#########################"
            pp "#########################"
            pp "#########################"
            pp "#########################"
            pp "#########################"

            spree_authorize! :show, spree_current_order, order_token

            render_serialized_payload { serialize_resource(resource) }
          end

          def add_item
          end

          def empty
          end

          def remove_line_item
          end

          def set_quantity
          end

          private

          # THIS HAS BEEN MOVED TO BASE CONTROLLER
          def serialize_resource(resource)
            resource_serializer.new(
              resource,
              include: resource_includes,
              fields: sparse_fields
            ).serializable_hash
          end

          def resource
            spree_current_order.wholesale_order
            # scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::WholesaleCartSerializer
          end

          def scope
            Spree::WholesaleOrder.accessible_by(current_ability, :show).includes(scope_includes)
          end

          def current_ability
            @current_ability ||= Spree::WholesalerAbility.new(spree_current_user)
          end

          def scope_includes
            {
              user: {}
            }
          end


          def ensure_ws_order
            raise ActiveRecord::RecordNotFound if spree_current_ws_order.nil?
          end

          def order_token
            request.headers['X-Spree-Order-Token'] || params[:order_token]
          end

          def spree_current_ws_order
            @spree_current_order ||= find_spree_current_ws_order
          end

          def find_spree_current_ws_order
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            pp current_store
            pp spree_current_user
            pp order_token
            pp current_currency
            pp Spree::Order.all
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            pp "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            o = Spree::Api::Dependencies.storefront_current_order_finder.constantize.new.execute(
              store: current_store,
              user: spree_current_user,
              token: order_token,
              currency: current_currency
            )
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp o
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            return o
          end
        end
      end
    end
  end
end