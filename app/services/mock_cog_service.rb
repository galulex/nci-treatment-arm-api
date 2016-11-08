# Gets Triggered when COG is down or when Failed to connect to COG
class MockCogService
  include HTTParty
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  def self.perform
    puts "Mock COG service is Triggered to get the Latest TreatmentArm status"
    result = []
    treatment_arms = TreatmentArm.scan({})
    response = HTTParty.get(Rails.configuration.environment.fetch('mock_cog_url') + Rails.configuration.environment.fetch('cog_treatment_arms'))
    cog_arms = response.parsed_response.deep_transform_keys!(&:underscore).symbolize_keys
    treatment_arms.each do |treatment_arm|
      next if treatment_arm.active == false
      cog_arms[:treatment_arms].each do |cog_arm|
        if cog_arm['stratum_id'] == treatment_arm.stratum_id &&
          cog_arm['treatment_arm_id'] == treatment_arm.treatment_arm_id &&
          treatment_arm.treatment_arm_status != 'CLOSED' &&
          treatment_arm.treatment_arm_status != cog_arm['status']
          Aws::Publisher.publish(cog_treatment_refresh: treatment_arm.attributes_data)
          treatment_arm.treatment_arm_status = cog_arm['status']
        end
      end
      result << treatment_arm
    end
  result
  end
end