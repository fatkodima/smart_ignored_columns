# frozen_string_literal: true

require "test_helper"

class IgnoredColumnsTest < Minitest::Test
  def test_raises_when_using_old_ignored_columns_format
    e = assert_raises(ArgumentError) do
      Class.new(ActiveRecord::Base) do
        self.ignored_columns += [:name]
      end
    end

    assert_match(/columns should be an array of hashes/, e.message)
  end

  def test_requires_specific_definition_format
    e = assert_raises(ArgumentError) do
      Class.new(ActiveRecord::Base) do
        self.ignored_columns += [
          { name: "email", remove_after: "2025-08-24" },
          { name: "name" }
        ]
      end
    end

    assert_match(/each containing :name and :remove_after options/, e.message)
  end

  def test_correctly_assigns_ignored_columns
    assert_equal(["name"], User.ignored_columns)
    assert_equal(["id", "email"], User.column_names)
  end

  def test_obsolete_ignored_columns
    Date.stub(:today, Date.parse("2024-08-24")) do
      assert_empty(SmartIgnoredColumns::IgnoredColumn.obsolete)
    end

    Date.stub(:today, Date.parse("2026-08-24")) do
      assert_equal(1, SmartIgnoredColumns::IgnoredColumn.obsolete.size)
    end
  end
end
