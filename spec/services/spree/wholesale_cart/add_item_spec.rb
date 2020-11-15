require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::AddItem do
    let(:order) { create(:order) }
    let(:wholesale_order) { create(:wholesale_order) }
    let(:current_wholesale_total) { wholesale_order.wholesale_item_total }
    let(:current_retail_total) { wholesale_order.retail_item_total }
    let(:variant) { create(:variant) }
    let(:qty) { 2 }

    subject { described_class }

    context 'adds an item to a wholesale order' do
      let(:execute) { subject.call wholesale_order: wholesale_order,  variant: variant, quantity: qty}
      let(:value) { execute.value }
      let(:expected) { WholesaleLineItem.last }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        current_item_count = wholesale_order.item_count
        expect { execute }.to change(WholesaleLineItem, :count)
        wholesale_order.reload
        expect(execute).to be_success
        expect(value[:wholesale_line_item]).to eq expected
        expect(value[:wholesale_order]).to eq wholesale_order
        expect(expected.quantity).to eq qty
        expect(wholesale_order.wholesale_item_total).to eq(current_wholesale + (expected.wholesale_price * expected.quantity))
        expect(wholesale_order.retail_item_total).to eq(current_retail + (expected.retail_price * expected.quantity))
        expect(wholesale_order.item_count).to eq(current_item_count + qty)
      end

      context 'locked wholesale order' do
        before do
          wholesale_order.update_columns(locked: true)
          execute
        end

        it do
          expect(execute).to_not be_success
        end
      end
    end

  end
end