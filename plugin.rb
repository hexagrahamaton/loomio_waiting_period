module Plugins
    module NewMemberWaitingPeriod
        class Plugin < Plugins::Base
            setup! :new_member_waiting_period do |plugin|
                plugin.enabled = true

                plugin.use_class 'models/ability/new_member_waiting_period'
                plugin.extend_class Ability::Base do
                    prepend Ability::NewMemberWaitingPeriod
                end

            end
        end
    end
end
