module TreatmentArmRestfulApi
  class Application < Rails::Application
    attr_reader :VERSION

    def VERSION
      @VERSION ||= "0.0.7"
    end
  end
end
