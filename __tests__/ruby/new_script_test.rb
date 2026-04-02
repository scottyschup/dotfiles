#!/usr/bin/env ruby

require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'tmpdir'

TEST_ROOT = File.expand_path(__dir__)
REPO_ROOT = File.expand_path('../..', TEST_ROOT)

class NewScriptTest < Minitest::Test
  def setup
    @temp_dir = Dir.mktmpdir('new-script-test')
    @scripts_dir = File.join(@temp_dir, 'scripts')
    FileUtils.mkdir_p(@scripts_dir)

    @script_path = File.join(@scripts_dir, 'new_script')
    FileUtils.cp(File.join(REPO_ROOT, 'scripts', 'new_script'), @script_path)
    FileUtils.chmod(0o755, @script_path)

    @fake_bin = File.join(@temp_dir, 'bin')
    FileUtils.mkdir_p(@fake_bin)
  end

  def teardown
    FileUtils.rm_rf(@temp_dir)
  end

  def test_creates_default_ruby_script_and_invokes_editor
    editor_log = File.join(@temp_dir, 'editor.log')
    create_fake_editor(File.join(@fake_bin, 'code'), editor_log)

    stdout, stderr, status = run_new_script('demo_script')

    assert_predicate status, :success?
    assert_equal '', stderr
    created_file = File.join(@scripts_dir, 'demo_script')
    assert File.exist?(created_file)
    assert_equal '#!/usr/bin/env ruby -w', File.readlines(created_file, chomp: true).first
    assert_includes File.read(created_file), "require_relative '../lib/rb/cli_utils'"
    assert_includes File.read(editor_log), created_file
    assert_equal '', stdout
  end

  def test_creates_non_ruby_script_with_language_shebang
    editor_log = File.join(@temp_dir, 'editor.log')
    create_fake_editor(File.join(@fake_bin, 'code'), editor_log)

    stdout, stderr, status = run_new_script('demo_zsh', 'zsh')

    assert_predicate status, :success?
    assert_equal '', stderr
    created_file = File.join(@scripts_dir, 'demo_zsh')
    assert File.exist?(created_file)
    first_line = File.readlines(created_file, chomp: true).first
    assert_match(%r{^#!}, first_line)
    assert_includes File.read(editor_log), created_file
    assert_equal '', stdout
  end

  private

  def create_fake_editor(path, log_path)
    File.write(path, <<~SH)
      #!/usr/bin/env bash
      set -euo pipefail
      printf '%s\n' "$*" >> #{log_path.inspect}
    SH
    FileUtils.chmod(0o755, path)
  end

  def run_new_script(*args)
    env = {
      'PATH' => "#{@fake_bin}:#{ENV.fetch('PATH')}",
      'HOME' => ENV.fetch('HOME'),
      'DOTFILES' => REPO_ROOT,
    }

    Open3.capture3(env, @script_path, *args)
  end
end
