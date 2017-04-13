# Gets Triggered when COG is down or when Failed to connect to COG
class MockCogService
  include HTTParty
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  def self.perform(treatment_arms)
    begin
      Rails.logger.info('===== Mock COG service is Triggered to get the Latest TreatmentArm status =====')
      result = []
      response = HTTParty.get(Rails.configuration.environment.fetch('mock_cog_url') + Rails.configuration.environment.fetch('cog_treatment_arms'))
      cog_arms = response.parsed_response.deep_transform_keys!(&:underscore).symbolize_keys
      treatment_arms.each do |treatment_arm|
        next if treatment_arm.active == false
        cog_arms[:treatment_arms].each do |cog_arm|
          if TreatmentArm.cog_check_condition(cog_arm, treatment_arm)
            Rails.logger.info('===== Change in the TreatmentArm Status detected while comparing with COG. Saving Changes to the DataBase =====')
            #Temp fix...uuid needs to be passed from the controller...currently just making a new one to get things to pass
            Aws::Sqs::Publisher.publish({cog_treatment_refresh: treatment_arm.attributes_data}, SecureRandom.uuid)
            treatment_arm.treatment_arm_status = cog_arm['status']
          end
        end
        result << treatment_arm
      end
      result
    rescue => error
      Rails.logger.info("Failed Connecting to Mock COG with Error :: #{error}")
    end
  end
end

