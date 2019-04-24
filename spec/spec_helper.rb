require_relative '../lib/alfaces_bot.rb'

current_environment = ENV.fetch('ENV', '')
unless %w(test development).include?(current_environment)
  fail 'Runnig without development|test flag, this is dangerous'
end

Bundler.require(:default, :development, :test)
Timecop.freeze(Time.now)
require 'database_cleaner'

DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
