# frozen_string_literal: true

module SmartIgnoredColumns
  # @private
  class IgnoredColumn
    def self.all
      list = []

      ActiveRecord::Base.descendants.each do |klass|
        next if klass.abstract_class?

        if klass.smart_ignored_columns.any?
          list << [klass, klass.smart_ignored_columns]
        end
      end

      list
    end

    def self.obsolete
      list = []

      all.each do |klass, columns|
        obsolete_columns = columns.select(&:obsolete?)
        if obsolete_columns.any?
          list << [klass, obsolete_columns]
        end
      end

      list
    end

    attr_reader :name, :remove_after

    def initialize(name, remove_after)
      @name = name.to_s

      @remove_after =
        if remove_after.is_a?(String)
          Date.parse(remove_after)
        else
          remove_after
        end
    end

    def obsolete?
      @remove_after < Date.today
    end
  end
end
