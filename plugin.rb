module Plugins
  module NewMemberWaitingPeriod
    class Plugin < Plugins::Base
      setup! :new_member_waiting_period do |plugin|
        plugin.enabled = true

        plugin.use_class 'models/ability/new_member_waiting_period'
        require "#{File.dirname(__FILE__)}/models/user_meta"

        plugin.use_database_table :user_meta do |table|
          table.belongs_to :user
          table.datetime :joined_at
        end

        plugin.extend_class Ability::Base do
          prepend Ability::NewMemberWaitingPeriod
        end

        User.class_eval do
          has_one :user_meta, dependent: :destroy, autosave: true

          before_create do
            self.create_meta
          end

          def create_meta(date = DateTime.now.days_ago(30))
            if !self.user_meta
              self.user_meta = UserMeta.new(joined_at: date)
            end
          end
        end

        User.all.each do |user|
          user.create_meta
        end
      end
    end
  end
end

