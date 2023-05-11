class Billing::Umbrella::Subscription < ApplicationRecord
  belongs_to :team
  belongs_to :covering_team, class_name: 'Team'
end
