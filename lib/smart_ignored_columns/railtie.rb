# frozen_string_literal: true

module SmartIgnoredColumns
  # @private
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/smart_ignored_columns_tasks.rake"
    end
  end
end
