$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pipefy'
require 'vcr'

require 'dotenv'
Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<PIPEFY_EMAIL>') { ENV['PIPEFY_EMAIL'] }
  c.filter_sensitive_data('<PIPEFY_TOKEN>') { ENV['PIPEFY_TOKEN'] }
  c.filter_sensitive_data('<PIPEFY_SESSION_COOKIE>') do |interaction|
    cookies = interaction.response.headers['Set-Cookie']
    cookies.find {|x| x =~ /_pipefy_session/i } unless cookies.nil?
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

Pipefy::Config.email=ENV['PIPEFY_EMAIL']
Pipefy::Config.token=ENV['PIPEFY_TOKEN']
Pipefy::Config.http_log=ENV['PIPEFY_HTTP_LOG']

Pipefy::Config.logger=Logger.new('log/test.log')
Pipefy::Config.logger.level = Logger::DEBUG