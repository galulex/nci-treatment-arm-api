
module Aws
  module Record
    module ItemOperations
      module ItemOperationsClassMethods
        alias_method :original_find, :find

        def find(opts)
          if (!self.table_exists?)
                migration = Aws::Record::TableMigration.new(self)
                migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
                migration.wait_until_available
          end
          original_find(opts)
        end

      end
    end
  end
end