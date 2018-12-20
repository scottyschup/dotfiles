# NOT IN USE
# The contents of this were copied into .railsrc

# template.rb
# source: http://tonirib.github.io/personal-blog/jekyll/update/2016/02/15/rails-application-template.html

# Remove the gemfile so we can start with a clean slate otherwise Rails groups
# the gems in a very strange way
# remove_file "Gemfile" # skip this if --skip-gemfile is in new-cmd or .railsrc
add_file "Gemfile"

prepend_to_file "Gemfile" do
  "# This Gemfile generated from a template: $DOTFILES/templates/rails_template.rb
source \"https://rubygems.org\""
end

# Add all the regular gems
gem "bcrypt"
gem "figaro"
gem "jbuilder"
gem "pg"
gem "pry-rails"
gem "puma"
gem "rails"
gem "sass-rails"
gem "sdoc", group: :doc

gem_group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug"
  gem "capybara"
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 4.0"
  gem "rspec-rails", "~> 3.0"
  gem "shoulda-matchers", "~> 3.1"
end

gem_group :development do
  gem "quiet_assets"
  gem "spring"
  gem "web-console", "~> 2.0"
end

# Bundle and set up RSpec
run "bundle install"
run "rails generate rspec:install"

# Set up the spec folders for RSpec
run "mkdir spec/models"
run "mkdir spec/controllers"
run "mkdir spec/features"
run "touch spec/factories.rb"

# Inject into the factory girl files
append_to_file "spec/factories.rb" do
  "FactoryGirl.define do\nend"
end

insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  "  config.include FactoryGirl::Syntax::Methods\n"
end

# Set up Database Cleaner
insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  "# added by rails_template.rb
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end"
end

gsub_file "spec/rails_helper.rb",
          "config.use_transactional_fixtures = true",
          "config.use_transactional_fixtures = false # set to false by rails_helper.rb"

# Set up Shoulda Matchers
append_to_file "spec/rails_helper.rb" do
  "# added by rails_template.rb
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end"
end

# Set up for scss and bootstrap
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"
run "touch app/assets/stylesheets/custom.scss"
prepend_to_file "app/assets/stylesheets/custom.scss" do
  "# File created by rails_template.rb"
end

append_to_file "app/assets/stylesheets/application.scss" do
  "\n\nimport \"custom\";"
end

gsub_file "app/assets/stylesheets/application.scss",
          "*= require_tree .",
          ""

gsub_file "app/assets/stylesheets/application.scss",
          "*= require_self",
          ""

insert_into_file "app/views/layouts/application.html.erb", before: "</head>" do
  "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <!-- Added by rails_template.rb -->"
end

# Set up as a git repo and make the first commit
after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit (by rails_template.rb)'"
end
