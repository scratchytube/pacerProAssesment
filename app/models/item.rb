class Item < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    # Scope to retrieve only deleted items
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }

    # Scope to retrieve all items, including deleted ones
    scope :with_deleted, -> { unscope(where: :deleted_at) }

    # Marks the item as deleted by setting the deleted_at timestamp
    def soft_delete
        update(deleted_at: Time.current)
    end

    # Restores the item by setting the deleted_at to nil
    def restore
        update(deleted_at: nil)
    end
end
