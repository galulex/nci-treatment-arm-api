class Ability
  include CanCan::Ability

  attr_reader :methods

  def initialize(user = {})
    user.deep_symbolize_keys!
    user = user.dig(:roles) || []
    user.each do |role|
      begin
        methods << "NciMatchRoles::#{role.downcase.classify}".constantize.get_methods
      rescue NameError
        methods = []
      end
    end
    can methods, :all
  end

  def methods
    @methods ||= []
  end
end

NciMatchRoles::System.instance_eval { def get_methods; :manage; end }
NciMatchRoles::Admin.instance_eval { def get_methods; :manage; end }
