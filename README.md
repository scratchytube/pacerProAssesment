# README

Before setting up the project, ensure you have the following installed:
- Ruby 3.2.2
- Rails 7.1.2
- PostgreSQL (ensure it's running in the background)

Clowe down this repo and cd into it.
Install dependencies with the `bundle install` command

Set up your PostgreSQL database with:
rails db:create
rails db:migrate

You're ready to run tests now. Since we only have one test for our Item model we can run
`bundle exec rspec --format documentation` for more descriptive test results. 

The soft delete feature in your Ruby on Rails model works like this: instead of completely removing a deleted item from the database, it just marks it with a special timestamp in the deleted_at column. This way, the item is treated as deleted in normal use, but it's still there in the database if you need it. We then use different query filters to either see or ignore these marked items.

Let's go line by line and see what the Item model is doing for us.

This line set the default scope for all inquries made to the Item model and excludes any items that have been soft deleted.
  `default_scope { where(deleted_at: nil) }`

This removes the default scope condition and retreives items that have been soft deleted.
  `scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }`

This queries everything
  `scope :with_deleted, -> { unscope(where: :deleted_at) }`

This method "soft deletes" an item. It updates the 'deleted_at' column to the current time.
  `def soft_delete
      update(deleted_at: Time.current)
  end`

This method updates the 'deleted_at' column back to 'nil' which it makes it eligible to be queried again.
  `def restore
    update(deleted_at: nil)
  end`

