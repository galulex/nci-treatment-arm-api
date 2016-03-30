module TreatmentArmRestfulApi
  class Application < Rails::Application
    attr_reader :VERSION

    def VERSION
      @VERSION ||= "0.0.5"
    end
  end
end