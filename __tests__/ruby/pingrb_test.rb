#!/usr/bin/env ruby

require 'minitest/autorun'

TEST_ROOT = File.expand_path(__dir__)
REPO_ROOT = File.expand_path('../..', TEST_ROOT)
SUPPORT_ROOT = File.join(TEST_ROOT, 'support')

$LOAD_PATH.unshift(SUPPORT_ROOT)
load File.join(REPO_ROOT, 'scripts', 'pingrb')

class PingRbArgsTest < Minitest::Test
  def setup
    PingRb.class_eval do
      def pingable?
        true
      end

      def random_color
        :cyan
      end
    end
  end

  def test_initialize_with_defaults
    ping = PingRb.new(url: 'example.com')

    assert_equal 'example.com', ping.url
    assert_equal 1, ping.count
    assert_equal 'example.com', ping.name
    assert_equal :cyan, ping.color
  end

  def test_initialize_with_custom_values
    ping = PingRb.new(url: 'example.com', count: 3, name: 'Example', color: :red)

    assert_equal 'example.com', ping.url
    assert_equal 3, ping.count
    assert_equal 'Example', ping.name
    assert_equal :red, ping.color
  end

  def test_ping_tracker_defaults_to_google
    tracker = PingTracker.new
    pings = tracker.instance_variable_get(:@pings)

    assert_equal 1, pings.length
    assert_equal 'google.com', pings.first.url
    assert_equal 10, pings.first.count
    assert_equal :white, pings.first.color
  end

  def test_ping_tracker_accepts_multiple_argument_hashes
    tracker = PingTracker.new([
      { url: 'alpha.example', count: 2, name: 'Alpha', color: :blue },
      { url: 'beta.example', count: 4, name: 'Beta', color: :yellow },
    ])

    pings = tracker.instance_variable_get(:@pings)

    assert_equal 2, pings.length
    assert_equal %w[Alpha Beta], pings.map(&:name)
    assert_equal [2, 4], pings.map(&:count)
    assert_equal %i[blue yellow], pings.map(&:color)
  end
end