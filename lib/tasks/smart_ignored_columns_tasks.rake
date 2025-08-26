# frozen_string_literal: true

namespace :smart_ignored_columns do
  desc "Show a list of obsolete `ignored_columns`"
  task obsolete: :environment do
    Rails.application.eager_load!

    list = SmartIgnoredColumns::IgnoredColumn.obsolete

    if list.any?
      puts "The following `ignored_columns` definitions are obsolete and can be removed:\n\n"

      list.each do |klass, ignored_columns|
        puts klass.name
        ignored_columns.each do |column|
          puts " - #{column.name} (remove after #{column.remove_after})"
        end
      end

      exit(1)
    else
      puts "No obsolete `ignored_columns` definitions found."
    end
  end

  desc "Show a list of `ignored_columns`"
  task list: :environment do
    Rails.application.eager_load!

    list = SmartIgnoredColumns::IgnoredColumn.all

    if list.any?
      list.each do |klass, ignored_columns|
        puts klass.name
        ignored_columns.each do |column|
          puts " - #{column.name} (remove after #{column.remove_after})"
        end
      end
    else
      puts "No `ignored_columns` definitions found."
    end
  end
end
