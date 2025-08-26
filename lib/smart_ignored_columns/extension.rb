# frozen_string_literal: true

module SmartIgnoredColumns
  # Includes extension of the `ignored_columns=` method.
  #
  module Extension
    # Extension of the default `ignored_columns=` method with an ability to specify deadlines.
    #
    # @example
    #   class User < ApplicationRecord
    #     self.ignored_columns += [
    #       { name: "first_name", remove_after: "2025-08-24" },       # date can be a String
    #       { name: "bio", remove_after: Date.parse("2025-08-24") },  # or a Date object
    #     ]
    #   end
    #
    def ignored_columns=(columns)
      columns = columns.flatten

      all_columns_valid = columns.all? do |column|
        column.is_a?(Hash) && column.key?(:name) && column.key?(:remove_after)
      end

      unless all_columns_valid
        raise ArgumentError, "columns should be an array of hashes, each containing :name and :remove_after options"
      end

      super(columns.pluck(:name))

      self.smart_ignored_columns += columns.map do |column|
        IgnoredColumn.new(column[:name], column[:remove_after])
      end
    end

    # @private
    def smart_ignored_columns
      @smart_ignored_columns || superclass.try(:smart_ignored_columns) || []
    end

    # @private
    def smart_ignored_columns=(columns)
      @smart_ignored_columns = columns
    end
  end
end
