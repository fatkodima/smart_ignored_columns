# frozen_string_literal: true

require "smart_ignored_columns"
require "minitest/autorun"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Base.logger = nil
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :email
    t.string :name
  end
end

class User < ActiveRecord::Base
  self.ignored_columns += [
    { name: "name", remove_after: "2025-08-24" }
  ]
end
