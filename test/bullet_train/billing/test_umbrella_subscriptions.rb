# frozen_string_literal: true

require "test_helper"

class BulletTrain::Billing::TestUmbrellaSubscriptions < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BulletTrain::Billing::UmbrellaSubscriptions::VERSION
  end
end
