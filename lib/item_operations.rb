
module Aws
  module Record


    def create_table
      if (!self.table_exists?)
        migration = Aws::Record::TableMigration.new(self)
        migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
        migration.wait_until_available
      end
    end

    module ItemOperations
      module ItemOperationsClassMethods
        alias_method :original_find, :find

        def find(opts)
          create_table
          original_find(opts)
        end

      end
    end

    module Query
      module QueryClassMethods
        alias_method :orginal_scan, :scan

        def scan(opts = {})
          create_table
          orginal_scan(opts)
        end
      end
    end
  end
end