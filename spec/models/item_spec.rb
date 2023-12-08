require 'rails_helper'

RSpec.describe Item, type: :model do
  
  let(:item) { Item.create!(name: "Test Item", deleted_at: nil) }

  describe 'soft delete' do
    before { item.soft_delete }

    it 'marks an item as soft deleted' do
      expect(item.deleted_at).not_to be_nil
      expect(item.deleted_at).to be_within(1.minute).of(Time.current)
    end
  end

  describe 'restore' do
    before do
      item.soft_delete
      item.restore
    end

    it 'restores a soft deleted item' do
      expect(item.deleted_at).to be_nil
    end
  end

  describe 'default scope' do
    let!(:soft_deleted_item) { Item.create!(name: "Deleted Item", deleted_at: Time.current) }

    it 'excludes soft deleted items from normal queries' do
      expect(Item.all).not_to include(soft_deleted_item)
    end
  end


end
