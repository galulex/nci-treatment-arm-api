module TreatmentArmApi
  class Application < Rails::Application
    attr_reader :version

    def version
      @version ||= "0.0.9"
    end
  end
end
