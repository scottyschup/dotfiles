#!/usr/bin/env ruby

require 'minitest/autorun'
require 'open3'

TEST_ROOT = File.expand_path(__dir__)
REPO_ROOT = File.expand_path('../..', TEST_ROOT)

class RemindMeTest < Minitest::Test
  def test_prints_a_box_around_the_message
    stdout, stderr, status = Open3.capture3(
      File.join(REPO_ROOT, 'scripts', 'remind_me'),
      'buy', 'milk'
    )

    assert_predicate status, :success?
    assert_equal '', stderr
    assert_includes stdout, 'buy milk'
    assert_includes stdout, '*'
  end
end
