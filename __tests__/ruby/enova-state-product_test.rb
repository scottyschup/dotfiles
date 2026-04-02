#!/usr/bin/env ruby

require 'minitest/autorun'

TEST_ROOT = File.expand_path(__dir__)
REPO_ROOT = File.expand_path('../..', TEST_ROOT)

load File.join(REPO_ROOT, 'scripts', 'enova-state-product')

class EnovaStateProductTest < Minitest::Test
  def test_default_run_uses_de_netcredit
    helper = StateProductHelper.new

    assert_output("DE netcredit\n") { helper.run }
  end

  def test_ccb_line_of_credit_uses_expected_product
    helper = StateProductHelper.new(ccb: true, lineofcredit: true)

    assert_output("SC netcredit_bank_partnership_ccb_loc\n") { helper.run }
  end

  def test_multi_product_with_rbt_defaults_state
    helper = StateProductHelper.new(rbt: true, multi: true)

    assert_output("FL \n") { helper.run }
  end

  def test_multiple_lenders_are_rejected
    helper = StateProductHelper.new(ccb: true, rbt: true)

    error = assert_raises(ArgumentError) { helper.validate! }
    assert_equal 'You cannot specify multiple lenders.', error.message
  end
end
