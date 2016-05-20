
##TODO: Remove once implemented correctly on AWS -jv
module EnvironmentVariables
  class Application < Rails::Application
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'environment.yml')
      if File.exists?(env_file)
        YAML.load_file(env_file)[Rails.env].each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end
  end
end