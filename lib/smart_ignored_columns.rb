# frozen_string_literal: true

require "active_record"

require_relative "smart_ignored_columns/ignored_column"
require_relative "smart_ignored_columns/extension"
require_relative "smart_ignored_columns/version"

ActiveSupport.on_load(:active_record) do
  singleton_class.prepend(SmartIgnoredColumns::Extension)
end

require "smart_ignored_columns/railtie" if defined?(Rails)
