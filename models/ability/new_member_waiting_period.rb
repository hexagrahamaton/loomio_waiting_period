module Ability
  module NewMemberWaitingPeriod
    def initialize(user)
      super(user)

      # This gets applied after all the core Abilities. Can rules
      # get ORed together, but the Cannot rule will short-circuit
      # that behavior.
      cannot :vote_in, ::Poll do |poll|
        user&.user_meta&.joined_at > DateTime.now.days_ago(30)
      end
    end
  end
end
