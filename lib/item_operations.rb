
module Aws
  module Record

    module ItemOperations
      module ItemOperationsClassMethods
        alias_method :original_find, :find

        def find(opts)
          if (!self.table_exists?)
            migration = Aws::Record::TableMigration.new(self)
            migration.create!(provisioned_throughput: { read_capacity_units: Rails.configuration.environment.fetch("read_capacity_units").to_i, write_capacity_units: Rails.configuration.environment.fetch("write_capacity_units").to_i })
            migration.wait_until_available
          end
          original_find(opts)
        end

      end
    end

    module Query
      module QueryClassMethods
        alias_method :orginal_scan, :scan

        def scan(opts = {})
          if (!self.table_exists?)
            migration = Aws::Record::TableMigration.new(self)
            migration.create!(provisioned_throughput: { read_capacity_units: Rails.configuration.environment.fetch("read_capacity_units").to_i, write_capacity_units: Rails.configuration.environment.fetch("write_capacity_units").to_i })
            migration.wait_until_available
          end
          orginal_scan(opts)
        end
      end
    end
  end
end